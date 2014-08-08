//
//  Obstacle.m
//  johnnychen
//
//  Created by Johnny Chen on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle
//{
//    int obstacleCount;
//    NSMutableArray *_obstacles;  //already in screen
//    NSMutableArray *_obstaclesToAdd;
//    int jitterAmount;
//}
//

//This was originally in mainscene

//#pragma mark - Add Obstacle
//
//- (void)addObstacle{
//    if(_obstaclesToAdd.count == 0){
//        //randomly select from the 3 we have
//        int random = arc4random_uniform(3) + 1;
//        CCNode *obstacleNode = [CCBReader load: [NSString stringWithFormat:@"Obstacle%i",random]];
//        _obstaclesToAdd = [NSMutableArray arrayWithArray:@[obstacleNode]];
//        //this was in the flappy bird
//        //_obstaclesToAdd = [NSMutableArray arrayWithArray:[obstacleNode children]];
//        //[obstacleNode removeAllChildren];
//        //[obstacleNode runAction:[CCActionRemove action]];
//        
//        //rejitter
//        jitterAmount = arc4random_uniform(50) - 20 ;
//    }
//    
//    obstacle = (Obstacle*)_obstaclesToAdd[0];
//    
//    [_obstaclesToAdd removeObjectAtIndex:0];
//    [obstacle removeFromParent];
//    
//    //    CGPoint screenPosition = [self convertToWorldSpace:ccp(SW/2 + jitterAmount,SH + 100)];
//    CGPoint screenPosition =ccp(SW/2 + jitterAmount,SH + 100);
//    //600 is the height of the the obstacle spawning. you dont want anything less
//    CGPoint worldPosition = [_physicsNode convertToNodeSpace:screenPosition];
//    
//    obstacle.positionInPoints = worldPosition;
//    [_physicsNode addChild:obstacle];
//    [_obstacles addObject:obstacle];
//}

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



@end
