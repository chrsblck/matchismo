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
@synthesize cardsToMatch=_cardsToMatch;

-(NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSInteger)cardsToMatch
{
    if (!_cardsToMatch) _cardsToMatch = 2;
    
    return _cardsToMatch;
}

-(void)setCardsToMatch:(NSInteger)cardsToMatch
{
    if (cardsToMatch == 2 || cardsToMatch == 3) {
        _cardsToMatch = cardsToMatch;
    }
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
        self.newGame = TRUE;
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

// this is a mess
-(void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSInteger chosenCount = 0;
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // match against other chosen cards
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    // count chosen cards
                    chosenCount++;
                    [chosenCards addObject:otherCard];
                    
                    if (chosenCount == self.cardsToMatch) {
                        break;
                    }
                }
            }
            
            if ([chosenCards count] == (self.cardsToMatch - 1)) {
                int matchScore = [card match:chosenCards];
                if (matchScore) {
                    // cleanup old matches
                    [self.lastMatchedCards removeAllObjects];
                    
                    for (Card *otherCard in chosenCards) {
                        self.lastScore = matchScore * MATCH_BONUS;
                        self.score += self.lastScore;
                        otherCard.matched = YES;
                        
                        // add matched cards
                        [self.lastMatchedCards addObject:otherCard];

                    }
                    card.matched = YES;
                    [self.lastMatchedCards addObject:card];
                } else {
                    self.score -= MISMATCH_PENATLY;
                    for (Card *otherCard in chosenCards) {
                        otherCard.chosen = NO;
                    }
                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    
    self.newGame = NO;
}


@end
