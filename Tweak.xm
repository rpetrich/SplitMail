#import <UIKit/UIKit.h>

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
