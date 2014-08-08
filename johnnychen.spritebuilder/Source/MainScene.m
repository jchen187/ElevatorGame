//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//
//#define CP_ALLOW_PRIVATE_ACCESS 1
#import "MainScene.h"
//#import "Character.h"
#import "Obstacle.h"
#import "ObstacleGroup.h"
#import "ElevatorLobby.h"
#import "Button.h"
#import "PopUp.h"
#import "ProgressBar.h"
//#define SW ([[UIScreen mainScreen] bounds].size.width)
//#define SH ([[UIScreen mainScreen] bounds].size.height)
#define SW ([[CCDirector sharedDirector] viewSize].width)
#define SH ([[CCDirector sharedDirector] viewSize].height)

//#import "CCPhysics+ObjectiveChipmunk.h"
static int movingElevatorSpeed = 3;

@implementation MainScene{
    Character *_character;
    float d; //the distance the character travels
    float maxY;
    
    //the reason i have two elevatorlobbies and two buttons is to switch between them
    Button *_button;
    Button *_button2;
    NSArray *_buttonList;
    
    ElevatorLobby *_elevatorLobby;
    ElevatorLobby *_elevatorLobby2;
    NSArray *_elevatorLobbyList;
    
    Obstacle *obstacle;
    CCPhysicsNode *_physicsNode;
    CCNode *_elevator;//this is for the code connection
    CCNode *_elevatorIcon;
    CCNode *spotLight;
    
    CCNode *_leftWall;
    CCNode *_rightWall;
    
    float timestamp; //this is for the touchbutton
    float counttimestamp; //this is for the pause button and when you start
    float slowtimestamp;
    //make things private and then when you need to access you can make them private later
    
    //this it the label next to the elevator that displays what floor you are on but it is done
    CCLabelTTF *_floor;
    int whatFloor;
    
    CCNode *_contentNode;
    CGPoint desiredLocation;
    
    CCNode *_b1;
    CCNode *_b2;
    NSArray *_background;
    
    int space;
    ThingThatAppear *lastThing;
    
    BOOL touchButton;               //when you touch a button
    
    int obstacleCount;
    NSMutableArray *_obstacles;  //already in screen
    NSMutableArray *_obstaclesToAdd;
    int jitterAmount;
    
    //CCParticleFire *_fire;
    //this would not work if you want it to appear multiple times
    //i want fire to appear everytime i click

    PopUp *popup;
    BOOL showTut;
    int tutNum;
    CCSprite *_popUpAnimation;
    CCSprite *_tutWall1;
    CCSprite *_tutWall2;
    CCSprite *_tutWall3;
    CCSprite *_leftCrate;
    CCSprite *_rightCrate;
    
    //the label on the top left that tells how fast you are going
    CCLabelTTF *_speed;
    CCButton *_pauseButton;
    //when play is true the game is not paused
    BOOL play;
    
    
    //this is the number of the office floor
    int officeFloor;
    BOOL gameOver;
    CCButton *restartButton;
    CCLabelTTF *winOrLose;
    CCLabelTTF *bestTimeLabel;
    float bestTime;
    
    CGPoint touchLocation;
    CGPoint newTouchLocation;
    NSTimeInterval mLastTapTime;
    
    CCLabelTTF *count;
    BOOL countdown; //using this to help countdown
    //tell who is who in the beginng
    CCLabelTTF *who;
    
    //with class
    ProgressBar *_p;
    NSUserDefaults *defaults;
    float totalTime;
}

