//
//  ProgressBar.h
//  johnnychen
//
//  Created by Johnny Chen on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface ProgressBar : CCNode {

}

@property (nonatomic, assign) BOOL isFull;
@property (nonatomic, assign) BOOL didStartAnimation;
- (instancetype)initWithString:(NSString *)string;
- (void)reset;
- (void)increase;
- (void)blinkWhenFull;

@end
