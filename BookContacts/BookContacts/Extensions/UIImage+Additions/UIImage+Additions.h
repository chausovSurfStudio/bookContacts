//
//  UIImage+Additions.h
//  Labirint
//
//  Created by Marina Zaytseva on 4/16/15.
//  Copyright (c) 2015 Surf. All rights reserved.
//
//  Категория от UIImage, с дополнительными функциями

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

/** получить картинку цвета color */
- (UIImage *)imageWithTintColor:(UIColor *)color;

/** получить картинку с прозрачностью alpha */
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

/** получить картинку в нужном размере */
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

@end