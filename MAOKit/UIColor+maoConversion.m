//  UIColor+maoConversion.h
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

#import "UIColor+maoConversion.h"

static CGFloat floatSatisfyBounds(CGFloat const value, CGFloat const min, const CGFloat max)
{
    CGFloat result = MAX(value, min);
    result = MIN(result, max);
    return result;
}

#define fsb(x) floatSatisfyBounds(x, 0.f, 1.f)

HSLColor normalizedHSLColor(HSLColor hsl)
{
    return (HSLColor){fsb(hsl.hue), fsb(hsl.saturation), fsb(hsl.luminosity), fsb(hsl.alpha)};
}

HSVColor normalizedHSVColor(HSVColor hsv)
{
    return (HSVColor){fsb(hsv.hue), fsb(hsv.saturation), fsb(hsv.value), fsb(hsv.alpha)};
}

RGBColor normalizedRGBColor(RGBColor rgb)
{
    return (RGBColor){fsb(rgb.red), fsb(rgb.green), fsb(rgb.blue), fsb(rgb.alpha)};
}

HSVColor HSVFromRGB(RGBColor rgb)
{
    rgb = normalizedRGBColor(rgb);
    CGFloat rgb_min = MIN(rgb.red, rgb.green); rgb_min = MIN(rgb_min, rgb.blue);
    CGFloat rgb_max = MAX(rgb.red, rgb.green); rgb_max = MAX(rgb_max, rgb.blue);

    HSVColor hsv;
    hsv.alpha = rgb.alpha;
    hsv.value = rgb_max;
    hsv.saturation = (rgb_max == 0.f) ? 0.f : (1.f - (rgb_min / rgb_max));
    hsv.hue = 0.f;

    if (rgb_max == rgb_min) {
        hsv.hue = 0.f;
    } else if (rgb_max == rgb.red) {
        hsv.hue = ((rgb.green - rgb.blue) / (rgb_max - rgb_min)) + ((rgb.green < rgb.blue) ? 6.f : 0.f);
    } else if (rgb_max == rgb.green) {
        hsv.hue = ((rgb.blue - rgb.red) / (rgb_max - rgb_min)) + 2.f;
    } else if (rgb_max == rgb.blue) {
        hsv.hue = ((rgb.red - rgb.green) / (rgb_max - rgb_min)) + 4.f; }
    hsv.hue /= 6.f;
    return hsv;
}

RGBColor RGBFromHSV(HSVColor hsv)
{
    hsv = normalizedHSVColor(hsv);
    RGBColor rgb;
    rgb.alpha = hsv.alpha;
	if(hsv.saturation == 0.f) {
        rgb.red = rgb.green = rgb.blue = hsv.value; return rgb;
    }
    NSInteger i = floor(hsv.hue * 6);
    CGFloat f = hsv.hue * 6 - i; // factorial part of h
    CGFloat p = hsv.value * (1 - hsv.saturation);
    CGFloat q = hsv.value * (1 - hsv.saturation * f);
    CGFloat t = hsv.value * (1 - hsv.saturation * (1 - f));
    switch(i) {
        case 0: rgb.red = hsv.value; rgb.green = t; rgb.blue = p;
            break;
        case 1: rgb.red = q; rgb.green = hsv.value; rgb.blue = p;
            break;
        case 2: rgb.red = p; rgb.green = hsv.value; rgb.blue = t;
            break;
        case 3: rgb.red = p; rgb.green = q; rgb.blue = hsv.value;
            break;
        case 4: rgb.red = t; rgb.green = p; rgb.blue = hsv.value;
            break;
        case 5: rgb.red = hsv.value; rgb.green = p; rgb.blue = q;
            break;
        default /* 6 */: rgb.red = hsv.value; rgb.green = 0.f; rgb.blue = 0.f;
            break;
    }
    return rgb;
}

