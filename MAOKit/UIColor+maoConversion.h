//  UIColor+maoConversion.h
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

//all components are in bounds 0..1.f

typedef struct rgb_color {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;

} RGBColor;

typedef struct hsv_color {
    CGFloat hue;
    CGFloat saturation;
    CGFloat value;
    CGFloat alpha;

} HSVColor;

typedef struct hsl_color {
    CGFloat hue;
    CGFloat saturation;
    CGFloat luminosity;
    CGFloat alpha;

} HSLColor;

//return ***Color struct with components according bounds 0..1.f
HSLColor normalizedHSLColor(HSLColor hsl);
HSVColor normalizedHSVColor(HSVColor hsv);
RGBColor normalizedRGBColor(RGBColor rgb);

//convert ***Color struct to ***Color struct of different type
HSVColor HSVFromRGB(RGBColor rgb);
RGBColor RGBFromHSV(HSVColor hsv);//important! returns red color if hue == 1.f
HSLColor HSLFromRGB(RGBColor rgb);
RGBColor RGBFromHSL(HSLColor hsl);
RGBColor RGBFromHEX(NSString * hex);

//return NSString which is uppercase 8-byte(rgba) hex representation of RGBColor (without "0x")
NSString *HEXFromRGB(RGBColor rgb);


//return RGBColor struct with components * factor, alpha not changes
RGBColor RGBWithFactor(RGBColor rgb, CGFloat factor);

//make ***Color struct by components 0..1.f according to the bounds
HSLColor HSLColorMake(CGFloat hue, CGFloat saturation, CGFloat luminosity, CGFloat alpha);
HSVColor HSVColorMake(CGFloat hue, CGFloat saturation, CGFloat value, CGFloat alpha);
RGBColor RGBColorMake(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

//make RGBColor struct by components 0..255.f
RGBColor RGBColorMake256(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

@interface UIColor (maoConversion)

@property (nonatomic, readonly) RGBColor RGBColor;
@property (nonatomic, readonly) HSLColor HSLColor;
@property (nonatomic, readonly) HSVColor HSVColor;

//return NSString which is uppercase 8-byte(rgba) hex representation of UIColor (without "0x")
@property (nonatomic, readonly) NSString * HEXColorCopy;

//create UIColor by ***Color struct
+ (UIColor *)colorWithRGBColor:(RGBColor)rgb;
+ (UIColor *)colorWithHSVColor:(HSVColor)hsv;
+ (UIColor *)colorWithHSLColor:(HSLColor)hsl;
//create UIColor by 6-byte(rgb) or 8-byte(rgba) hex representation, if hex is incorrect return "clearColor"
+ (UIColor *)colorWithHEXColor:(NSString *)hex;

//init UIColor with ***Color struct
- (id)initWithRGBColor:(RGBColor)rgb;
- (id)initWithHSVColor:(HSVColor)hsv;
- (id)initWithHSLColor:(HSLColor)hsl;

//init UIColor with 6-byte(rgb) or 8-byte(rgba) hex representation, if hex is incorrect return "clearColor"
- (id)initWithHEXColor:(NSString *)hex;

@end
