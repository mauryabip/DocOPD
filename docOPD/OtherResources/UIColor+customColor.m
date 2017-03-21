//
//  UIColor+customColor.m
//  docOPD
//
//  Created by Ashutosh Kumar on 7/31/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "UIColor+customColor.h"

@implementation UIColor (customColor)
+ (UIColor *)dOPDThemeColor {
    
    static UIColor *ThemeColor;
    //0,154,221 (Digital meter)
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ThemeColor = [UIColor colorWithRed:05.0 / 255.0
                                     green:173.0 / 255.0
                                      blue:152.0 / 255.0
                                     alpha:1.0];
    });
    //Hex #1160AE
    //OLD 17,96,176
    //New 05,173,152, HEX - 05ad98
    
    return ThemeColor;
}

+ (UIColor *)dOPDTFBorderColor{
    
    static UIColor *TFborderColor;
    //0,154,221 (Digital meter)
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TFborderColor = [UIColor colorWithRed:229.0 / 255.0
                                     green:229.0 / 255.0
                                      blue:229.0 / 255.0
                                     alpha:1.0];
    });
    //OLD 141,141,141
    return TFborderColor;
}

+ (UIColor *)dOPDTFFontColor{
    
    static UIColor *TextColor;
    //0,154,221 (Digital meter)
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TextColor = [UIColor colorWithRed:133.0 / 255.0
                                        green:133.0 / 255.0
                                         blue:133.0 / 255.0
                                        alpha:1.0];
    });
    
    return TextColor;
}


+ (UIColor *)dOPDTextFontColor{
    
    static UIColor *TextColor;
    //0,154,221 (Digital meter)
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TextColor = [UIColor colorWithRed:85.0 / 255.0
                                    green:85.0 / 255.0
                                     blue:85.0 / 255.0
                                    alpha:1.0];
    });
    //OLD 141,139,139
    return TextColor;
}

//[view setBackgroundColor:[UIColor colorWithRed:221/255.0 green:231/255.0 blue:255/255.0 alpha:1.0]];

+ (UIColor *)dOPDBlueColor{
    
    static UIColor *SecBGColor;
    //0,154,221 (Digital meter)
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SecBGColor = [UIColor colorWithRed:221.0 / 255.0
                                    green:231.0 / 255.0
                                     blue:255.0 / 255.0
                                    alpha:1.0];
        
        
        
        SecBGColor = [UIColor colorWithRed:64.0/255.0
                                     green:170.0/255.0
                                      blue:224.0/255.0
                                     alpha:1.0];
    });
    
    return SecBGColor;
}

+ (UIColor *)dOPDImgBorderColor{
    
    static UIColor *ImgBGBorderColor;
    //0,154,221 (Digital meter)
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ImgBGBorderColor = [UIColor colorWithRed:228.0 / 255.0
                                     green:229.0 / 255.0
                                      blue:230.0 / 255.0
                                     alpha:1.0];
        
        
    });
    
    return ImgBGBorderColor;
}
@end
