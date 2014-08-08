//
//  GamePlay.m
//  johnnychen
//
//  Created by Johnny Chen on 8/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"
#import "Obstacle.h"
#import "ObstacleGroup.h"
#import "ElevatorLobby.h"
#import "Button.h"
#import "PopUp.h"
#import "ProgressBar.h"
#define SW ([[CCDirector sharedDirector] viewSize].width)
#define SH ([[CCDirector sharedDirector] viewSize].height)

static int movingElevatorSpeed = 3;

@implementation GamePlay{
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
    
    float timestamp; //this is for the touchbutton
    float counttimestamp; //this is for the pause button and when you start
    float slowtimestamp;
    //make things private and then when you need to access you can make them private later
    
    //this it the label next to the elevator that displays what floor you are on but it is done
    CCLabelTTF *_floor;
    int whatFloor;
    
    CCNode *_contentNode;
    CGPoint desiredLocation;
    
    int space;
    ThingThatAppear *lastThing;

    int obstacleCount;
    //NSMutableArray *_obstacles;  //already in screen
    //NSMutableArray *_obstaclesToAdd;
    int jitterAmount;
    
    //this is the number of the office floor
    int officeFloor;
    
    CGPoint touchLocation;
    CGPoint newTouchLocation;
    NSTimeInterval mLastTapTime;
    
    float totalTime;
}

- (void)didLoadFromCCB {
    
    
    _character = [[Character alloc] initCharacter];
    [_physicsNode addChild:_character];
    [_character setSpeed: 0.0f ];
    [_character setAcceleration: 20];
    [_character setSpeedMultiplier:1.0f];
    
    self.elevatorSpeed = movingElevatorSpeed;
    _physicsNode.collisionDelegate = self;
    self.userInteractionEnabled = TRUE;
    
    
    lastThing = [CCNode node];
    lastThing.positionInPoints = ccp(_elevatorLobby.positionInPoints.x, 800);
    //the character is going to travel a distance of "space" before any random objects appear
    space = 1.5 * SH;

    
    _button = [Button makeNewButton];
    [_button addButton:900 ];
    _button.positionType = CCPositionTypeNormalized;
    [_physicsNode addChild:_button];
    _button.physicsBody.sensor = TRUE;
    
    _button2 = [Button makeNewButton];
    [_button2 addButton:10000];
    [_physicsNode addChild:_button2];
    _button2.physicsBody.sensor = TRUE;
    
    _buttonList = @[_button,_button2];
    
    //TODO: make the elevator with boss inside have random x
    float random = arc4random_uniform(SW-100)+100;
    
    
    //be careful with content size because it is usually 0
    _elevatorLobby = [ElevatorLobby makeNewElevatorLobby];
    [_elevatorLobby addElevatorLobby:SW/4 also:10000];
    [_physicsNode addChild:_elevatorLobby];
    //[[_elevatorLobby animationManager]runAnimationsForSequenceNamed:@"CloseDoor"];
    _button.correspondingElevatorLobby = _elevatorLobby;
    
    
    _elevatorLobby2 = [ElevatorLobby makeNewElevatorLobby];
    [_elevatorLobby2 addElevatorLobby:SW/4 also:10000];
    [_physicsNode addChild:_elevatorLobby2];
    _elevatorLobby2.physicsBody.sensor = TRUE;
    _button2.correspondingElevatorLobby = _elevatorLobby2;
    
    _elevatorLobbyList = @[_elevatorLobby,_elevatorLobby2];
    
    _character.physicsBody.collisionType = @"character";
    _button.physicsBody.collisionType = @"button";
    _button2.physicsBody.collisionType = @"button";
    
    obstacleCount = 0;
    
    whatFloor = 1;
    
    officeFloor = 20;
    mLastTapTime = [NSDate timeIntervalSinceReferenceDate];
    
    //_obstaclesToAdd = [NSMutableArray array];
    //_obstacles = [NSMutableArray array];
    

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
    
    if (diff < 0.3){
        _character.positionInPoints = ccp(_character.positionInPoints.x, _character.positionInPoints.y + 50);
        _character.distanceTraveled += 50;
        _contentNode.position = ccp(0, _contentNode.position.y - 50/SH);
        
    }
    
    mLastTapTime = [NSDate timeIntervalSinceReferenceDate];
    
}

- (void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
        newTouchLocation = [touch locationInNode:_contentNode];
        desiredLocation = newTouchLocation;
        [_character setDesiredX:desiredLocation.x];
        
        [_character setSpeed:2 * (newTouchLocation.x - _character.positionInPoints.x)];
    
        
}

#pragma mark - Collision With Button

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character button:(Button *)button
{
    if ([[[button.correspondingElevatorLobby animationManager] runningSequenceName] isEqualToString:@"Default"]) {
        [[button.correspondingElevatorLobby animationManager] runAnimationsForSequenceNamed:@"OpenDoor"];
        [[button animationManager] runAnimationsForSequenceNamed:@"touch"];
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

    
    if (_character.positionInPoints.y >= maxY){
            _character.distanceTraveled += _character.physicsBody.velocity.y * delta;
            //reset maxY
            maxY = _character.positionInPoints.y;
        }
        d = _character.distanceTraveled;
    
    //ELEVATOR LOBBY 2
    //OBSTACLE GROUP WITH BUTTON 2
    //ELEVATOR LOBBY 1
    //OBSTACLE GROUP WITH BUTTON 1
    
        if (d >= space){
            
            
            space = 768;
            jitterAmount = arc4random_uniform(50) - 20;
            //somehow physics is not on
            CGPoint screenPosition = [self convertToWorldSpace:ccp(jitterAmount,SH + 100)];
            CGPoint worldPosition = [_physicsNode convertToNodeSpace:screenPosition];
            
            if ((obstacleCount + 1) % 2 == 0){
                //add obstacle group
                ObstacleGroup *x =[ObstacleGroup addObstacleGroupTo:_physicsNode locatedAt:worldPosition];
                x.distanceToNext = 768;
                
                space = x.distanceToNext;
                lastThing = x;
                //how do i do the distance to next, space if I dont use an instance
                NSLog(@"character at %f %f",_character.positionInPoints.x,_character.positionInPoints.y);
            }
            else{
                if (obstacleCount % 4 == 0){
                    [_elevatorLobby addElevatorLobby:SW/4 also:worldPosition.y];
                    [_elevatorLobby setFloor:whatFloor];
                    _elevatorLobby.distanceToNext = 80;
                    space = _elevatorLobby.distanceToNext;
                    lastThing = _elevatorLobby;
                }
                else{
                    [_elevatorLobby2 addElevatorLobby:SW/4 also:worldPosition.y];
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
    
    if (_character.positionInPoints.y >= SH/2){
        _contentNode.position = ccp(0, _contentNode.position.y - _character.physicsBody.velocity.y/SH *delta);
    }

}



@end