- (void)didLoadFromCCB {
    
    _p = [[ProgressBar alloc] initWithString:@""];
    //_p = (ProgressBar *)[CCBReader load:@"ProgressBar"];
    [self addChild:_p];
    
    _character = [[Character alloc] initCharacter];
    [_physicsNode addChild:_character];
    [_character setSpeed: 0.0f ];
    [_character setAcceleration: 20];
    [_character setSpeedMultiplier:1.0f];
    
    self.elevatorSpeed = movingElevatorSpeed;
    _physicsNode.collisionDelegate = self;
    self.userInteractionEnabled = TRUE;

    _background = @[_b1,_b2];
    
    
    lastThing = [CCNode node];
    lastThing.positionInPoints = ccp(_elevatorLobby.positionInPoints.x, 800);
    //the character is going to travel a distance of "space" before any random objects appear
    //for iphone 3.5in
    space = 1.5 * SH;
    //for iphone 4in
    //space = SH;
    
    spotLight = [CCBReader load:@"Spotlight"];
    spotLight.visible = FALSE;
    [self addChild:spotLight];
    
    _button = [Button makeNewButton];
    [_button addButton:900 ];
    _button.positionType = CCPositionTypeNormalized;
    _button.position = ccp((_leftCrate.position.x + _rightCrate.position.x)/2,_leftCrate.position.y);
    [_physicsNode addChild:_button];
    _button.physicsBody.sensor = TRUE;
    
    _button2 = [Button makeNewButton];
    [_button2 addButton:10000];
    [_physicsNode addChild:_button2];
    _button2.physicsBody.sensor = TRUE;
    
    _buttonList = @[_button,_button2];
    
    //TODO: make the elevator with boss inside have random x
    float random = arc4random_uniform(SW-100)+100;
    
#pragma mark - Problem
    float x =clampf(random, 30, SW - 60);
    _elevator.positionInPoints= ccp(x, 45);
    NSLog(@"%f,%f",_elevator.positionInPoints.x,_elevator.positionInPoints.y);
    
    //before i had
    //_elevatorIcon = (CCSprite*)[CCBReader load:@"ElevatorIcon" owner:self];
    _elevatorIcon = (CCNode*)[CCBReader load:@"ElevatorIcon"];
    _elevatorIcon.positionInPoints = ccp(_elevator.positionInPoints.x,_elevator.positionInPoints.y);
    _elevatorIcon.scale = 0.08;
    [self addChild:_elevatorIcon];
    
    //be careful with content size because it is usually 0
    _elevatorLobby = [ElevatorLobby makeNewElevatorLobby:self];
    [_elevatorLobby addElevatorLobby:_elevator.positionInPoints.x also:10000];
    [_physicsNode addChild:_elevatorLobby];
    //[[_elevatorLobby animationManager]runAnimationsForSequenceNamed:@"CloseDoor"];
    _elevator.physicsBody.sensor = TRUE;
    _button.correspondingElevatorLobby = _elevatorLobby;
    
    
    _elevatorLobby2 = [ElevatorLobby makeNewElevatorLobby:self];
    [_elevatorLobby2 addElevatorLobby:_elevator.positionInPoints.x also:10000];
    [_physicsNode addChild:_elevatorLobby2];
    _elevatorLobby2.physicsBody.sensor = TRUE;
    _button2.correspondingElevatorLobby = _elevatorLobby2;
    
    _elevatorLobbyList = @[_elevatorLobby,_elevatorLobby2];
    
    //_physicsNode.debugDraw = TRUE;
    
    //[_character.physicsBody applyImpulse:ccp(0,10)];
    //applying impulse is bad because it makes it keep accelerating
    
    //need to do this because its not coming from sprite builder
    _character.physicsBody.collisionType = @"character";
    _button.physicsBody.collisionType = @"button";
    _button2.physicsBody.collisionType = @"button";
    
    obstacleCount = 0;
    showTut = FALSE;
    tutNum = 0;
    
    //zorder of 0 is the original layer. the positive the more on top it is
    //it is better to do z order here because you can see all of them at once
    _character.zOrder = 2;
    _leftWall.zOrder = 1;
    _rightWall.zOrder = 1;
    _elevator.zOrder = -1;
    //_elevatorIcon.zOrder = -10;
    //zorder only matter if they are in the same node. if ones in content node ones in physic it doesnt matter
    
    //_floor.visible = TRUE;
    whatFloor = 1;
    
    //_speed.positionInPoints = ccp(80, SH/2);
    //_pauseButton.positionInPoints = ccp(SW - 50, SH/2);
    
    play = TRUE;
    officeFloor = 20;
    //winOrLose = [[CCLabelTTF alloc] init];
    //restartButton = [[CCButton alloc] init];
    
    mLastTapTime = [NSDate timeIntervalSinceReferenceDate];
    countdown = TRUE;

    [_character setSlowDown:false];
    
    count = [CCLabelTTF labelWithString:@"" fontName:@"MarkerFelt-Thin" fontSize:24];
    count.positionInPoints = ccp(SW/2, SH/2);
    [self addChild:count];
    count.visible = FALSE;
    
    who = [CCLabelTTF labelWithString:@"" fontName:@"MarkerFelt-Thin" fontSize:18];
    [self addChild:who];
    who.visible = FALSE;
    
    _obstaclesToAdd = [NSMutableArray array];
    _obstacles = [NSMutableArray array];
    
    defaults = [NSUserDefaults standardUserDefaults];
}

- (Button*)getNextButton{
    //return 0 or 1
    return [_buttonList objectAtIndex:obstacleCount % 2];
}

