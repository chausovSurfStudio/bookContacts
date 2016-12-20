//
//  UIButton+CustomStyle.m
//  BookContacts
//
//  Created by Chausov Alexander on 20/12/16.
//  Copyright © 2016 Chausov Alexander. All rights reserved.
//

#import "UIButton+CustomStyle.h"
#import "UIImage+Additions.h"
#import "BCTThemeConstant.h"

@implementation UIButton (CustomStyle)

- (void)setSaveButtonStyle {
    [self setBackgroundImage:[self imageWithColor:extraTextNrmColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[[self imageWithColor:extraTextNrmColor] imageByApplyingAlpha:0.8] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[[self imageWithColor:extraTextNrmColor] imageByApplyingAlpha:0.8] forState:UIControlStateSelected];
    [self setBackgroundImage:[[self imageWithColor:extraTextNrmColor] imageByApplyingAlpha:0.8] forState:UIControlStateDisabled];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5.0f;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
