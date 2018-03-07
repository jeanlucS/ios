//
//  UIImage+Resizing.m
//  Migro
//
//  Created by Zo Rajaonarivony on 16/03/13.
//  Copyright (c) 2013 Ingenosya. All rights reserved.
//

//

#import "UIImage+Resizing.h"

@implementation UIImage (Resizing)

- (UIImage *)resizedByKeepingAspectRatio:(CGFloat)width
{
  CGSize newSize = CGSizeMake(width, width * self.size.height / self.size.width);
  UIGraphicsBeginImageContext(newSize);
  
  CGRect rect = CGRectZero;
  rect.size = newSize;
  [self drawInRect:rect];
  
  UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return resizedImage;
}

@end
