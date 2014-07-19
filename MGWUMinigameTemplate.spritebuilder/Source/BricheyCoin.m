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

-(id)initAtPositionX:(CGFloat)x andY:(CGFloat)y
{
    self = [self init];
    if (self) {
        self.position = CGPointMake(x, y);
    }
    return self;
}

-(id)initAtRandomPosition
{
    self = [self init];
    if (self) {
        [self moveToNewLocation];
    }
    return self;
}

-(id)init
{
    self = [super initWithImageNamed:@"items/star-coin-2.png"];
    if (self) {
        self.physicsBody.collisionType = @"coin";
        self.contentSize = CGSizeMake(59.0f, 59.0f);
        self.scale = 0.25f;
    }
    return self;
}

@end
