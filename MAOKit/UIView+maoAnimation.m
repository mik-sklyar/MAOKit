//  UIView+maoAnimation.m
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

#import "UIView+maoAnimation.h"

static CGRect PrepareTransitionForRect(CGRect rect, CGRect sup, UIViewAnimationEffect effect) {
    switch (effect) {
        case UIViewAnimationEffectSizeBottom:
            return (CGRect){{CGRectGetMinX(rect), CGRectGetMaxY(rect)}, {rect.size.width, 0}};
            break;
        case UIViewAnimationEffectSizeTop:
            return (CGRect){{CGRectGetMinX(rect), CGRectGetMinY(rect)}, {rect.size.width, 0}};
            break;
        case UIViewAnimationEffectSizeLeft:
            return (CGRect){{CGRectGetMinX(rect), CGRectGetMinY(rect)}, {0, rect.size.height}};
            break;
        case UIViewAnimationEffectSizeRight:
            return (CGRect){{CGRectGetMaxX(rect), CGRectGetMinY(rect)}, {0, rect.size.height}};
            break;
        case UIViewAnimationEffectFlyBottom:
            return CGRectOffset(rect, 0, CGRectGetMaxY(sup) - CGRectGetMinY(rect));
            break;
        case UIViewAnimationEffectFlyTop:
            return CGRectOffset(rect, 0, - CGRectGetMaxY(rect));
            break;
        case UIViewAnimationEffectFlyLeft:
            return CGRectOffset(rect, - CGRectGetMaxX(rect), 0);
            break;
        case UIViewAnimationEffectFlyRight:
            return CGRectOffset(rect, CGRectGetMaxX(sup) - CGRectGetMinX(rect), 0);
            break;
        default:
            return rect;
            break;
    }
}

@implementation UIView (UIView_Animation)

- (void)addSubview:(UIView *)view withAnimationEffect:(UIViewAnimationEffect)effect duration:(CGFloat)duration belowView:(UIView *)below {
    if (effect == UIViewAnimationEffectNone) { [self addSubview:view]; return; }

    //get original parameters
    CGRect originalFrame = view.frame;
    CGFloat originalAlpha = view.alpha;

    //prepare for animation and add subview
    UIViewAnimationOptions options = UIViewAnimationOptionLayoutSubviews;//|UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut;
    view.frame = PrepareTransitionForRect(view.frame, self.frame, effect);
    if (effect == UIViewAnimationEffectAppear) view.alpha = 0;

    if (!below) [self addSubview:view];
    else [self insertSubview:view belowSubview:below];


    //animation
    [UIView animateWithDuration:duration
                          delay:0
                        options:options
                     animations:^{
                         view.frame = originalFrame;
                         view.alpha = originalAlpha;
                     }
                     completion:nil];
}

- (void)addSubview:(UIView *)view withAnimationEffect:(UIViewAnimationEffect)effect duration:(CGFloat)duration {
    [self addSubview:view withAnimationEffect:effect duration:duration belowView:nil];
}

- (void)removeFromSuperviewWithAnimationEffect:(UIViewAnimationEffect)effect duration:(CGFloat)duration {
    if (effect == UIViewAnimationEffectNone) { [self removeFromSuperview]; return; }

    //get original frame and prepare for animation
    CGRect originalFrame = self.frame;
    CGFloat originalAlpha = self.alpha;

    CGRect targetFrame = PrepareTransitionForRect(self.frame, self.superview.frame, effect);
    UIViewAnimationOptions options = UIViewAnimationOptionLayoutSubviews;

    //animation
    [UIView animateWithDuration:duration
                          delay:0
                        options:options
                     animations:^{
                         self.frame = targetFrame;
                         if (effect == UIViewAnimationEffectAppear) self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         //remove from super and set original parameters
                         [self removeFromSuperview];
                         self.frame = originalFrame;
                         self.alpha = originalAlpha;
                     }];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (self.hidden == hidden) return;
    if (!hidden) {
        CGFloat alpha = self.alpha;
        self.alpha = 0.f;
        self.hidden = hidden;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.alpha = alpha;
                         }];
        return;
    }

    CGFloat alpha = self.alpha;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0.f;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = hidden;
                         self.alpha = alpha;
                     }];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated duration:(CGFloat)duration
{
    if (self.hidden == hidden) return;
    if (animated) {
        if (!hidden) {
            CGFloat alpha = self.alpha;
            self.alpha = 0.f;
            self.hidden = hidden;
            [UIView animateWithDuration:duration
                             animations:^{
                                 self.alpha = alpha;
                             }];
            return;
        }
        CGFloat alpha = self.alpha;
        [UIView animateWithDuration:duration
                         animations:^{
                             self.alpha = 0.f;
                         }
                         completion:^(BOOL finished) {
                             self.hidden = hidden;
                             self.alpha = alpha;
                         }];
    } else {
        self.hidden = hidden;
    }
}

@end
