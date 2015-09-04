//
//  CorrectAnswer.m
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/3/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import "CorrectAnswer.h"
#import "QuizViewViewController.h"


@interface CorrectAnswer ()

@end

@implementation CorrectAnswer

@synthesize next;
@synthesize pointsEarned;
@synthesize pointsBonus;
@synthesize bckgView;
@synthesize playerCelebrating;



-(IBAction)nextQuestion:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) buttonShowing
{
    [next setHidden:NO];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(buttonShowing) withObject:nil afterDelay:0.4];
    
    if (lifeNotif==TRUE)
    {
        NSString *bonusLife = [NSString stringWithFormat:@"7 Streak Bonus: Extra Life!"];
        pointsBonus.text = bonusLife;
        lifeNotif=FALSE;
    }
    
    else if (fiftyNotif==TRUE)
    {
        NSString *bonusFifty = [NSString stringWithFormat:@"7 Streak Bonus: 50-50 Option!"];
        pointsBonus.text = bonusFifty;
        fiftyNotif=FALSE;
    }
    else
    {
        NSString *bonusPoints = [NSString stringWithFormat:@"(%i point time bonus)", timeBonus];
        pointsBonus.text = bonusPoints;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Screen Configuration
    UIImage *bckgImage;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            bckgImage = [UIImage imageNamed:@"correctBckg@2X.png"];
        }
        if(result.height == 568)
        {
            bckgImage = [UIImage imageNamed:@"correctBckg-568h@2X.png"];
        }
    }
    
    bckgView.image = bckgImage;
    
    
    [next setHidden: YES];
    
    NSString *pointsGained = [NSString stringWithFormat:@"+ %i Points!", pointsAwarded];
    pointsEarned.text = pointsGained;
    
    //Players Array
    UIImage *aguero = [UIImage imageNamed:@"Aguero.png"];
    UIImage *cavani = [UIImage imageNamed:@"Cavani.png"];
    UIImage *costa = [UIImage imageNamed:@"Costa.png"];
    UIImage *gerrard = [UIImage imageNamed:@"Gerrard.png"];
    UIImage *giroud = [UIImage imageNamed:@"Giroud.png"];
    UIImage *higuain = [UIImage imageNamed:@"Higuain.png"];
    UIImage *huntelaar = [UIImage imageNamed:@"Huntelaar.png"];
    UIImage *messi = [UIImage imageNamed:@"messi.png"];
    UIImage *pirlo = [UIImage imageNamed:@"Pirlo.png"];
    UIImage *reus = [UIImage imageNamed:@"Reus.png"];
    UIImage *ribery = [UIImage imageNamed:@"Ribery.png"];
    UIImage *ronaldo = [UIImage imageNamed:@"Ronaldo.png"];
    UIImage *sturridge = [UIImage imageNamed:@"Sturridge.png"];
    UIImage *torres = [UIImage imageNamed:@"torres.png"];
    UIImage *totti = [UIImage imageNamed:@"Totti.png"];
    UIImage *vanpersie = [UIImage imageNamed:@"VanPersie.png"];
    UIImage *zlatan = [UIImage imageNamed:@"zlatan.png"];
    
    playerArray = [[NSArray alloc] initWithObjects:aguero, cavani, costa, gerrard, giroud, higuain, huntelaar, messi, pirlo, reus, ribery, ronaldo, sturridge, torres, totti, vanpersie, zlatan, nil];
    
    NSUInteger randomIndex = arc4random() % [playerArray count];
    
    playerCelebrating.image = [playerArray objectAtIndex:randomIndex];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    bonusNotification.text = @"";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
