//
//  Card.h
//  Matchismo
//
//  Created by Chris Black on 11/10/13.
//  Copyright (c) 2013 Chris Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) NSString *contents;

@property (getter = isChosen, nonatomic) BOOL chosen;
@property (getter = isMatched, nonatomic) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
