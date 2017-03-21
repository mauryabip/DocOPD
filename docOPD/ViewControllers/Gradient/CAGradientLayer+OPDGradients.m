//
//  CAGradientLayer+OPDGradients.m
//  docOPD
//
//  Created by Virinchi Software on 11/20/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "CAGradientLayer+OPDGradients.h"
#import "ColorUtilities.h"
@implementation CAGradientLayer (OPDGradients)
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
    @[(id)startColor.CGColor, (id)middleColor.CGColor, (id)endColor.CGColor];
    
    // Set the gradient colors' locations.
    
    gradientLayer.locations = @[ @(0.0f), @(0.5f), @(1.0f) ];
    
    // The gradient will be a background gradient, covering its whole frame.
    
    gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    
    // Return this random gradient layer.
    
    return gradientLayer;
}


+ (void)drawGradientOverContainer:(UIView *)container
{
    UIColor *transBgColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    UIColor *black = [UIColor blackColor];
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.opacity = 0.8;
    maskLayer.colors = [NSArray arrayWithObjects:(id)black.CGColor,
                        (id)transBgColor.CGColor, (id)transBgColor.CGColor, (id)black.CGColor, nil];
    
    // Hoizontal - commenting these two lines will make the gradient veritcal
    maskLayer.startPoint = CGPointMake(0.0, 0.5);
    maskLayer.endPoint = CGPointMake(1.0, 0.5);
    
    NSNumber *gradTopStart = [NSNumber numberWithFloat:0.0];
    NSNumber *gradTopEnd = [NSNumber numberWithFloat:0.4];
    NSNumber *gradBottomStart = [NSNumber numberWithFloat:0.6];
    NSNumber *gradBottomEnd = [NSNumber numberWithFloat:1.0];
    maskLayer.locations = @[gradTopStart, gradTopEnd, gradBottomStart, gradBottomEnd];
    
    maskLayer.bounds = container.bounds;
    maskLayer.anchorPoint = CGPointZero;
    [container.layer addSublayer:maskLayer];
}

@end
