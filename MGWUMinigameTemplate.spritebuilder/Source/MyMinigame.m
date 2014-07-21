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

static const int PLATFORM_EVERY_Y   = 100;
static const int PLATFORM_EVERY_X   = 200;

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
    
    CCNode         *_gameplayNode;
    CCNode         *_uiNode;
    CCNode         *_backgroundNode;
    
    CCSprite       *_gameOverStar;
    
    int            _score;
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
    _gameOverStar.physicsBody.collisionType = @"star";

    [self addPlatforms];
    [self addCoins];

    // We're calling a public method of the character that tells it to jump!
    [self.hero jump];
}

-(void)addPlatforms
{
    CGSize platformLayerSize = _platformLayer.contentSize;
    for (CGFloat y = PLATFORM_EVERY_Y; y <= platformLayerSize.height; y += PLATFORM_EVERY_Y) {
        for (CGFloat x  = 0.0f; x <= platformLayerSize.width; x += PLATFORM_EVERY_X) {
            CGPoint bottomLeft = CGPointMake(x, y);
            CGFloat xPos       = bottomLeft.x + (arc4random() % PLATFORM_EVERY_X);
            CGFloat yPos       = y;
            [self addPlatformAtX:xPos andY:yPos];
        }
    }
}

-(void)addPlatformAtX:(CGFloat)x andY:(CGFloat)y
{
    BricheyPlatform *newPlatform = (BricheyPlatform*)[CCBReader load:@"BricheyPlatform"];
    [newPlatform setupAtX:x andY:y];
    [_platforms     addObject:newPlatform];
    [_platformLayer addChild:newPlatform];
}

-(void)addCoins
{
    for (BricheyPlatform *platform in _platforms) {
        CGPoint platformLocation = platform.position;
        platformLocation.y += 50.0f;
        BricheyCoin *newCoin = (BricheyCoin*)[CCBReader load:@"BricheyCoin"];
        [newCoin setupAtX:platformLocation.x andY:platformLocation.y];
        [_coins       addObject:newCoin];
        [_coinLayer   addChild:newCoin];
    }
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
    
    self.hero.positionType = CCPositionTypePoints;
    if (self.hero.position.y >= 150) {
        CGFloat distanceFromMid = 150 - self.hero.position.y;
        //CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.2f position:ccp(0.0f, distanceFromMid)];
        //[_gameplayNode runAction:moveBy];
        //_platformLayer.position = CGPointMake(0.0f, distanceFromMid);
        //_coinLayer.position     = CGPointMake(0.0f, distanceFromMid);
        _gameplayNode.position = CGPointMake(0.0f, distanceFromMid);
    }
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair player:(MyCharacter*)player coin:(BricheyCoin*)coin {
    [[_physicsNode space] addPostStepBlock:^{
        _score++;
        _scoreDisplay.string = [NSString stringWithFormat:@"Score: %d", _score];
        if ([_coinLayer.children containsObject:coin]) {
            [coin removeFromParent];
        }
    } key:coin];
    
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair player:(MyCharacter*)player star:(CCSprite*)star {
    [[_physicsNode space] addPostStepBlock:^{
        if ([_coinLayer.children containsObject:star]) {
            [star removeFromParent];
            [self endMinigame];
        }
    } key:star];
    
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
