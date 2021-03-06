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
    BOOL           _displayingGameOver;
    CCLabelTTF     *_endGameDisplay;
    
    int            _score;
}

-(id)init {
    if ((self = [super init])) {
        // Initialize any arrays, dictionaries, etc in here
        self.instructions = @"Swipe left or right to move left or right, and swipe up to jump! Collect all of the coins on your way to the star!";
        self.userInteractionEnabled = TRUE;
        _endGameDisplay.visible = FALSE;
        
        _platforms = [[NSMutableArray alloc] init];
        _coins     = [[NSMutableArray alloc] init];
        _displayingGameOver = FALSE;

        _isTouching = FALSE;
        _score      = 0;
        
    }
    return self;
}

-(void)didLoadFromCCB {
    // Set up anything connected to Sprite Builder here
    _physicsNode.collisionDelegate = self;

    self.hero.physicsBody.collisionType     = @"player";
    _gameOverStar.physicsBody.collisionType = @"star";

    [self addPlatforms];
    [self addCoins];
    
    UISwipeGestureRecognizer * swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
    
    _endGameDisplay.visible = FALSE;
}

-(void)swipeUp
{
    [self.hero jump];
}

-(void)swipeLeft
{
    [self.hero moveLeft];
}

-(void)swipeRight
{
    [self.hero moveRight];
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
    
    if (_displayingGameOver) {
        [self endMinigame];
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    _isTouching = NO;
    [self.hero stopMoving];
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    return;
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
            [self youWin];
        }
    } key:star];

    return NO;
}

-(void)youWin
{
    _displayingGameOver = TRUE;
    _score += 25;
    _endGameDisplay.visible = TRUE;
    _gameplayNode.visible = FALSE;
    
    _endGameDisplay.string = [NSString stringWithFormat:@"You win! Final score: %d", _score];
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
