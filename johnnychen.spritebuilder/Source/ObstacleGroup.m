//
//  ObstacleGroup.m
//  johnnychen
//
//  Created by Johnny Chen on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ObstacleGroup.h"
#import "Button.h"
#import "MainScene.h"

@implementation ObstacleGroup{
    CCNode *_buttonPlaceHolder;
    CCNode *_lobbyPlaceHolder;
    Button *x;
}


//+ (instancetype)obstacleGroupWithPhysicsNode:(CCPhysicsNode *)physicsNode
//                                withPosition:(CGPoint)location
//                                 inMainScene:(MainScene *)mainScene {
//    return [[self alloc] initWithPhysicsNode:physicsNode
//                                withPosition:location
//                                 inMainScene:mainScene];
//}
//
//- (instancetype)initWithPhysicsNode:(CCPhysicsNode *)physicsNode
//                       withPosition:(CGPoint)location
//                        inMainScene:(MainScene *)mainScene {
//    self = [super init];
//    if (self) {
//        int random = arc4random_uniform(5) + 1;
//        self = (ObstacleGroup*)[CCBReader load: [NSString stringWithFormat:@"og%i",random]];
//        self.positionInPoints = location;
//        //why position in points
//        [physicsNode addChild:self];
//        //why is self a node
//        [((ObstacleGroup*)self) addButtonToPlaceHolder];
//    }
//    return self;
//}

//since this is not an instance you have to pass reference to main
+ (ObstacleGroup*)addObstacleGroupTo:(CCPhysicsNode*)p locatedAt:(CGPoint)location withMain:(MainScene*)main {
    int random = arc4random_uniform(6) + 1;
    ObstacleGroup *obstacleGroup = (ObstacleGroup*)[CCBReader load: [NSString stringWithFormat:@"og%i",random]];
    
    obstacleGroup.main = main;
    [obstacleGroup addButtonToPlaceHolder];

    //i feel like you have to add it to the obstacle group
    [p addChild:obstacleGroup];
    obstacleGroup.position = location;
    
    return obstacleGroup;
    
    //NSLog(@"random is %d",random);
    
    //cant call instance variable and self in the class method but can do so in the instance method
}


+ (ObstacleGroup*)addObstacleGroupTo:(CCPhysicsNode *)p locatedAt:(CGPoint)location{
    int random = arc4random_uniform(6) + 1;
    ObstacleGroup *obstacleGroup = (ObstacleGroup*)[CCBReader load: [NSString stringWithFormat:@"og%i",random]];
    
    //obstacleGroup.main = main;
    [obstacleGroup addButtonToPlaceHolder];
    
    [p addChild:obstacleGroup];
    obstacleGroup.position = location;
    
    return obstacleGroup;
}


- (void)addButtonToPlaceHolder{
    
    //TODO:there might be different placeholders so you have to randomly choose
    //loop through the invisible nodes and randomly pick one
    x =[self.main getNextButton];
    [x removeFromParent];
    [self addChild:x];
    //x.positionInPoints = _buttonPlaceHolder.positionInPoints;
    [x addButtonAtPosition:_buttonPlaceHolder.positionInPoints];
    
    NSLog(@" button at %f %f", _buttonPlaceHolder.positionInPoints.x,_buttonPlaceHolder.positionInPoints.y);
}

- (void)addElevatorLobbyToPlaceHolder{
    ElevatorLobby *y = [self.main getNextElevatorLobby];
    //y.positionInPoints = ccp(_lobbyPlaceHolder.position.y);
}

//in the instance method you can call self.main
@end
