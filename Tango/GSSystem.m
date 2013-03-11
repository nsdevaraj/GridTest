//
//  GSSystem.m
//  GridSystem
//
//  Created by Matthew Palmer on 28/01/13.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import "GSSystem.h"
@interface UIApplication (AppDimensions)
+(CGSize) currentSize;
+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation UIApplication (AppDimensions)

+(CGSize) currentSize
{
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

@end
@implementation GSSystem

-(void)createPoints:(UIView *)withView :(BOOL)fullscreen
{
    CGRect screenRect = [withView bounds];
    CGFloat screenWidth;
    CGFloat screenHeight;
    if(fullscreen) {
       screenWidth = UIApplication.currentSize.width;
       screenHeight  = UIApplication.currentSize.height;
    }else{
        screenWidth = screenRect.size.width;
        screenHeight  = screenRect.size.height;
    }
    //NSLog(@"%f %f",screenWidth , screenHeight);
    //VERTICAL
    [self setOneTwelfthTop: 1*screenHeight/12];
    [self setTwoTwelfthsTop :2*screenHeight/12];
    [self setThreeTwelfthsTop: 3*screenHeight/12];
    [self setFourTwelfthsTop: 4*screenHeight/12];
    [self setFiveTwelfthsTop: 5*screenHeight/12];
    [self setSixTwelfthsTop: 6*screenHeight/12];
    [self setSevenTwelfthsTop: 7*screenHeight/12];
    [self setEightTwelfthsTop: 8*screenHeight/12];
    [self setNineTwelfthsTop: 9*screenHeight/12];
    [self setTenTwelfthsTop :10*screenHeight/12];
    [self setElevenTwelfthsTop :11*screenHeight/12];
    [self setTwelveTwelfthsTop :12*screenHeight/12];
    [self setOneTwentyFourTop :1*screenHeight/24];
    
    //HORIZONTAL
    [self setOneTwelfthLeft:1*screenWidth/12];
    [self setTwoTwelfthsLeft : 2*screenWidth/12];
    [self setThreeTwelfthsLeft : 3*screenWidth/12];
    [self setFourTwelfthsLeft: 4*screenWidth/12];
    [self setFiveTwelfthsLeft : 5*screenWidth/12];
    [self setSixTwelfthsLeft : 6*screenWidth/12];
    [self setSevenTwelfthsLeft : 7*screenWidth/12];
    [self setEightTwelfthsLeft : 8*screenWidth/12];
    [self setNineTwelfthsLeft : 9*screenWidth/12];
    [self setTenTwelfthsLeft :10*screenWidth/12];
    [self setElevenTwelfthsLeft : 11*screenWidth/12];
    [self setTwelveTwelfthsLeft : 12*screenWidth/12];
    [self setOneTwentyFourLeft : 1*screenWidth/24];
    
    
    //CUSTOM
    //E.G. 
    [self setFiftySixPercentLeft:56*screenWidth/100];
    
}

@end
