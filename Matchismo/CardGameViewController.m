//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Chris Black on 11/10/13.
//  Copyright (c) 2013 Chris Black. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (nonatomic, strong) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchedLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@end

@implementation CardGameViewController

-(CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];

    return _game;
}

-(Deck *)createDeck
{
    return [[PlayingDeck alloc] init];
}

- (IBAction)matchCount:(id)sender
{
    UISegmentedControl *segmentControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentControl.selectedSegmentIndex;
    
    if (self.game.newGame) {
        self.game.cardsToMatch = selectedSegment == 0 ? 2 : 3;
    
        NSLog(@"cards to match is: %d", self.game.cardsToMatch);
    } else {
        //segmentControl.enabled = NO;
    }
}

- (IBAction)resetButton:(UIButton *)sender
{
    for (int i = 1; i < [self.cardButtons count]; i++) {
        UIButton *cardButton = self.cardButtons[i];
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        card.chosen = NO;
        card.matched = NO;
        
        [cardButton setTitle:@"" forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"cardback"] forState:UIControlStateNormal];
        cardButton.enabled = YES;
    }
    
    self.game = nil;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.matchedLabel.text = [NSString stringWithFormat:@"Last Matched: "];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chooseButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chooseButtonIndex];
    [self updateUI];
}

-(void)updateUI
{
    // FIXME: not sure why self.cardButtons[0] isa UIView and not UIButton
    //for (UIButton *cardButton in self.cardButtons) {
    for (int i = 1; i < [self.cardButtons count]; i++) {
        UIButton *cardButton = self.cardButtons[i];
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];

        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
    
    self.matchedLabel.text = [self getLastMatchedCards];
}

-(NSString *)getLastMatchedCards
{
    NSMutableArray *matchedCards = self.game.lastMatchedCards;
    NSMutableString *matchedString = [NSMutableString stringWithFormat:@"Last Matched: "];
    
    for (Card *card in matchedCards) {
        [matchedString appendString:card.contents];
        [matchedString appendString:@" "];
    }
    
    [matchedString appendFormat:@"- %d points", self.game.lastScore];
    
    return matchedString;
}

-(NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}



@end
