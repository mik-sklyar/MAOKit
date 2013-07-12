//  UIViewController+maoPopover.h
//
//  Copyright (c) 2011-2013 mik ( https://github.com/mik69/MAOKit )
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

#import "UIViewController+maoPopover.h"
#import <objc/runtime.h>

@interface UIViewController (maoPopover_Private) <UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *maoPopoverController;

@end

@implementation UIViewController (maoPopover)

static char associationKeyPopoverController;
static char associationKeyPopoverNeedsNavBar;

#pragma mark - properties

- (void)setPopoverNeedsNavigationBar:(BOOL)value
{
    objc_setAssociatedObject(self, &associationKeyPopoverNeedsNavBar, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)popoverNeedsNavigationBar
{
    return (BOOL)[objc_getAssociatedObject(self, &associationKeyPopoverNeedsNavBar) boolValue];
}

- (void)setMaoPopoverController:(UIPopoverController *)controller
{
    objc_setAssociatedObject(self, &associationKeyPopoverController, controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPopoverController *)maoPopoverController
{
    return (UIPopoverController *)objc_getAssociatedObject(self, &associationKeyPopoverController);
}


#pragma mark - lifecycle

- (void)dealloc
{
    [self dismissPopoverAnimated:NO];
}

#pragma mark - super overrides

- (void)dismissSelfAnimated:(BOOL)animated
{
    if (self.maoPopoverController.isPopoverVisible) {
        [self dismissPopoverAnimated:animated];
        return;
    }
    //    [super dismissSelfAnimated:animated];
}


#pragma mark - public methods

- (void)dismissPopoverAnimated:(BOOL)animated
{
    if (self.maoPopoverController.isPopoverVisible) {
        [self.maoPopoverController dismissPopoverAnimated:animated];
    }
    self.maoPopoverController = nil;
}

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item
               permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                               animated:(BOOL)animated
{
    if (self.maoPopoverController.isPopoverVisible) return;
    [self preparePopoverForPresenting];
    [self.maoPopoverController presentPopoverFromBarButtonItem:item
                                      permittedArrowDirections:arrowDirections
                                                      animated:animated];

}

- (void)presentPopoverFromRect:(CGRect)rect
                        inView:(UIView *)view
      permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                      animated:(BOOL)animated
{
    if (self.maoPopoverController.isPopoverVisible) return;
    [self preparePopoverForPresenting];
    [self.maoPopoverController presentPopoverFromRect:rect
                                               inView:view
                             permittedArrowDirections:arrowDirections
                                             animated:animated];
}


#pragma mark - helper methods

- (void)prepareSelfForPopoverBeforePresenting
{
    //do nothing
}

- (void)preparePopoverForPresenting
{
    [self prepareSelfForPopoverBeforePresenting];
    UIViewController *vc = self;
    if (self.popoverNeedsNavigationBar) {
        vc = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    self.maoPopoverController = [[UIPopoverController alloc] initWithContentViewController:vc];
    self.maoPopoverController.delegate = self;
}


#pragma mark - UIPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return YES;
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.maoPopoverController = nil;
}

@end