HSLColor HSLFromRGB(RGBColor rgb)
{
    rgb = normalizedRGBColor(rgb);
    HSLColor hsl;
    CGFloat rgb_min = MIN(rgb.red, rgb.green); rgb_min = MIN(rgb_min, rgb.blue);
    CGFloat rgb_max = MAX(rgb.red, rgb.green); rgb_max = MAX(rgb_max, rgb.blue);
    hsl.alpha = rgb.alpha;
    hsl.luminosity = (rgb_max + rgb_min) * 0.5f;
    if (rgb_max == rgb_min) {
        hsl.hue = hsl.saturation = 0.f; // achromatic
        return hsl;
    }
    CGFloat d = rgb_max - rgb_min;
    hsl.saturation = (hsl.luminosity > 0.5f) ? (d / (2.f - rgb_max - rgb_min)) : (d / (rgb_max + rgb_min));
    hsl.hue = 0.f;
    if (rgb_max == rgb.red) {
        hsl.hue = (rgb.green - rgb.blue) / d + (rgb.green < rgb.blue ? 6.f : 0.f);
    } else if (rgb_max == rgb.green) {
        hsl.hue = (rgb.blue - rgb.red) / d + 2.f;
    } else if (rgb_max == rgb.blue) {
        hsl.hue = (rgb.red - rgb.green) / d + 4.f; }
    hsl.hue /= 6.f;
    return hsl;
}

RGBColor RGBFromHSL(HSLColor hsl)
{
    hsl = normalizedHSLColor(hsl);
	if(hsl.saturation == 0.f) return (RGBColor) { hsl.luminosity, hsl.luminosity, hsl.luminosity, hsl.alpha };

    // Test for luminance and compute temporary values based on luminance and saturation
    CGFloat temp2 = (hsl.luminosity < 0.5f) ?
    (hsl.luminosity * (1.f + hsl.saturation)) :
    (hsl.luminosity + hsl.saturation - hsl.luminosity * hsl.saturation);
    CGFloat temp1 = 2.f * hsl.luminosity - temp2;

	// Compute intermediate values based on hue
    CGFloat rgb_temp[3] = { (hsl.hue + 1.f / 3.f), hsl.hue, (hsl.hue - 1.f / 3.f) };
    for(NSUInteger i = 0; i < 3; ++i) {
		if (rgb_temp[i] < 0.f) rgb_temp[i] += 1.f;
		if (rgb_temp[i] > 1.f) rgb_temp[i] -= 1.f;
		if (6.f * rgb_temp[i] < 1.f) {
            rgb_temp[i] = temp1 + (temp2 - temp1) * 6.f * rgb_temp[i];
        } else if (2.f * rgb_temp[i] < 1.f) {
            rgb_temp[i] = temp2;
        } else if (3.f * rgb_temp[i] < 2.f) {
            rgb_temp[i] = temp1 + (temp2 - temp1) * ((2.f / 3.f) - rgb_temp[i]) * 6.f;
        } else {
            rgb_temp[i] = temp1;
        }
    }
    return (RGBColor) { rgb_temp[0], rgb_temp[1], rgb_temp[2], hsl.alpha };
}

RGBColor RGBFromHEX(NSString * hex)
{
    NSString *const stringColor =
    [NSString stringWithFormat:@"%@%@", hex, ((hex.length == 6) ? @"FF" : [NSString string])];
    NSScanner *const scanner = [NSScanner scannerWithString:stringColor];
    NSUInteger intColor;
    if (![scanner scanHexInt:&intColor]) {
        intColor = 0;
    }
    return (RGBColor) {
        (CGFloat)((intColor & 0xFF000000) >> 24) / 255.f,
        (CGFloat)((intColor & 0x00FF0000) >> 16) / 255.f,
        (CGFloat)((intColor & 0x0000FF00) >> 8) / 255.f,
        (CGFloat)(intColor & 0x000000FF) / 255.f };
}

