//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Chris Black on 11/10/13.
//  Copyright (c) 2013 Chris Black. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingDeck.h"
#import "PlayingCard.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) Card *card;
@end

@implementation CardGameViewController

- (Card *)card
{
    if (!_card) _card = [[Card alloc] init];
    
    return _card;
}

- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingDeck alloc] init];
    return _deck;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flipCount changed to %d", self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"Empty"]) {
        // do nothing
    } else {
        if ([sender.currentTitle length]) {
            [sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
                              forState:UIControlStateNormal];
            [sender setTitle:@"" forState:UIControlStateNormal];
        } else {
            self.card = [self.deck drawRandomCard];
            NSString *frontTitle = [NSString stringWithFormat:@"%@", self.card.contents];
        
            if (!self.card.contents) {
                frontTitle = @"Empty";
                [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                                forState:UIControlStateNormal];
                sender.titleLabel.font = [UIFont systemFontOfSize: 12];
                [sender setTitle:frontTitle forState:UIControlStateNormal];
            } else {
                [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                              forState:UIControlStateNormal];
                [sender setTitle:frontTitle forState:UIControlStateNormal];
                self.flipCount++;
            }
        }
    }
}



@end
