//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Chris Black on 11/24/13.
//  Copyright (c) 2013 Chris Black. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingDeck.h"
#import "PlayingCard.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger lastScore;
@property (nonatomic, readwrite, strong) NSMutableArray *lastMatchedCards; // of Cards
@property (nonatomic, strong) NSMutableArray *cards; // of Cards
@end

@implementation CardMatchingGame

-(NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSMutableArray *)lastMatchedCards
{
    if (!_lastMatchedCards) _lastMatchedCards = [[NSMutableArray alloc] init];
    
    return _lastMatchedCards;
}

-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index]: nil;
}

static const int MISMATCH_PENATLY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

-(void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // match against other chosen cards
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.lastScore = matchScore * MATCH_BONUS;
                        self.score += self.lastScore;
                        otherCard.matched = YES;
                        card.matched = YES;
                        
                        // update lastMatchedCards
                        [self.lastMatchedCards removeAllObjects];
                        [self.lastMatchedCards addObject:otherCard];
                        [self.lastMatchedCards addObject:card];
                    } else {
                        self.score -= MISMATCH_PENATLY;
                        otherCard.chosen = NO;
                    }
                    break; // TODO: only 2 cards can be chosen for now
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}


@end
