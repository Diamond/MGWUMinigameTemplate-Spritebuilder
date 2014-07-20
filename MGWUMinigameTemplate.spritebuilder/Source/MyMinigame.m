//
//  MGWUMinigameTemplate
//
//  Created by Zachary Barryte on 6/6/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "MyMinigame.h"
#import "BricheyCoin.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "BricheyPlatform.h"

static const int STARTING_PLATFORMS = 10;
static const int STARTING_COINS     = 10;

@implementation MyMinigame {
    BOOL _isTouching;
    CGPoint _initialTouch;
    CGPoint _currentTouch;
    
    CCLabelTTF    *_scoreDisplay;
    CCPhysicsNode *_physicsNode;
    
    NSMutableArray *_platforms;
    CCNode         *_platformLayer;
    
    NSMutableArray *_coins;
    CCNode         *_coinLayer;
    
    int _score;
}

-(id)init {
    if ((self = [super init])) {
        // Initialize any arrays, dictionaries, etc in here
        self.instructions = @"These are the game instructions :D";
        self.userInteractionEnabled = TRUE;
        
        _platforms = [NSMutableArray array];
        _coins     = [NSMutableArray array];

        _isTouching = FALSE;
        _score      = 0;
        
    }
    return self;
}

-(void)didLoadFromCCB {
    // Set up anything connected to Sprite Builder here
    _physicsNode.collisionDelegate = self;

    self.hero.physicsBody.collisionType = @"player";
    
    for (int i = 0; i < STARTING_PLATFORMS; i++) {
        BricheyPlatform *newPlatform = (BricheyPlatform*)[CCBReader load:@"BricheyPlatform"];
        [newPlatform setupAtRandomPoint];
        [_platforms     addObject:newPlatform];
        [_platformLayer addChild:newPlatform];
    }
    
    for (int i = 0; i < STARTING_COINS; i++) {
        CGPoint platformLocation = ((BricheyPlatform*)_platforms[i]).position;
        platformLocation.y += 50.0f;
        BricheyCoin *newCoin = (BricheyCoin*)[CCBReader load:@"BricheyCoin"];
        [newCoin setupAtX:platformLocation.x andY:platformLocation.y];
        [_coins       addObject:newCoin];
        [_coinLayer   addChild:newCoin];
    }

    // We're calling a public method of the character that tells it to jump!
    [self.hero jump];
}

-(void)onEnter {
    [super onEnter];
    // Create anything you'd like to draw here

}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    _isTouching = YES;
    _initialTouch = touch.locationInWorld;
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
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
    
    if (self.hero.position.y <= 0) {
        [self endMinigame];
    }
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair player:(MyCharacter*)player coin:(BricheyCoin*)coin {
    CCLOG(@"Hit a coin");
    
    [[_physicsNode space] addPostStepBlock:^{
        _score++;
        [coin moveToNewLocation];
        _scoreDisplay.string = [NSString stringWithFormat:@"Score: %d", _score];
//        if ([self.children containsObject:coin]) {
//            // [coin removeFromParent];
//
//        }
    } key:coin];
    
    return NO;
}

-(void)endMinigame {
    // Be sure you call this method when you end your minigame!
    // Of course you won't have a random score, but your score *must* be between 1 and 100 inclusive
    [self endMinigameWithScore:_score];
}

// DO NOT DELETE!
-(MyCharacter *)hero {
    return (MyCharacter *)self.character;
}
// DO NOT DELETE!

@end
