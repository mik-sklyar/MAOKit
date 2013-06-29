//  UIView+maoDimensions.m
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

#import "UIView+maoDimensions.h"

CGSize shrinkToSatisfyBounds(CGSize size, CGSize bounds)
{
    if ((size.width == 0)||(size.height == 0)) {
        return size;
    }
    const CGFloat shrinkCoeff =
    MIN(bounds.width / size.width, bounds.height / size.height);

    if (shrinkCoeff >= 1) {
        return size;
    }
    return (CGSize){size.width * shrinkCoeff, size.height * shrinkCoeff};
}

CGSize shrinkToSatisfyBound(CGSize size, CGFloat bound)
{
    return shrinkToSatisfyBounds(size, (CGSize){bound, bound});
}

@implementation UIView (maoDimensions)

#pragma mark - properties

- (void)setOrigin:(CGPoint)origin
{
    self.frame = (CGRect){origin, self.frame.size};
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setFrameLeft:(CGFloat)left
{
    self.frame = (CGRect){{left, self.frame.origin.y}, self.frame.size};
}

- (CGFloat)frameLeft
{
    return self.frame.origin.x;
}

- (void)setFrameTop:(CGFloat)top
{
    self.frame = (CGRect){{self.frame.origin.x, top}, self.frame.size};
}

- (CGFloat)frameTop
{
    return self.frame.origin.y;
}

- (void)setFrameRight:(CGFloat)right
{
    self.frame = (CGRect){{right - self.frame.size.width, self.frame.origin.y}, self.frame.size};
}

- (CGFloat)frameRight
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameBottom:(CGFloat)bottom
{
    self.frame = (CGRect){{self.frame.origin.x, bottom - self.frame.size.height}, self.frame.size};
}

- (CGFloat)frameBottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    self.frame = (CGRect){self.frame.origin, size};
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setWidth:(CGFloat)width
{
    self.frame = (CGRect){self.frame.origin, {width, self.frame.size.height}};
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    self.frame = (CGRect){self.frame.origin, {self.frame.size.width, height}};
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)minDimension
{
    return MIN(self.height, self.width);
}

- (CGFloat)maxDimension
{
    return MAX(self.height, self.width);
}

- (CGPoint)boundsCenter
{
    return (CGPoint){self.bounds.size.width * 0.5f, self.bounds.size.height * 0.5f};
}

#pragma mark - methods

- (void)shrinkToSatisfyBounds:(CGSize)boundsSize
{
    self.size = shrinkToSatisfyBounds(self.bounds.size, boundsSize);
}

- (void)shrinkToSatisfyBound:(CGFloat)boundSize
{
    self.size = shrinkToSatisfyBound(self.bounds.size, boundSize);
}

- (void)centerInBounds:(CGSize)boundsSize
{
    self.origin = (CGPoint){(boundsSize.width - self.frame.size.width) * 0.5f, (boundsSize.height - self.frame.size.height) * 0.5f};
}

- (void)centerInBoundsHorizontally:(CGSize)boundsSize
{
    self.frameLeft = (boundsSize.width - self.frame.size.width) * 0.5f;
}

- (void)centerInBoundsVertically:(CGSize)boundsSize
{
    self.frameTop = (boundsSize.height - self.frame.size.height) * 0.5f;
}

- (void)setPositionInRect:(CGRect)rect withAlignment:(AlignmentType)alignment
{
    switch (alignment) {
        case AlignmentTypeNone: return;
        case AlignmentTypeCenter:
            self.origin = (CGPoint){
                self.frame.origin.x + (rect.size.width - self.frame.size.width) * 0.5f,
                self.frame.origin.y + (rect.size.height - self.frame.size.height) * 0.5f
            };
            break;
        case AlignmentTypeCenterTop:
            self.origin = (CGPoint){
                self.frame.origin.x + (rect.size.width - self.frame.size.width) * 0.5f,
                rect.origin.y
            };
            break;
        case AlignmentTypeCenterBottom:
            self.origin = (CGPoint){
                self.frame.origin.x + (rect.size.width - self.frame.size.width) * 0.5f,
                rect.origin.y + rect.size.height - self.frame.size.height
            };
            break;
        case AlignmentTypeCenterLeft:
            self.origin = (CGPoint){
                rect.origin.x,
                self.frame.origin.y + (rect.size.height - self.frame.size.height) * 0.5f
            };
            break;
        case AlignmentTypeCenterRight:
            self.origin = (CGPoint){
                rect.origin.x + rect.size.width - self.frame.size.width,
                self.frame.origin.y + (rect.size.height - self.frame.size.height) * 0.5f
            };
            break;
        case AlignmentTypeTopLeft:
            self.origin = rect.origin;
            break;
        case AlignmentTypeTopRight:
            self.origin = (CGPoint){
                rect.origin.x + rect.size.width - self.frame.size.width,
                rect.origin.y
            };
            break;
        case AlignmentTypeBottonLeft:
            self.origin = (CGPoint){
                rect.origin.x,
                rect.origin.y + rect.size.height - self.frame.size.height
            };
            break;
        case AlignmentTypeBottomRight:
            self.origin = (CGPoint){
                rect.origin.x + rect.size.width - self.frame.size.width,
                rect.origin.y + rect.size.height - self.frame.size.height
            };
            break;
    }
}

@end