- (ElevatorLobby*)getNextElevatorLobby{
    //return 0 or 1
    return [_elevatorLobbyList objectAtIndex:obstacleCount % 2];
}
#pragma mark - Touch Handling

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (play && !gameOver){
        //[character.physicsBody applyAngularImpulse:1000.f];
        //_character.physicsBody.sleeping = NO;
        [_character.physicsBody applyImpulse:ccp(0,0)]; //wake it up
        touchLocation = [touch locationInNode:_contentNode];
        desiredLocation = touchLocation;
        [_character setDesiredX:desiredLocation.x];
        
        [_character setSpeed:touchLocation.x - _character.positionInPoints.x];
        if (!_contentNode.paused) {
            CCParticleFire *fire = (CCParticleFire *)[CCBReader load:@"fire"];
            fire.positionInPoints = ccp(touchLocation.x, touchLocation.y);
            [_physicsNode addChild:fire];
            
        }
        
        NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval diff = currentTime - mLastTapTime;
        
        if (diff < 0.3 && _p.isFull){
            if (!showTut){
                if (!countdown) {
                    _character.positionInPoints = ccp(_character.positionInPoints.x, _character.positionInPoints.y + 50);
                    _character.distanceTraveled += 50;
                    _contentNode.position = ccp(0, _contentNode.position.y - 50/SH);
                    
                    _rightWall.position = ccp(0.008, _rightWall.position.y + 50/SH);
                    _leftWall.position = ccp(0.992, _leftWall.position.y + 50/SH);
                }
            }
            else if (showTut && tutNum == 3 ){
                [self removeChild:popup];
                _contentNode.paused = NO;
                _elevatorSpeed = movingElevatorSpeed;
                showTut = FALSE;
                
                _character.positionInPoints = ccp(_character.positionInPoints.x, _character.positionInPoints.y + 50);
                _character.distanceTraveled += 50;
                _contentNode.position = ccp(0, _contentNode.position.y - 50/SH);
                
                _rightWall.position = ccp(0.008, _rightWall.position.y + 50/SH);
                _leftWall.position= ccp(0.992, _leftWall.position.y + 50/SH);
//                _rightWall.positionInPoints = ccp(0, _rightWall.positionInPoints.y);
//                _leftWall.positionInPoints = ccp(0, _leftWall.positionInPoints.y);
                
                spotLight.visible = FALSE;
                [_character setSpeedMultiplier:1];
            }
            [_p reset];
            
        }
        
        mLastTapTime = [NSDate timeIntervalSinceReferenceDate];
    }
}

- (void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    if (play){
        newTouchLocation = [touch locationInNode:_contentNode];
        desiredLocation = newTouchLocation;
        [_character setDesiredX:desiredLocation.x];

        [_character setSpeed:2 * (newTouchLocation.x - _character.positionInPoints.x)];
        
        //_character.positionInPoints = ccp(newTouchLocation.x,_character.positionInPoints.y);
        //you cant gchange only one part
        
        //TODO:MAKE THIS BETTER because you canbreak this
        if (showTut && tutNum == 1 && newTouchLocation.x > (touchLocation.x + 50)){
            
            [self removeChild:popup];
            _contentNode.paused = NO;
            _elevatorSpeed = movingElevatorSpeed;
            showTut = FALSE;
            [_character setSpeedMultiplier:1];
        }
        if (showTut && tutNum == 2 && newTouchLocation.x < (touchLocation.x - 50)){
            
            [self removeChild:popup];
            _contentNode.paused = NO;
            _elevatorSpeed = movingElevatorSpeed;
            showTut = FALSE;
            [_character setSpeedMultiplier:1];
        }

    }
}

#pragma mark - Collision With Button

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character button:(Button *)button
{
    //self.elevatorSpeed = 0;
    //[self performSelector:@selector(stopElevator) withObject:nil afterDelay:2.0];
    //button.physicsBody.collisionMask = @[];
//    touchButton = TRUE;
    NSLog(@"%@",[[button.correspondingElevatorLobby animationManager]runningSequenceName]);
    if ([[[button.correspondingElevatorLobby animationManager] runningSequenceName] isEqualToString:@"Default"]) {
        touchButton = TRUE;
        [[button.correspondingElevatorLobby animationManager] runAnimationsForSequenceNamed:@"OpenDoor"];
        [[button animationManager] runAnimationsForSequenceNamed:@"touch"];
    }
    
//TODO:add powerups
    
    //return FALSE;
    //when you return false in a collision begin it means that the character and the button wont collide on screen. its the same as sensor = true
    return TRUE;
}

#pragma mark - Collision with Wall

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character wall:(CCNode *)wall
{
    //particle effect
    CCParticleSnow *snow = (CCParticleSnow *)[CCBReader load:@"Dust"];
    snow.positionInPoints = _character.positionInPoints;
    [_physicsNode addChild:snow];
    
    if (wall == _tutWall2){
        NSLog(@"collide with wall 2");
    }
    return TRUE;
}


