// -*- mode: objc -*-
#import <Foundation/Foundation.h>
#import <CRBValue.h>


@interface RubySketch : NSObject

	typedef void (^RescueBlock) (CRBValue* exception);

	+ (void) setup;

	+ (BOOL) start;
	+ (BOOL) startWithRescue: (RescueBlock) rescue;

	+ (BOOL) start: (NSString*) path;
	+ (BOOL) start: (NSString*) path rescue: (RescueBlock) rescue;

	+ (void) setActiveReflexViewController: (id) reflexViewController;

	+ (void) resetActiveReflexViewController;

@end
