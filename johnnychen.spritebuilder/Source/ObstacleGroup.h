//
//  ObstacleGroup.h
//  johnnychen
//
//  Created by Johnny Chen on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ThingThatAppear.h"
@class MainScene;

@interface ObstacleGroup : ThingThatAppear

@property (nonatomic,weak) MainScene *main;
//you need to have this reference
@property (nonatomic, assign) float elevatorLobbyX;


//already has distance to next

//+ (instancetype)obstacleGroupWithPhysicsNode:(CCPhysicsNode *)physicsNode
//                                withPosition:(CGPoint)location
//                                 inMainScene:(MainScene *)mainScene;
//- (instancetype)initWithPhysicsNode:(CCPhysicsNode *)physicsNode
//                       withPosition:(CGPoint)location
//                        inMainScene:(MainScene *)mainScene;

+ (ObstacleGroup*)addObstacleGroupTo:(CCPhysicsNode*)p locatedAt:(CGPoint)location withMain:(MainScene*)main;


+ (ObstacleGroup*)addObstacleGroupTo:(CCPhysicsNode *)p locatedAt:(CGPoint)location;
//when you have a class method it is used like this
//[ObstacleGroup addObstacleGroupTo:_physicsNode];

//else it would look like this
//ObstacleGroup *og;
//[og addObstacleGroupTo:_physicsNode];

- (void)addButtonToPlaceHolder;

@end