#pragma mark - Stop elevator
- (void) stopElevator{
    _elevatorSpeed = 0;
}

#pragma mark - Update

- (void) fixedUpdate:(CCTime)delta{
    //delta is always 1/60

#pragma mark - Progress Bar
    if (!countdown && play && !gameOver){
        [_p increase];
        [_p blinkWhenFull];
    }
    
#pragma mark - icon following elevator
    CGPoint elevatorScreenPosition = [_physicsNode convertToWorldSpace:_elevator.positionInPoints];
//    CGPoint elevatorWorldPosition = [self convertToNodeSpace:_elevator.positionInPoints];
    if (elevatorScreenPosition.y > 20 && elevatorScreenPosition.y < SH - 20){
        _elevatorIcon.visible = FALSE;
    }
    else{
        _elevatorIcon.visible = TRUE;
    }
    _elevatorIcon.positionInPoints = ccp(_elevator.positionInPoints.x, clampf(elevatorScreenPosition.y, 20, SH-20));
    
    if (!gameOver){
        //if you
        if (!countdown || !showTut || play)
            totalTime += delta;
        //if you travel a certain amount you add a obstacle
        if (_contentNode.paused != TRUE && _character.positionInPoints.y >= maxY){
            _character.distanceTraveled += _character.physicsBody.velocity.y * delta;
            //reset maxY
            maxY = _character.positionInPoints.y;
        }
        d = _character.distanceTraveled;
        

        if (d >= space){
            //ELEVATOR LOBBY 2
            //OBSTACLE GROUP WITH BUTTON 2
            //ELEVATOR LOBBY 1
            //OBSTACLE GROUP WITH BUTTON 1
            
            space = 768;
            
            
            jitterAmount = arc4random_uniform(50) - 20;
            //somehow physics is not on
            CGPoint screenPosition = [self convertToWorldSpace:ccp(jitterAmount,SH + 100)];
            CGPoint worldPosition = [_physicsNode convertToNodeSpace:screenPosition];
            /*
            int random = arc4random() % 5 + 1;
            //arc4random() % 5 returns 0,1,2,3,4
            ObstacleGroup *og = (ObstacleGroup*)[CCBReader load: [NSString stringWithFormat:@"og%i",random]];
            og.positionInPoints = worldPosition;
            [_physicsNode addChild:og];
            */
            
            if ((obstacleCount + 1) % 2 == 0){
                //add obstacle group
                ObstacleGroup *x =[ObstacleGroup addObstacleGroupTo:_physicsNode locatedAt:worldPosition withMain:self];
                x.distanceToNext = 768;
                
                space = x.distanceToNext;
                lastThing = x;
                //how do i do the distance to next, space if I dont use an instance
                NSLog(@"character at %f %f",_character.positionInPoints.x,_character.positionInPoints.y);
            }
            else{
                if (obstacleCount % 4 == 0){
                    [_elevatorLobby addElevatorLobby:_elevator.positionInPoints.x also:worldPosition.y];
                    [_elevatorLobby setFloor:whatFloor];
                    _elevatorLobby.distanceToNext = 80;
                    space = _elevatorLobby.distanceToNext;
                    lastThing = _elevatorLobby;
                }
                else{
                    [_elevatorLobby2 addElevatorLobby:_elevator.positionInPoints.x also:worldPosition.y];
                    [_elevatorLobby2 setFloor:whatFloor];
                    _elevatorLobby2.distanceToNext = 80;
                    space = _elevatorLobby2.distanceToNext;
                    lastThing = _elevatorLobby2;
                }
                whatFloor++;
            }
        
            [_character restartDistance];
            obstacleCount++;
        }
        /*
         
         CGPoint screenPosition = [self convertToWorldSpace:ccp(SW/2 + jitterAmount,SH + 100)];
         CGPoint worldPosition = [_physicsNode convertToNodeSpace:screenPosition];
        if (d >= space){
         
//             Elevator Lobby 2   120
//             Obstacle           100
//             Obstacle           50
//             Button 2           50
//             Obstacle           100
//             Obstacle           100
//             Elevator Lobby 1
         
            
            //NSLog(@"%d",obstacleCount);
            CGPoint screenPosition = [self convertToWorldSpace:ccp(SW/2 + jitterAmount,SH + 100)];
            CGPoint worldPosition = [_physicsNode convertToNodeSpace:screenPosition];
            
            //add elevator lobby
            if (obstacleCount / 6  == officeFloor){
                //TODO: add the office which ends the game and put a boolean
                gameOver = TRUE;
                NSString *youWin;
                winOrLose = [CCLabelTTF labelWithString:@"" fontName:@"MarkerFelt-Thin" fontSize:24];
                //when you do labelwithString it already does alloc init so its not necessacy
                winOrLose.positionInPoints = ccp(SW/2, SH/2);
                
                if (_character.positionInPoints.y > _elevator.positionInPoints.y){
                    youWin = @"YOU WIN";
                    winOrLose.string = [NSString stringWithFormat:@"%@",youWin];
                }
                else{
                    youWin = @"YOU LOSE";
                    winOrLose.string = [NSString stringWithFormat:@"%@",youWin];
                }
                [self addChild:winOrLose];
                
                restartButton = [CCButton buttonWithTitle:@"RESTART" fontName:@"MarkerFelt-Thin" fontSize:24];
//                restartButton = [CCButton buttonWithTitle:@"RESTART"
                [restartButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"ccbResources/ccbButtonNormal.png"] forState:CCControlStateNormal];
                restartButton.positionInPoints = ccp(SW/2, SH/2 - 40);
                [restartButton setColor:[CCColor greenColor]];
                restartButton.preferredSize = CGSizeMake(100,45);
                [restartButton setBackgroundColor:[CCColor blackColor] forState:CCControlStateNormal];
                [self addChild:restartButton];
                
                [restartButton setTarget:self selector:@selector(restartGame)];
                
                bestTimeLabel = [CCLabelTTF labelWithString:@"" fontName:@"MarkerFelt-Thin" fontSize:24];
                bestTimeLabel.positionInPoints = ccp(SW/2,SH/2 - 80);
                
                if ([defaults floatForKey:@"BestTime"] > 0)
                    bestTime = [defaults floatForKey:@"BestTime"];
                else
                    bestTime = totalTime;
                if (totalTime <= bestTime){
                    [defaults setFloat:totalTime forKey:@"BestTime"];
                    [defaults synchronize];
                    
                }
            
                bestTimeLabel.string = [NSString stringWithFormat:@"Best Time is %.2f",[defaults floatForKey:@"BestTime"]];
                [self addChild:bestTimeLabel];
                
                _contentNode.paused = TRUE;
            }
            else if (obstacleCount % 6 == 0){
                //worldPosition = ccp(_elevator.positionInPoints.x, lastThing.positionInPoints.y + space);
                //this works like the original
                //if (TRUE){
                if (obstacleCount % 12 == 0){
                    [_elevatorLobby addElevatorLobby:_elevator.positionInPoints.x also:worldPosition.y];
                    [_elevatorLobby setFloor:whatFloor];
                    _elevatorLobby.distanceToNext = 80;
                    space = _elevatorLobby.distanceToNext;
                    lastThing = _elevatorLobby;
                    //NSLog(@"elevator1");
                    
                }
                else{
                    [_elevatorLobby2 addElevatorLobby:_elevator.positionInPoints.x also:worldPosition.y];
                    [_elevatorLobby2 setFloor:whatFloor];
                    _elevatorLobby2.distanceToNext = 80;
                    space = _elevatorLobby2.distanceToNext;
                    lastThing = _elevatorLobby2;
                    //NSLog(@"elevator2");
                }
                
                whatFloor++;
                obstacleCount++;
            }
            //add elevator button
            else if ((obstacleCount + 3) % 6 == 0){
                if ((obstacleCount + 3) % 12 == 0){
                    [_button addButton:worldPosition.y];
                    _button.distanceToNext = 50;
                    space = _button.distanceToNext;
                    lastThing = _button;
                    //NSLog(@"button");
                }
                else {
                    [_button2 addButton:worldPosition.y];
                    _button2.distanceToNext = 50;
                    space = _button2.distanceToNext;
                    lastThing = _button2;
                    //NSLog(@"button2");
                }
                
                obstacleCount++;
                //NSLog(@"%d",space);
            }
            //add obstacle
            else {
                [self addObstacle];
                if ((obstacleCount + 2) % 3 == 0){
                    obstacle.distanceToNext = 80;
                }
                else if ((obstacleCount + 1) % 6 == 0){
                    obstacle.distanceToNext = 130;
                }
                else{
                    obstacle.distanceToNext = 50;
                }
                obstacleCount++;
                lastThing = obstacle;
                space = obstacle.distanceToNext;
            }
            
            [_character restartDistance];
        }
        */
        
        
#pragma mark - Pop Up Comes Up
        if ([defaults boolForKey:@"ShownAllTutorials"] == FALSE){
            //the owner needs to be self because in spritebuilder the animation needs to be owner var
//            if (!showTut && tutNum == 0 && _character.positionInPoints.y > _tutWall1.positionInPoints.y - 70 && !slowDown){

            if (!showTut && tutNum == 0 && _character.positionInPoints.y > _tutWall1.positionInPoints.y - 70 && [_character getSlowDown] == FALSE){
                
                if (_character.positionInPoints.x < 2 * SW/3){
                    popup = (PopUp*)[CCBReader load:@"PopUp" owner:self];
                    popup.main = self;
                    popup.positionType = CCPositionTypeNormalized;
                    
                    //same as showPopUp:1
                    [popup showPopUp:PlayerActionSwipeRight];
                    [[_popUpAnimation animationManager] runAnimationsForSequenceNamed:@"Right"];
                    [self addChild:popup];
                    
                    //slowdown = TRUE;
                    //speedMultiplier = 0.6;
                    [self slowDown];
                    
                    //stop the character
//                    _contentNode.paused = YES;
                    _elevatorSpeed = 0;
                    
                    showTut = TRUE;
                }
                tutNum ++;
                
            }
            
            if (!showTut && tutNum == 1 && _character.positionInPoints.y > _tutWall2.positionInPoints.y - 70 && [_character getSlowDown] == FALSE){
                if (_character.positionInPoints.x > 2 * SW/3){
                    popup = (PopUp*)[CCBReader load:@"PopUp" owner:self];
                    popup.main = self;
                    popup.positionType = CCPositionTypeNormalized;
                    
                    [popup showPopUp:PlayerActionSwipeLeft];
                    [[_popUpAnimation animationManager] runAnimationsForSequenceNamed:@"Left"];
                    
                    [self addChild:popup];
                    //[self slowDown];
                    
                    _contentNode.paused = YES;
                    //self.paused = YES;
                    _elevatorSpeed = 0;
                    
                    showTut = TRUE;
                }
                tutNum ++;
            }
            
            if (!showTut && tutNum == 2 && _character.positionInPoints.y >= _tutWall3.positionInPoints.y - 35 && [_character getSlowDown] == FALSE){
                popup = (PopUp*)[CCBReader load:@"PopUp" owner:self];
                popup.main = self;
                popup.positionType = CCPositionTypeNormalized;
                
                [popup showPopUp:PlayerActionDoubleTap];
                [[_popUpAnimation animationManager] runAnimationsForSequenceNamed:@"Double Tap"];
                
                spotLight.visible = TRUE;
                spotLight.scaleX = 2;
                spotLight.positionInPoints = ccp(_p.positionInPoints.x + _p.contentSize.width, _p.positionInPoints.y);
                //might want to put back _topbar for the szie
                //its not that visible with the popup
                
                [self addChild:popup];
                
                _contentNode.paused = YES;
                _elevatorSpeed = 0;
                
                showTut = TRUE;
                tutNum++;
            }
            if (tutNum == 3){
                [defaults setBool:TRUE forKey:@"ShownAllTutorials"];
            }
        }
        
#pragma mark - Move elevator
        
        _elevator.positionInPoints = ccp(_elevator.positionInPoints.x, _elevator.positionInPoints.y+_elevatorSpeed);
        
#pragma mark - Update speed label
        if (_character.physicsBody.velocity.y >= 0){
            _speed.string = [NSString stringWithFormat:@"%.2f MPH",_character.physicsBody.velocity.y/4];
        }
        
#pragma mark - Loop background
        
        if (_character.positionInPoints.y >= SH/2){
            //dont scale the background. it should be 1,1
            for (CCNode *b in _background){
                CGPoint bWorldPosition = [_contentNode convertToWorldSpace:b.positionInPoints];
                // get the screen positionInPoints of the ground
                CGPoint bScreenPosition = [self convertToNodeSpace:bWorldPosition];

                if(bScreenPosition.y <= (-1 * b.contentSizeInPoints.height)){
                    b.positionInPoints = ccp(b.positionInPoints.x, b.positionInPoints.y + 2 * b.contentSizeInPoints.height);
                }
            }
            
            
            //you dont want to change the value of the x so it wants to be at 0
            //this ensures the character doesnt go off screen
            //when you dont multiply by delta, it goes up super quick
            
#pragma mark - Move contentNode and right and left wall as character goes up
            if (!_contentNode.paused) {
                /*
                //THIS IS THE ORIGINAL WHEN I DIDNT USED PERCENTS
                //you want he background to go down
                _contentNode.positionInPoints = ccp(0, _contentNode.positionInPoints.y - _character.physicsBody.velocity.y*delta);
                //you want the wall to go up
                _rightWall.positionInPoints = ccp(SW - 3, _rightWall.positionInPoints.y + _character.physicsBody.velocity.y*delta);
                _leftWall.positionInPoints = ccp(3, _leftWall.positionInPoints.y + _character.physicsBody.velocity.y*delta);
                */
                
                //try to make it work for percent
                _contentNode.position = ccp(0, _contentNode.position.y - _character.physicsBody.velocity.y/SH *delta);
                _leftWall.position = ccp(0.008,_leftWall.position.y + _character.physicsBody.velocity.y/SH * delta);
                                        
                _rightWall.position = ccp(0.992,_rightWall.position.y + _character.physicsBody.velocity.y/SH * delta);

            }
        }
        
#pragma mark - Stop elevator when touch button
        if (touchButton){
            //TODO: make power up show
            _elevatorSpeed = 0;
            timestamp += delta;
            if (floor(timestamp)>=2){
                _elevatorSpeed = movingElevatorSpeed;
                touchButton = FALSE;
                timestamp = 0;
            }
        }
        
    }
    
    
    
    if (countdown){
        count.visible = TRUE;
        _contentNode.paused = YES;
        _elevatorSpeed = 0;
        counttimestamp += delta;
        if (counttimestamp <= 3) {
            count.string = [NSString stringWithFormat:@"%d",(int) (3 - floor(counttimestamp))];
            spotLight.visible = TRUE;
            who.visible = TRUE;
            
            int x;
            //see what is left of what
            if (_elevator.positionInPoints.x < _character.positionInPoints.x){
                x = -20;
            }
            else{
                x = 20;
            }
            switch ((int)counttimestamp)
            {
                case 0:
                    spotLight.positionInPoints = _character.positionInPoints;
                    who.positionInPoints = ccp(_character.positionInPoints.x + x, _character.positionInPoints.y + 50);
                    who.string = [NSString stringWithFormat:@"You"];
                    break;
                case 2:
                    spotLight.positionInPoints = _elevator.positionInPoints;
                    spotLight.scale = 2;
                    who.string = [NSString stringWithFormat:@"Your Boss"];
                    who.positionInPoints = ccp(_elevator.positionInPoints.x - x, _elevator.positionInPoints.y + 70);
                    break;
            }
        }
        else if (counttimestamp > 3 && counttimestamp <= 4){
            who.visible = FALSE;
            spotLight.visible = FALSE;
            count.string = [NSString stringWithFormat:@"%s","GO"];
        }
        else if (counttimestamp > 4){
            
            counttimestamp = 0;
            //[self removeChild:count];
            _contentNode.paused = NO;
            countdown = FALSE;
            count.visible = FALSE;
            _elevatorSpeed = movingElevatorSpeed;
        }
        //count.string = [NSString stringWithFormat:@"%d",(int) (3 - floor(counttimestamp))];
    }
    
#pragma mark - Memory Management
    //why did it take less memory without the code under?
    if ([_obstacles count] > 6){
        Obstacle *obstacleToDelete = [_obstacles objectAtIndex:0];
        [_obstacles removeObjectAtIndex:0];
        [obstacleToDelete removeFromParentAndCleanup:TRUE];
        
    }
}

