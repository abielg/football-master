//
//  GameCompleted.m
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/4/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import "GameCompleted.h"
#import "XYZViewController.h"
#import "GameCenterManager.h"
#import "AppSpecificValues.h"

@interface GameCompleted ()

@end

@implementation GameCompleted

@synthesize finalMessage;
@synthesize home;
@synthesize highScoreLabel;
@synthesize bckgView;
@synthesize gameCenterManager;
@synthesize currentLeaderBoard;
@synthesize currentScore;

-(IBAction)goHome:(id)sender{
    
    XYZViewController *xyz = [[XYZViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:xyz animated:NO completion:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    if (totalQuestions == 50)
    {
        UIAlertView *unlockNotification;
        
        unlockNotification = [[UIAlertView alloc]
                              initWithTitle:@"Want to unlock levels 11-13?"
                              message:@"All you have to do now is like our Facebook page in \"Unlocks\"."
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles: nil];
        
        [unlockNotification show];
    }
}


//ACHIEVEMENTS
- (void) completeMultipleAchievements
{
    if (totalQuestions==65)
    {
        if (wrongAnswers==0)
        {
            GKAchievement *achievement3 = [[GKAchievement alloc] initWithIdentifier: kAchievementBeatAll13];
            GKAchievement *achievement4 = [[GKAchievement alloc] initWithIdentifier: kAchievementBeatAll13Perf];
            achievement3.percentComplete = 100.0;
            achievement4.percentComplete = 100.0;
            achievement3.showsCompletionBanner = YES;
            achievement4.showsCompletionBanner = YES;
            NSArray *achievementsToComplete = [NSArray arrayWithObjects:achievement3,achievement4, nil];
            [GKAchievement reportAchievements: achievementsToComplete withCompletionHandler:^(NSError *error)
             {
                 if (error != nil)
                 {
                     NSLog(@"Error in reporting achievements: %@", error);
                 }
             }];
        }
        else
        {
            GKAchievement *achievement3 = [[GKAchievement alloc] initWithIdentifier: kAchievementBeatAll13];
            achievement3.percentComplete = 100.0;
            achievement3.showsCompletionBanner = YES;
            [achievement3 reportAchievementWithCompletionHandler:^(NSError *error)
             {
                 if (error != nil)
                 {
                     NSLog(@"Error in reporting achievements: %@", error);
                 }
             }];
        }
    }
    
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
    [self completeMultipleAchievements];
    
    //Screen Configuration
    UIImage *bckgImage;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            bckgImage = [UIImage imageNamed:@"QuizComplete@2X.png"];
        }
        if(result.height == 568)
        {
            bckgImage = [UIImage imageNamed:@"QuizComplete-568h@2X.png"];
        }
    }
    
    bckgView.image = bckgImage;
    
    
    
     int quizzesComplete = [[NSUserDefaults standardUserDefaults] integerForKey:@"quizzesComplete"];
    
    int i = 1 + quizzesComplete;
    [[NSUserDefaults standardUserDefaults] setInteger: i forKey: @"quizzesComplete"];
    
   
    if (totalQuestions==50)
    {
        NSString *ultimateMessage = [NSString stringWithFormat:@"You completed the first 10 levels with %i points.", points];
        finalMessage.text=ultimateMessage;
    }
    else if (totalQuestions==65)
    {
        NSString *ultimateMessage = [NSString stringWithFormat:@"You completed all 13 levels with %i points.", points];
        finalMessage.text=ultimateMessage;
    }
    
    int highscore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"];
    
    if (points > highscore) {
    
      [[NSUserDefaults standardUserDefaults] setInteger: points forKey: @"highscore"];  
    }
    
    NSString *updateHighscore = [NSString stringWithFormat:@"Highscore: %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"]];
    
    highScoreLabel.text=updateHighscore;
    
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
