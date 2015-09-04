//
//  NextLevel.h
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/4/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizViewViewController.h"
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"

@class GameCenterManager;
@interface NextLevel : UIViewController<UIActionSheetDelegate, UIAlertViewDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate> {
    
    NSArray *playerArray;
    IBOutlet UIImageView *bckgView;
    IBOutlet UILabel *message;
    IBOutlet UILabel *pointsEarned;
    IBOutlet UILabel *bonusNotification;
    IBOutlet UIButton *nextQuestion;
    IBOutlet UIImageView *playerCelebrating;
    GameCenterManager *gameCenterManager;
}
-(IBAction)nextQuestion:(id)sender;
- (void) completeMultipleAchievements;

@property (nonatomic, retain) IBOutlet UIImageView *bckgView;
@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) IBOutlet UILabel *pointsEarned;
@property (nonatomic, retain) IBOutlet UILabel *bonusNotification;
@property (nonatomic, retain) IBOutlet UIButton *nextQuestion;
@property (nonatomic, retain) IBOutlet UIImageView *playerCelebrating;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;

@end

int points;
int pointsAwarded;
int answersNeededForNextLevel;
int questionsAnswered;
int totalQuestions;
int lives;
bool fiftyNotif;
bool lifeNotif;
int wrongAnswers;
int timesLevelsOneToThreeBeatenPerfectly;