NSString *HEXFromRGB(RGBColor rgb)
{
    NSUInteger intColor =   (((NSUInteger)(rgb.red * 255.f)) << 24) +
    (((NSUInteger)(rgb.green * 255.f)) << 16) +
    (((NSUInteger)(rgb.blue * 255.f)) << 8) +
    (((NSUInteger)(rgb.alpha * 255.f)));
    return [NSString stringWithFormat:@"%08X",intColor];
}


RGBColor RGBWithFactor(RGBColor rgb, CGFloat factor)
{
    return (RGBColor){ fsb(rgb.red * factor), fsb(rgb.green * factor), fsb(rgb.blue * factor), fsb(rgb.alpha)};
}

HSLColor HSLColorMake(CGFloat hue, CGFloat saturation, CGFloat luminosity, CGFloat alpha)
{
    return (HSLColor){ fsb(hue), fsb(saturation), fsb(luminosity), fsb(alpha) };
}

HSVColor HSVColorMake(CGFloat hue, CGFloat saturation, CGFloat value, CGFloat alpha)
{
    return (HSVColor){ fsb(hue), fsb(saturation), fsb(value), fsb(alpha) };
}

RGBColor RGBColorMake(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return (RGBColor){ fsb(red), fsb(green), fsb(blue), fsb(alpha) };
}

RGBColor RGBColorMake256(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return (RGBColor){ fsb(red/255.f), fsb(green/255.f), fsb(blue/255.f), fsb(alpha/255.f) };
}

@implementation UIColor (maoConversion)

- (RGBColor)RGBColor
{
    const CGFloat * components = CGColorGetComponents(self.CGColor);
    size_t numberOfComponents = CGColorGetNumberOfComponents(self.CGColor);
    RGBColor rgb;
    if (numberOfComponents == 2) {
        rgb.red = rgb.green = rgb.blue = components[0];
        rgb.alpha = components[1];
        return rgb;
    }
    rgb.red = (numberOfComponents < 1) ? 0 : components[0];
    rgb.green = (numberOfComponents < 2) ? 0 : components[1];
    rgb.blue  = (numberOfComponents < 3) ? 0 : components[2];
    rgb.alpha = (numberOfComponents < 4) ? 0 : components[3];
    return rgb;
}

- (HSVColor)HSVColor
{
    return HSVFromRGB(self.RGBColor);
}

- (HSLColor)HSLColor
{
    return HSLFromRGB(self.RGBColor);
}

- (NSString *)HEXColorCopy
{
    return HEXFromRGB(self.RGBColor);
}

+ (UIColor *)colorWithRGBColor:(RGBColor)rgb
{
    rgb = normalizedRGBColor(rgb);
    return [UIColor colorWithRed:rgb.red green:rgb.green blue:rgb.blue alpha:rgb.alpha];
}

+ (UIColor *)colorWithHSVColor:(HSVColor)hsv
{
    return [UIColor colorWithRGBColor:RGBFromHSV(hsv)];
}

+ (UIColor *)colorWithHSLColor:(HSLColor)hsl
{
    return [UIColor colorWithRGBColor:RGBFromHSL(hsl)];
}

+ (UIColor *)colorWithHEXColor:(NSString *)hex
{
    return [UIColor colorWithRGBColor:RGBFromHEX(hex)];
}

- (id)initWithRGBColor:(RGBColor)rgb
{
    rgb = normalizedRGBColor(rgb);
    return [self initWithRed:rgb.red green:rgb.green blue:rgb.blue alpha:rgb.alpha];
}

- (id)initWithHSVColor:(HSVColor)hsv
{
    return [self initWithRGBColor:RGBFromHSV(hsv)];
}

- (id)initWithHSLColor:(HSLColor)hsl
{
    return [self initWithRGBColor:RGBFromHSL(hsl)];
}

- (id)initWithHEXColor:(NSString *)hex
{
    return [self initWithRGBColor:RGBFromHEX(hex)];
}

@end