#pragma mark - 3.. 2.. 1.. countdown
- (void)countdown{
    
}

- (void)slowDown{
    [_character setSlowDown:TRUE];
}

#pragma mark - Play or pause
- (void)playOrPause {
    if (!gameOver){
        if (play == TRUE){
            self.paused = TRUE;
            play = FALSE;
            _pauseButton.title = @"Play";
        }
        else {
            //TODO: do the countdown so the player is ready
            countdown = TRUE;
            self.paused = FALSE;
            play = TRUE;
            _pauseButton.title = @"Pause";
        }
    }
}

#pragma mark - Restart Game
- (void)restartGame{
    CCTransition* t = [CCTransition transitionFadeWithDuration:0.4f];
    t.outgoingSceneAnimated = NO;
    t.incomingSceneAnimated = NO;
    //is it animated during transition
    
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:t];
}

- (void)backToMainMenu{
    
}

@end


//this is what makes the character keep going up
//_character.physicsBody.velocity = ccp(speed * delta,2);
//2 is too little


//TODO:add score. when i do it the label in the mainscene will be doc var
//label in popup will be ownervar
    
/*
 //This doesnt work because there are multiple locations
 //NSLog(@"%f,%f",newTouchLocation.x,newTouchLocation.y);
 CCActionMoveTo *newMove = [CCActionEase actionWithAction:[CCActionMoveTo actionWithDuration:.2f positionInPoints:ccp(newTouchLocation.x, _character.positionInPoints.y)]];
 
 [_character runAction:newMove];
 */

