//
//  BricheyCoin.m
//  MGWUMinigameTemplate
//
//  Created by Brandon Richey on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "BricheyCoin.h"

@implementation BricheyCoin

-(void)moveToNewLocation
{
    CGFloat x = arc4random() % 568;
    CGFloat y = arc4random() % 160;
    self.position = CGPointMake(x, y);
}

@end
