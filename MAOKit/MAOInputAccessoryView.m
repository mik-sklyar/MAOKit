//  MAOInputAccessoryView.m
//
//  Copyright (c) 2011-2013 mik
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  Except as contained in this notice, the name(s) of the above copyright holders
//  shall not be used in advertising or otherwise to promote the sale, use or
//  other dealings in this Software without prior written authorization.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "MAOInputAccessoryView.h"

@interface MAOInputAccessoryView ()
{
    __weak id target_;
    SEL actionDone_;
    SEL actionNext_;
    SEL actionPrev_;
}

@property (nonatomic, strong) UISegmentedControl *navigationButtons;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@end

@implementation MAOInputAccessoryView

@synthesize navigationButtons = navigationButtons_;
@synthesize doneButton = doneButton_;

+ (CGFloat)viewHeight
{
    return 44.f;
}

- (void)setActionDoneEnabled:(BOOL)value
{
    self.doneButton.enabled = value;
}

- (BOOL)actionDoneEnabled
{
    return self.doneButton.enabled;
}

- (void)setActionDoneHidden:(BOOL)value
{
    //do nothing
}

- (BOOL)actionDoneHidden
{
    return NO;
}

- (void)setActionsNextPrevHidden:(BOOL)value
{
    self.navigationButtons.hidden = value;
}

- (BOOL)actionsNextPrevHidden
{
    return self.navigationButtons.hidden;
}

- (void)setActionNextEnabled:(BOOL)value
{
    [self.navigationButtons setEnabled:value forSegmentAtIndex:1];
}

- (BOOL)actionNextEnabled
{
    return [self.navigationButtons isEnabledForSegmentAtIndex:1];
}

- (void)setActionPrevEnabled:(BOOL)value
{
    [self.navigationButtons setEnabled:value forSegmentAtIndex:0];
}

- (BOOL)actionPrevEnabled
{
    return [self.navigationButtons isEnabledForSegmentAtIndex:0];
}

- (void)clearPreviousTarget
{
    target_ = nil;
    actionDone_ = nil;
    actionPrev_ = nil;
    actionNext_ = nil;
}

- (void)setTarget:(id)target actionNext:(SEL)aNext actionPrev:(SEL)aPrev actionDone:(SEL)aDone
{
    [self clearPreviousTarget];
    if (!target) return;

    target_ = target;
    if ((aNext) && ([target respondsToSelector:aNext])) actionNext_ = aNext;
    if ((aPrev) && ([target respondsToSelector:aPrev])) actionPrev_ = aPrev;
    if ((aDone) && ([target respondsToSelector:aDone])) actionDone_ = aDone;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UISegmentedControl *const nb = [[UISegmentedControl alloc] initWithItems:maoPrevNextItems];
        nb.segmentedControlStyle = UISegmentedControlStyleBar;
        nb.frame = (CGRect){nb.frame.origin, 80.f, nb.frame.size.height};
        nb.momentary = YES;
        nb.tintColor = UIColor.blackColor;
        [(self.navigationButtons = nb) addTarget:self
                                          action:@selector(navigationButtonsDidChanged)
                                forControlEvents:UIControlEventValueChanged];
        self.doneButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                      target:self
                                                      action:@selector(doneButtonDidTouch)];
        UIBarButtonItem *const spaceItem =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
         target:nil action:nil];

        UIBarButtonItem *const navItem =
        [[UIBarButtonItem alloc] initWithCustomView:self.navigationButtons];

        self.items = @[navItem, spaceItem, self.doneButton];
        self.barStyle = UIBarStyleBlackTranslucent;
    }
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)navigationButtonsDidChanged
{
    if (self.navigationButtons.selectedSegmentIndex) {
        if (actionNext_) [target_ performSelector:actionNext_];
    } else {
        if (actionPrev_) [target_ performSelector:actionPrev_];
    }
}

- (void)doneButtonDidTouch
{
    if (actionDone_) [target_ performSelector:actionDone_];
}

#pragma clang diagnostic pop

@end
