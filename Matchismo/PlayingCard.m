//
//  PlayingCard.m
//  Matchismo
//
//  Created by Chris Black on 11/10/13.
//  Copyright (c) 2013 Chris Black. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (int i = 0; i < [otherCards count]; i++) {
        PlayingCard *otherCard = otherCards[i];
        score += [self matchCards:otherCard andPlayingCardTwo:self];
        
        for (int j = i + 1; j < [otherCards count]; j++) {
            PlayingCard *walkCard = otherCards[j];
            score += [self matchCards:otherCard andPlayingCardTwo:walkCard];
        }
    }
    
    return score;
}

- (int)matchCards:(PlayingCard *)playingCardOne andPlayingCardTwo:(PlayingCard *)playingCardTwo
{
    int score = 0;
    
    if (playingCardOne.rank == playingCardTwo.rank) {
        score = 4;
    } else if ([playingCardOne.suit isEqualToString:playingCardTwo.suit]) {
        score = 1;
    }

    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

+ (NSArray *)validSuits
{
    return @[@"♠︎",@"♣︎",@"♥︎",@"♦︎"];
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",
             @"7",@"8",@"9",@"10",@"J",@"Q",@"K",];
}

@end
