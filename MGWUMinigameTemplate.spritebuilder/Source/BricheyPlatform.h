//
//  BricheyPlatform.h
//  MGWUMinigameTemplate
//
//  Created by Brandon Richey on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface BricheyPlatform : CCSprite

-(void)moveToNewLocation;
-(id)initAtRandomPosition;

@end
