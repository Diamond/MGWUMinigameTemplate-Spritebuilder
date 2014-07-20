//
//  BricheyPlatform.m
//  MGWUMinigameTemplate
//
//  Created by Brandon Richey on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "BricheyPlatform.h"

@implementation BricheyPlatform

-(void)moveToNewLocation
{
    CGFloat x = arc4random() % 568;
    CGFloat y = arc4random() % 160;
    self.position = CGPointMake(x, y);
}

-(void)setupAtX:(CGFloat)x andY:(CGFloat)y
{
    [self setup];
    self.position = CGPointMake(x, y);
}

-(void)setupAtRandomPoint
{
    [self setup];
    [self moveToNewLocation];
}

-(void)setup
{
    self.physicsBody.collisionType = @"platform";
    self.contentSize = CGSizeMake(217.0f, 67.0f);
    self.scale = 0.25f;
}

@end
