#import <UIKit/UIKit.h>
#import <CaptainHook/CaptainHook.h>

@interface SlidableMasterSplitViewController : UISplitViewController
@end

@interface MasterDetailViewController : SlidableMasterSplitViewController
- (void)setHidesMasterViewInPortrait:(BOOL)newValue;
@end

%hook MasterDetailViewController

- (void)loadView
{
	[self setHidesMasterViewInPortrait:NO];
	%orig;
}

- (void)setHidesMasterViewInPortrait:(BOOL)newValue
{
	%orig(NO);
}

%end

%hook MailDetailViewController

- (NSArray *)toolbarItems
{
	NSMutableArray *result = [NSMutableArray array];
	Class segmentedClass = [UISegmentedControl class];
	for (UIBarButtonItem *item in %orig) {
		if (item.action == @selector(mailboxButtonClicked:))
			continue;
		if ([item.customView isKindOfClass:segmentedClass])
			continue;
		[result addObject:item];
	}
	return result;
}

%end

%hook SlidableMasterSplitViewController

- (void)viewDidLoad
{
	%orig;
	// Fix right pane becoming unselectable on iOS5.0
	UIView **_tapView = CHIvarRef(self, _tapView, UIView *);
	if (_tapView)
		(*_tapView).userInteractionEnabled = NO;
}

%end
