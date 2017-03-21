//
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by emi on 06/01/15.
//
//

@import Foundation;
@import UIKit;

#import "ColorUtilities.h"

@implementation ColorUtilities

#pragma mark - COLOR CONVERTER

+ (UIColor *)colorFromHEXString:(NSString *)hexString withAlpha:(CGFloat)alpha
{
    // A HEX string to UIColor converter.

    if ([hexString hasPrefix:@"#"])
    {
        // If the HEX string has a # prefix, remove it.

        hexString = [hexString substringFromIndex:1];
    }

    if ([hexString length] != 6)
    {
        // The HEX string must be 6 chars now, if not, exit returning nil.

        return nil;
    }

    // Split the HEX string into 3 slices of 2 chars each.

    NSString *red = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *green = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *blue = [hexString substringWithRange:NSMakeRange(4, 2)];

    // Get a string scanner on the first slice.

    NSScanner *scanner = [NSScanner scannerWithString:red];

    unsigned redInt;

    // Scan the "red" slice of the HEX string.

    if (![scanner scanHexInt:&redInt])
    {
        // Error, no valid hexadecimal integer representation found, return nil.

        return nil;
    }

    // Scan the "green" slice of the HEX string.

    scanner = [NSScanner scannerWithString:green];

    unsigned greenInt;

    if (![scanner scanHexInt:&greenInt])
    {
        // Error, no valid hexadecimal integer representation found, return nil.

        return nil;
    }

    // Scan the "blue" slice of the HEX string.

    scanner = [NSScanner scannerWithString:blue];

    unsigned blueInt;

    if (![scanner scanHexInt:&blueInt])
    {
        // Error, no valid hexadecimal integer representation found, return nil.

        return nil;
    }

    // We got valid red, green and blue values,
    // create and return the UIColor with the specified alpha.
    // Extreme values for r,g,b are (0/255.0) = 0.0 and (255/255.0) = 1.0

    return [UIColor colorWithRed:redInt / 255.0f
                           green:greenInt / 255.0f
                            blue:blueInt / 255.0f
                           alpha:alpha];
}

#pragma mark - RANDOM COLOR GENERATOR

+ (UIColor *)randomNiceColor
{
    // This method returns a random color in a range of nice ones using HSB coordinates.

    // Random hue from 0 to 359 degrees.

    CGFloat hue = (arc4random() % 360) / 359.0f;

    // Random saturation from 0.0 to 1.0

    CGFloat saturation = (float)arc4random() / UINT32_MAX;

    // Random brightness from 0.0 to 1.0

    CGFloat brightness = (float)arc4random() / UINT32_MAX;

    // Limit saturation and brightness to get a nice colors palette.
    // Remove the following 2 lines to generate a color from the full range.

    saturation = saturation < 0.5 ? 0.5 : saturation;
    brightness = brightness < 0.9 ? 0.9 : brightness;

    // Return a random UIColor.

    return [UIColor colorWithHue:hue
                      saturation:saturation
                      brightness:brightness
                           alpha:1];
}

#pragma mark - RANDOM GRADIENT GENERATOR

+ (CAGradientLayer *)randomGradient
{
    // This method provides a nice 3-colors random gradient.

    // Get 3 random colors.

    UIColor *startColor = [ColorUtilities randomNiceColor];
    UIColor *middleColor = [ColorUtilities randomNiceColor];
    UIColor *endColor = [ColorUtilities randomNiceColor];

    // Create a CAGradientLayer object.

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];

    // Set the gradient's colors to be the random ones above, using an array of
    // CGColors.

    gradientLayer.colors =
        @[ (id)startColor.CGColor, (id)middleColor.CGColor, (id)endColor.CGColor ];

    // Set the gradient colors' locations.

    gradientLayer.locations = @[ @(0.0f), @(0.5f), @(1.0f) ];

    // The gradient will be a background gradient, covering its whole frame.

    gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);

    // Return this random gradient layer.

    return gradientLayer;
}

@end
