// -*- mode: objc -*-
#import <CRuby.h>
#import "RubySketch.h"
#include "../reflex/src/ios/view_controller.h"


void Init_beeps_native ();
void Init_rays_native ();
void Init_reflex_native ();


static ReflexViewController* active_reflex_view_controller = nil;

static ReflexViewController*
ReflexViewController_create()
{
	return active_reflex_view_controller;
}

static void
ReflexViewController_show (UIViewController*, ReflexViewController*)
{
}


@implementation RubySketch

	+ (void) setup
	{
		static BOOL done = NO;
		if (done) return;
		done = YES;

		[CRuby addExtension:@"beeps/native"  init:^{Init_beeps_native();}];
		[CRuby addExtension:@"rays/native"   init:^{Init_rays_native();}];
		[CRuby addExtension:@"reflex/native" init:^{Init_reflex_native();}];

		for (NSString *ext in @[
			@"Xot",
			@"Rucy",
			@"Beeps",
			@"Rays",
			@"Reflex",
			@"Processing",
			@"RubySketch"
		]) [CRuby addLibrary:ext bundle:[NSBundle bundleForClass:RubySketch.class]];

		ReflexViewController_set_create_fun(ReflexViewController_create);
		ReflexViewController_set_show_fun(ReflexViewController_show);
	}

	+ (BOOL) start
	{
		return [self start:@"main.rb" rescue:nil];
	}

	+ (BOOL) startWithRescue: (RescueBlock) rescue
	{
		return [self start:@"main.rb" rescue:rescue];
	}

	+ (BOOL) start: (NSString*) path
	{
		return [self start:path rescue:nil];
	}

	+ (BOOL) start: (NSString*) path rescue: (RescueBlock) rescue
	{
		CRBValue* ret = [CRuby evaluate:[NSString stringWithFormat:@
			"raise 'already started' unless require 'rubysketch'\n"
			"load '%@'\n"
			"RubySketch::WINDOW.__send__ :end_draw\n"
			"RubySketch::WINDOW.show",
			path
		]];
		return ret && ret.toBOOL;
	}

	+ (void) setActiveReflexViewController: (id) reflexViewController
	{
		active_reflex_view_controller = reflexViewController;
	}

	+ (void) resetActiveReflexViewController
	{
		active_reflex_view_controller = nil;
	}

@end
