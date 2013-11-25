//
//  PlayingCard.h
//  Matchismo
//
//  Created by Chris Black on 11/10/13.
//  Copyright (c) 2013 Chris Black. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
