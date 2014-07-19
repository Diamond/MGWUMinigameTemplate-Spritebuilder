//
//  BricheyCoin.h
//  MGWUMinigameTemplate
//
//  Created by Brandon Richey on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface BricheyCoin : CCSprite

-(void)moveToNewLocation;
-(id)initAtRandomPosition;
-(id)initAtPositionX:(CGFloat)x andY:(CGFloat)y;
-(id)init;

@end