/*THIS ACTUALLY KIND OF WORKS
 float howFast = fabsf((touchLocation.x - _character.positionInPoints.x)/100);
 CCActionMoveTo *move = [CCActionEase actionWithAction:[CCActionMoveTo actionWithDuration:howFast positionInPoints:ccp(touchLocation.x, _character.positionInPoints.y)]];
 [_character runAction:move];
 //you can also do ccactioneasesinein
 */

//[[_character animationManager] runAnimationsForSequenceNamed:@"jumpingTimeLine"]

/*
 //Setting a bounding box to constrain the character between the left and right sides
 CGRect boundingBoxInPoints = CGRectMake(_contentNode.positionInPoints.x, _contentNode.positionInPoints.y, _contentNode.contentSize.width * SW, _contentNode.contentSize.height * SH * 1000.0f);
 
 //Follow the character
 followCharacter = [CCActionFollow actionWithTarget:_character worldBoundary:boundingBoxInPoints];
 followCharacter = [CCActionFollow actionWithTarget:_character];
 [_contentNode runAction:followCharacter];
 */

//CGPoint screenPosition = [self convertToWorldSpace:ccp(380, obstacle.positionInPoints.y +[[CCDirector sharedDirector] viewSize].height)/2 + _b1.contentSize.height/2 + jitterAmount)];
//CGPoint screenPosition = [self convertToWorldSpace:ccp(obstacle.positionInPoints.x + [[CCDirector sharedDirector] viewSize].width/2 + jitterAmount,600)];
//CGPoint screenPosition = [self convertToWorldSpace:ccp(0,600)];
//600 is the height of the the obstacle spawning. you dont want anything less because it looks like things just randomly come on screen

