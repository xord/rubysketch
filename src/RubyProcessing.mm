// -*- mode: objc -*-
#import <CRuby.h>
#import "RubyProcessing.h"
#import "RubySketch.h"


@implementation RubySketch

	+ (void) setup
	{
		static BOOL done = NO;
		if (done) return;
		done = YES;

		[RubyProcessing setup];
		[CRuby addLibrary:@"RubySketch" bundle:[NSBundle bundleForClass:RubySketch.class]];
	}

	+ (void) start: (NSString*) path
	{
		[CRuby evaluate:@"raise 'already started' unless require 'rubysketch'\n"];
		[RubyProcessing start: path];
	}

@end
