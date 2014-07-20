//
//  BricheyCoin.m
//  MGWUMinigameTemplate
//
//  Created by Brandon Richey on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PhysicsCoin.h"

@implementation PhysicsCoin {
    CCSprite *_coinSprite;
}

-(void)moveToNewLocation
{
    CGFloat x = arc4random() % 568;
    CGFloat y = arc4random() % 160;
    self.position = CGPointMake(x, y);
}

-(id)initAtPositionX:(CGFloat)x andY:(CGFloat)y
{
    if (self = [self init]) {
        self.position = CGPointMake(x, y);
         CCLOG(@"Initialized at (%f, %f) / Size: (%f, %f)", self.position.x, self.position.y, self.contentSize.width, self.contentSize.height);
    }
    return self;
}

-(id)initAtRandomPosition
{
    if (self = [self init]) {
        [self moveToNewLocation];
         CCLOG(@"Initialized at (%f, %f) / Size: (%f, %f)", self.position.x, self.position.y, self.contentSize.width, self.contentSize.height);
    }
    return self;
}

-(id)init
{
    if (self = [super init]) {
        _coinSprite = [[CCSprite alloc] initWithImageNamed:@"items/plain-coin.png"];
        self.physicsBody.collisionType = @"coin";
        _coinSprite.contentSize = CGSizeMake(59.0f, 59.0f);
        self.contentSize = CGSizeMake(59.0f, 59.0f);
        self.scale = 0.25f;
        _coinSprite.visible = YES;
    }
    return self;
}

@end
