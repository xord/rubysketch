module RubySketch


  class MML

    TONES = %i[
      sine triangle square sawtooth pulse12_5 pulse25 noise
    ].freeze

    class << self

      def compile(str, streaming = false)
        seq, duration = compile! str
        Sound.new Beeps::Sound.new(seq, streaming ? 0 : duration)
      end

      def compile!(str)
        scanner = StringScanner.new str.gsub(/[;%].*(?:\n|$)/, '')
        seq     = Beeps::Sequencer.new
        note    = Note__.new
        pending = nil
        prevOsc = nil

        scanner.skip(/\s*/)
        until scanner.eos?
          case
          when scanner.scan(/T\s*(\d+)/i)
            note.bpm       = scanner[1].to_i
          when scanner.scan(/O\s*(\d+)/i)
            note.octave    = scanner[1].to_i
          when scanner.scan(/([<>])/)
            note.octave   +=
              case scanner[1]
              when '<' then -1
              when '>' then +1
              else           0
              end
          when scanner.scan(/@\s*(\d+)/)
            note.tone      = scanner[1].to_i
          when scanner.scan(/L\s*(\d+)/i)
            note.length    = scanner[1].to_i
          when scanner.scan(/V\s*(\d+)/i)
            note.velocity  = scanner[1].to_i
          when scanner.scan(/Q\s*(\d+)/i)
            note.quantize  = scanner[1].to_i
          when scanner.scan(/K\s*([+-]?\d+)/i)
            note.transpose = scanner[1].to_i
          when scanner.scan(/Y\s*([+-]?\d+)/i)
            note.detune    = scanner[1].to_i
          when scanner.scan(/&/)
            note.legato    = true
          when scanner.scan(/R\s*(\d+)?/i)
            note.legato    = false
            addNote__ seq, pending, note, prevOsc if pending
            pending        = nil
            prevOsc        = nil
            note.time     += seconds__ scanner[1]&.to_i || note.length, note.bpm
          when scanner.scan(/([CDEFGAB])\s*([#+-]+)?\s*(\d+)?\s*(\.+)?/i)&.chomp
            char, offset, len, dots = [1, 2, 3, 4].map {scanner[_1]}
            sec                     = seconds__ len&.to_i || note.length, note.bpm
            sec                    *= 1 + dots.size.times.map {0.5 ** (_1 + 1)}.sum if dots

            note.frequency = frequency__ char, offset, note.octave, note.transpose, note.detune
            prevOsc        = addNote__ seq, pending, note, prevOsc if pending

            pending          = note.dup
            pending.seconds += sec

            note.legato = false
          else
            raise "Unknown input: #{scanner.rest[..10]}"
          end

          scanner.skip(/\s*/)
        end

        addNote__ seq, pending, note, prevOsc if pending
        return seq, note.time
      end

      def play(str)
        compile(str).play
      end

      private

      V_MAX__ = 127.0
      Q_MAX__ = 100.0

      # @private
      Note__ = Struct.new(
        :time, :frequency, :seconds,
        :bpm, :octave, :tone, :length, :velocity, :quantize, :transpose, :detune,
        :legato) do

        def initialize()
          super(
            0, 1, 0,
            120, 4, 0, 4, V_MAX__, Q_MAX__, 0, 0,
            false)
        end
      end

      # @private
      def seconds__(length, bpm)
        60.0 * 4 / bpm / length
      end

      # @private
      DISTANCES__ = -> {
        notes   = 'c_d_ef_g_a_b'.each_char.with_index.reject {|c,| c == '_'}.to_a
        octaves = (0..11).to_a
        octaves.product(notes)
          .map.with_object({}) {|(octave, (note, index)), hash|
            hash[[note, octave]] = octave * 12 + index - 57
          }
      }.call

      # @private
      def frequency__(note, offset, octave, transpose, detune)
        distance  = DISTANCES__[[note.downcase, octave.to_i]] ||
          (raise ArgumentError, "note:'#{note}' octave:'#{octave}'")
        distance += (offset || '').each_char.reduce(0) {|value, char|
          case char
          when '+', '#' then value + 1
          when '-'      then value - 1
          else               value
          end
        }
        distance += transpose + (detune / 100.0)
        440 * (2 ** (distance.to_f / 12))
      end

      # @private
      def addNote__(seq, note, nextNote, prevOsc)
        processor, sec  = createProcessor__ note, nextNote
        osc             = findInput__(processor) {_1.class == Beeps::Oscillator}
        syncPhase__ osc, prevOsc if prevOsc
        seq.add processor, note.time, sec
        nextNote.time  += note.seconds
        return osc
      end

      # @private
      def createProcessor__(note, nextNote)
        tone = TONES[note.tone] || (raise ArgumentError, "tone:'#{note.tone}'")
        freq = nextNote.legato ? Beeps::Value.new(note.frequency).tap {
          _1.insert nextNote.frequency, note.seconds if nextNote.frequency != note.frequency
        } : note.frequency
        gate = note.quantize.clamp(0, Q_MAX__) / Q_MAX__ * note.seconds
        vel  = note.velocity.clamp(0, V_MAX__) / V_MAX__
        adsr = {
          attack_time:  (    note.legato ? 0 : nil),
          release_time: (nextNote.legato ? 0 : nil)
        }.compact

        osc  = oscillator__ tone, 32, freq: freq
        env  = Beeps::Envelope.new(**adsr) {
          note_on
          note_off nextNote.legato ? note.seconds : (gate - release).clamp(0..)
        }
        gain = Beeps::Gain.new gain: vel
        return (osc >> env >> gain), (nextNote.legato ? note.seconds : gate)
      end

      # @private
      def oscillator__(type, size, **kwargs)
        case type
        when :noise then Beeps::Oscillator.new type
        else
          samples = (@samples ||= {})[type] ||= createSamples__ type, size
          Beeps::Oscillator.new samples: samples, **kwargs
        end
      end

      # @private
      def createSamples__(type, size)
        input = size.times.map {_1.to_f / size}
        duty  = {pulse12_5: 0.125, pulse25: 0.25, pulse75: 0.75}[type] || 0.5
        case type
        when :sine     then input.map {Math.sin _1 * Math::PI * 2}
        when :triangle then input.map {_1 < 0.5 ? _1 * 4 - 1 : 3 - _1 * 4}
        when :sawtooth then input.map {_1 * 2 - 1}
        else                input.map {_1 < duty ? 1 : -1}
        end
      end

      # @private
      def syncPhase__(osc, prev)
        osc.on(:start) {osc.phase = prev.phase}
      end

      # @private
      def findInput__(processor, &block)
        p = processor
        while p
          return p if block.call p
          p = p.input
        end
        nil
      end

    end# <<self

  end# MML


end# RubySketch
