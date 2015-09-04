//
//  GameOver.m
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/11/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import "GameOver.h"
#import "XYZViewController.h"


@interface GameOver ()

@end

@implementation GameOver

@synthesize bckgView;
@synthesize gameOverLabel;
@synthesize highScoreLabel;
@synthesize finalScoreLabel;
@synthesize goHome;

@synthesize currentLeaderBoard;
@synthesize currentScore;

-(IBAction)goHome:(id)sender{
    
    XYZViewController *xyz = [[XYZViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:xyz animated:NO completion: nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
            bckgImage = [UIImage imageNamed:@"GameOver@2X.png"];
        }
        if(result.height == 568)
        {
            bckgImage = [UIImage imageNamed:@"GameOver-568h@2X.png"];
        }
    }
    
    bckgView.image = bckgImage;
    
    //Submit HighScore
    self.currentLeaderBoard = kLeaderboardID;
    
    currentScore = points;
    GKScore * score = [[[GKScore alloc] initWithCategory:currentLeaderBoard] autorelease];
    score.value = currentScore;
    [score reportScoreWithCompletionHandler:^(NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            if (error == NULL)
            {
                NSLog(@"Score Sent");
            }
            else
            {
                NSLog(@"Score Failed");
            }
        });
    }];
    
    
    
    int highscore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"];
    
    if (points > highscore)
    {
        
        [[NSUserDefaults standardUserDefaults] setInteger: points forKey: @"highscore"];
        
        NSString *newHighscore = [NSString stringWithFormat:@"New High Score: %i", points];
        finalScoreLabel.text = newHighscore;
        highScoreLabel.text = @"";
    }
    
    else
    {
        NSString *finalScore = [NSString stringWithFormat:@"Your score: %i Points", points];
        finalScoreLabel.text = finalScore;
        
        NSString *updateHighscore = [NSString stringWithFormat:@"Highscore: %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"]];
        highScoreLabel.text=updateHighscore;
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
