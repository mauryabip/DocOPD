//
//  CAGradientLayer+OPDGradients.h
//  docOPD
//
//  Created by Virinchi Software on 11/20/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAGradientLayer (OPDGradients)
+ (CAGradientLayer *)randomGradient;
+ (void)drawGradientOverContainer:(UIView *)container;
@end
