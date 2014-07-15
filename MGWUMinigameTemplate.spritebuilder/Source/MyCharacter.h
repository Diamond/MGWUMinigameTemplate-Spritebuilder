//
//  MGWUMinigameTemplate
//
//  Created by Zachary Barryte on 6/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MGWUCharacter.h"

@interface MyCharacter : MGWUCharacter

@property (nonatomic,assign) BOOL isJumping;
@property (nonatomic,assign) BOOL isIdle;

-(void)jump;
-(void)moveLeft;
-(void)moveRight;

@end
