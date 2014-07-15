//
//  MGWUMinigameTemplate
//
//  Created by Zachary Barryte on 6/6/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "MyMinigame.h"

@implementation MyMinigame {
    BOOL _isTouching;
    CGPoint _initialTouch;
    CGPoint _currentTouch;
}

-(id)init {
    if ((self = [super init])) {
        // Initialize any arrays, dictionaries, etc in here
        self.instructions = @"These are the game instructions :D";
        self.userInteractionEnabled = TRUE;
        
        _isTouching = FALSE;
        
        self.hero.physicsBody.collisionType = @"Player";
    }
    return self;
}

-(void)didLoadFromCCB {
    // Set up anything connected to Sprite Builder here
    
    // We're calling a public method of the character that tells it to jump!
    [self.hero jump];
}

-(void)onEnter {
    [super onEnter];
    // Create anything you'd like to draw here
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Began");
    _isTouching = YES;
    _initialTouch = touch.locationInWorld;
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Ended");
    _isTouching = NO;
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    _currentTouch = touch.locationInWorld;
    if (_currentTouch.x < _initialTouch.x) {
        [self.hero moveLeft];
    } else if (_currentTouch.x > _initialTouch.x) {
        [self.hero moveRight];
    }
}

-(void)update:(CCTime)delta {
    // Called each update cycle
    // n.b. Lag and other factors may cause it to be called more or less frequently on different devices or sessions
    // delta will tell you how much time has passed since the last cycle (in seconds)
}

-(void)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair*)pair player:(CCNode*)player coin:(CCNode*)coin {
    CCLOG(@"Hit a coin");
}

-(void)endMinigame {
    // Be sure you call this method when you end your minigame!
    // Of course you won't have a random score, but your score *must* be between 1 and 100 inclusive
    [self endMinigameWithScore:arc4random()%100 + 1];
}

// DO NOT DELETE!
-(MyCharacter *)hero {
    return (MyCharacter *)self.character;
}
// DO NOT DELETE!

@end