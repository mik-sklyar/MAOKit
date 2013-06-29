//  UIView+maoDimensions.h
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

#import <UIKit/UIKit.h>

typedef enum {
    AlignmentTypeNone = 0,
    AlignmentTypeCenter,
    AlignmentTypeCenterTop,
    AlignmentTypeCenterBottom,
    AlignmentTypeCenterLeft,
    AlignmentTypeCenterRight,
    AlignmentTypeTopLeft,
    AlignmentTypeTopRight,
    AlignmentTypeBottonLeft,
    AlignmentTypeBottomRight

} AlignmentType;


CGSize shrinkToSatisfyBounds(CGSize size, CGSize bounds);
CGSize shrinkToSatisfyBound(CGSize size, CGFloat bound);

@interface UIView (maoDimensions)

/*
 * position
 */
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat frameLeft;
@property (nonatomic, assign) CGFloat frameTop;
@property (nonatomic, assign) CGFloat frameRight;
@property (nonatomic, assign) CGFloat frameBottom;

/*
 * size
 */
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

/*
 * auxiliary info
 */
@property (nonatomic, readonly) CGFloat minDimension;
@property (nonatomic, readonly) CGFloat maxDimension;
@property (nonatomic, readonly) CGPoint boundsCenter;

/*
 * alignment
 */
- (void)centerInBounds:(CGSize)bounds;
- (void)centerInBoundsHorizontally:(CGSize)bounds;
- (void)centerInBoundsVertically:(CGSize)bounds;
- (void)setPositionInRect:(CGRect)rect withAlignment:(AlignmentType)alignment;

/*
 * resizing
 */
- (void)shrinkToSatisfyBounds:(CGSize)bounds;
- (void)shrinkToSatisfyBound:(CGFloat)bound;

@end
