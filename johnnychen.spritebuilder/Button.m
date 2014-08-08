//
//  Button.m
//  johnnychen
//
//  Created by Johnny Chen on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Button.h"

@implementation Button

- (void)addButton: (float) yPosition{
    //after every three obstacle, add button
    //int x = arc4random() % SW;
    int x = arc4random() % 200 + 50;
    self.positionInPoints = ccp(x,yPosition);
}

- (void)addButtonAtPosition:(CGPoint)p{
    self.positionInPoints = p;
}

+(Button*) makeNewButton{
    Button *newButton = (Button *)[CCBReader load:@"ElevatorButton"];
//    newButton.physicsBody.sensor = TRUE;
    return newButton;
}




@end