/*
 //This worked fine in the update method but it still goes through
 //slowing down the character if within a certain range
 
 if (abs(_character.positionInPoints.x - desiredLocation.x) > 3) {
    //_character.positionInPoints = ccp(_character.positionInPoints.x + speed * delta, _character.positionInPoints.y);
    _character.physicsBody.velocity = ccp(speed, 100);
 }
 else{
    _character.physicsBody.velocity = ccp(0, 100);
 }
*/

//now making the elevator go up and stopping on a regular basis every 2 seconds
/*
 timestamp += delta;
 
 int numSeconds = floor(timestamp);
 floor(2.34) equals 2. ceiling which is the opposite finds the next highest
 
 if (numSeconds % 2 == 0 ){
 //it stops when you have 3. something 6. something
 
 CCActionMoveTo *moveUp = [CCActionEase actionWithAction:[CCActionMoveTo actionWithDuration:.2f positionInPoints:ccp(_elevator.positionInPoints.x, _elevator.positionInPoints.y + 3)]];
 
 [_elevator runAction:moveUp];
 }
 */


/*
 //Looping the background
 //This only allows u to see the yellow one and then the blue one once
 for (CCNode *b in _background){
    if(_contentNode.positionInPoints.y <= (-1 * b.contentSize.height)){
        b.positionInPoints = ccp(b.positionInPoints.x, b.positionInPoints.y + 2 * b.contentSize.height);
    }
 }
*/

