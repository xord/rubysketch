module RubySketch

  pi      = Math::PI
  pi_div2 = pi / 2.0

  c1 = 1.70158
  c2 = c1 * 1.525
  c3 = c1 + 1.0
  c4 = pi * 2 / 3.0
  c5 = pi * 2 / 4.5

  n1 = 7.5625
  d1 = 2.75

  expoInOut = -> x {
    x == 0 ? 0.0 :
    x == 1 ? 1.0 :
    x < 0.5 ?
             2.0 ** ( 20.0 * x - 10.0)  / 2.0 :
      (2.0 - 2.0 ** (-20.0 * x + 10.0)) / 2.0
  }

  circInOut = -> x {
    x < 0.5 ?
      (1.0 - Math.sqrt(1.0 - ( 2.0 * x)       ** 2.0)) / 2.0 :
      (1.0 + Math.sqrt(1.0 - (-2.0 * x + 2.0) ** 2.0)) / 2.0
  }

  backInOut = -> x {
    x < 0.5 ?
      ((2.0 * x)       ** 2.0 * ((c2 + 1.0) * (x * 2.0)       - c2))       / 2.0 :
      ((2.0 * x - 2.0) ** 2.0 * ((c2 + 1.0) * (x * 2.0 - 2.0) + c2) + 2.0) / 2.0
  }

  elasticIn = -> x {
    x == 0 ? 0.0 :
    x == 1 ? 1.0 :
    -(2 ** (10.0 * x - 10.0)) * Math.sin((x * 10.0 - 10.75) * c4)
  }

  elasticOut = -> x {
    x == 0 ? 0.0 :
    x == 1 ? 1.0 :
    2 ** (-10.0 * x) * Math.sin((x * 10.0 - 0.75) * c4) + 1.0
  }

  elasticInOut = -> x {
    x == 0 ? 0.0 :
    x == 1 ? 1.0 :
    x < 0.5 ?
      -(2 ** ( 20.0 * x - 10.0) * Math.sin((20.0 * x - 11.125) * c5)) / 2.0 :
       (2 ** (-20.0 * x + 10.0) * Math.sin((20.0 * x - 11.125) * c5)) / 2.0 + 1.0
  }

  bounceOut = -> x {
    x < 1.0 / d1 ? n1 * x ** 2                         :
    x < 2.0 / d1 ? n1 * (x -= 1.5   / d1) * x + 0.75   :
    x < 2.5 / d1 ? n1 * (x -= 2.25  / d1) * x + 0.9375 :
                   n1 * (x -= 2.625 / d1) * x + 0.984375
  }

  bounceInOut = -> x {
    x < 0.5 ?
      (1.0 - bounceOut[1.0 - 2.0 * x]) / 2.0 :
      (1.0 + bounceOut[2.0 * x - 1.0]) / 2.0
  }

  EASINGS = {
    linear: -> x {x},

        sineIn: -> x {1.0 - Math.cos(x * pi_div2)},
        quadIn: -> x {x ** 2.0},
       cubicIn: -> x {x ** 3.0},
       quartIn: -> x {x ** 4.0},
       quintIn: -> x {x ** 5.0},
        expoIn: -> x {x == 0 ? 0.0 : 2.0 ** (10.0 * x - 10.0)},
        circIn: -> x {1.0 - Math.sqrt(1.0 - x ** 2.0)},
        backIn: -> x {c3 * x ** 3.0 - c1 * x ** 2.0},
     elasticIn: elasticIn,
      bounceIn: -> x {1.0 - bounceOut[1.0 - x]},

       sineOut: -> x {Math.sin(x * pi_div2)},
       quadOut: -> x {1.0 - (1.0 - x) ** 2.0},
      cubicOut: -> x {1.0 - (1.0 - x) ** 3.0},
      quartOut: -> x {1.0 - (1.0 - x) ** 4.0},
      quintOut: -> x {1.0 - (1.0 - x) ** 5.0},
       expoOut: -> x {x == 1 ? 1.0 : 1.0 - 2.0 ** (-10.0 * x)},
       circOut: -> x {Math.sqrt(1.0 - (x - 1.0) ** 2.0)},
       backOut: -> x {1.0 + c3 * (x - 1.0) ** 3.0 + c1 * (x - 1.0) ** 2.0},
    elasticOut: elasticOut,
     bounceOut: bounceOut,

       sineInOut: -> x {-(Math.cos(pi * x) - 1.0) / 2.0},
       quadInOut: -> x {x < 0.5 ?  2.0 * x ** 2 : 1.0 - (-2.0 * x + 2.0) ** 2.0 / 2.0},
      cubicInOut: -> x {x < 0.5 ?  4.0 * x ** 3 : 1.0 - (-2.0 * x + 2.0) ** 3.0 / 2.0},
      quartInOut: -> x {x < 0.5 ?  8.0 * x ** 4 : 1.0 - (-2.0 * x + 2.0) ** 4.0 / 2.0},
      quintInOut: -> x {x < 0.5 ? 16.0 * x ** 5 : 1.0 - (-2.0 * x + 2.0) ** 5.0 / 2.0},
       expoInOut: expoInOut,
       circInOut: circInOut,
       backInOut: backInOut,
    elasticInOut: elasticInOut,
     bounceInOut: bounceInOut
  }

end# RubySketch
