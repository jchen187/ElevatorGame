//
//  ElevatorLobby.m
//  johnnychen
//
//  Created by Johnny Chen on 7/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ElevatorLobby.h"
#import "MainScene.h"

@implementation ElevatorLobby{
    CCLabelTTF *_floor;
}


- (void)addElevatorLobby:(float)xPosition also:(float)yPosition{
    //the x position should be the same as the elevator
    self.position = ccp(xPosition,yPosition);
}

-(void)doorsClosed {
    _main.elevatorSpeed = 2;
}

//+ (ElevatorLobby *) makeNewElevatorLobby{
//    ElevatorLobby *newElevatorLobby = (ElevatorLobby *)[CCBReader load:@"ElevatorLobby" owner:self];
//    return newElevatorLobby;
//}

+ (ElevatorLobby *) makeNewElevatorLobby:(MainScene*)mainScene {
    ElevatorLobby *newElevatorLobby = (ElevatorLobby *)[CCBReader load:@"ElevatorLobby"];
    //[[newElevatorLobby animationManager]runAnimationsForSequenceNamed:@"Default"];
    return newElevatorLobby;
}

+ (ElevatorLobby *) makeNewElevatorLobby {
    ElevatorLobby *newElevatorLobby = (ElevatorLobby *)[CCBReader load:@"ElevatorLobby"];
    //[[newElevatorLobby animationManager]runAnimationsForSequenceNamed:@"Default"];
    return newElevatorLobby;
}

- (void)setFloor:(int)floor{
    _floor.string = [NSString stringWithFormat:@"%d",floor];
}
@end
