//  UIView+maoLayerAccess.m
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

#import <UIKit/UIKit.h>

#import "UIView+maoLayerAccess.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (maoLayerAccess)

- (CGFloat)layerCornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setLayerCornerRadius:(CGFloat)value
{
    self.layer.cornerRadius = value;
}

- (CGFloat)layerBorderWidth
{
    return self.layer.borderWidth;
}

- (void)setLayerBorderWidth:(CGFloat)value
{
    self.layer.borderWidth = value;
}

- (UIColor *)layerBorderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setLayerBorderColor:(UIColor *)value
{
    self.layer.borderColor = value.CGColor;
}

- (CGFloat)layerShadowOpacity
{
    return self.layer.shadowOpacity;
}

- (void)setLayerShadowOpacity:(CGFloat)value
{
    self.layer.shadowOpacity = value;
}

- (CGFloat)layerShadowRadius
{
    return self.layer.shadowRadius;
}

- (void)setLayerShadowRadius:(CGFloat)value
{
    self.layer.shadowRadius = value;
}

- (CGSize)layerShadowOffset
{
    return self.layer.shadowOffset;
}

- (void)setLayerShadowOffset:(CGSize)value
{
    self.layer.shadowOffset = value;
}

- (UIColor *)layerShadowColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setLayerShadowColor:(UIColor *)value
{
    self.layer.shadowColor = value.CGColor;
}

@end