/*
 //how often the obstacles are spawned. over here they are spawned based on time which is bad if you get suck somewhere
 newtime += delta;
 if (newtime >  3.0f){
 [self addObstacle];
 newtime = 0;
 }
 NSLog(@"%f",_character.physicsBody.velocity.y);
 */

//    int elevatorSpeed;
//    BOOL open1;
//    BOOL open2;
//    //if touch the elevator button the elevator stops for 3 secs
//    if (touchButton){
//
//
//        if (timestamp == 0) {
//            //NSLog(@" the button is %d",obstacleCount);
//            if ((obstacleCount + 3) % 12 == 0){
//                [[_elevatorLobby animationManager] runAnimationsForSequenceNamed:@"OpenDoor"];
//                open1 = TRUE;
//            }
//            else{
//                [[_elevatorLobby2 animationManager] runAnimationsForSequenceNamed:@"OpenDoor"];
//                open2 = TRUE;
//            }
//        }
//
//        timestamp += delta;
//        int roundtime = floor(timestamp);
//        elevatorSpeed = 0;
//
//        if (roundtime > 3){
//            //stops elevator and resets the boolean to false and the timestamp back to 0
//            touchButton = FALSE;
//            timestamp = 0;
//
//            if (open1){
//                [[_elevatorLobby animationManager] runAnimationsForSequenceNamed:@"CloseDoor"];
//                open1 = FALSE;
//            }
//            else if (open2){
//                [[_elevatorLobby2 animationManager] runAnimationsForSequenceNamed:@"CloseDoor"];
//                open2 = FALSE;
//            }
//        }
//    }
//    //if dont touch the elevator moves up
//    else{
//        elevatorSpeed = 2;
//    }

//    _elevator.positionInPoints = ccp(_elevator.positionInPoints.x, _elevator.positionInPoints.y+elevatorSpeed);
//_elevator.physicsBody.velocity = ccp(0,elevatorSpeed);
