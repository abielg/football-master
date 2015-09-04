//
//  GameCompleted.h
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/4/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"

@interface GameCompleted : UIViewController<UIActionSheetDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate>{
    
    IBOutlet UIImageView *bckgView;
    
    IBOutlet UIButton *home;
    IBOutlet UILabel *highScoreLabel;
    IBOutlet UILabel *finalMessage;
    GameCenterManager *gameCenterManager;
    
    NSString* currentLeaderBoard;
    int64_t  currentScore;
}
- (void) completeMultipleAchievements;
-(IBAction)goHome:(id)sender;

@property (nonatomic, retain) IBOutlet UIImageView *bckgView;
@property (nonatomic, retain) IBOutlet UILabel *highScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *finalMessage;
@property (nonatomic, retain) IBOutlet UIButton *home;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;

@property (nonatomic, retain) NSString* currentLeaderBoard;
@property (nonatomic, assign) int64_t currentScore;

@end


int points;
int pointsAwarded;
int answersNeededForNextLevel;
int questionsAnswered;
int totalQuestions;
int lives;
int wrongAnswers;