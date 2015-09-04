//
//  Options.h
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 1/6/13.
//  Copyright (c) 2013 ASFM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "XYZViewController.h"
#import "InAppPurchaseManager.h"
#import <GameKit/GameKit.h>
#import "AppSpecificValues.h"
#import "GameCenterManager.h"

@class GameCenterManager;
@interface Options : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate>{
    
    IBOutlet UIButton *goBack;
    IBOutlet UILabel *highScore;
    IBOutlet UILabel *quizzesCompleted;
    IBOutlet UIButton *reset;
    IBOutlet UILabel *userOutput;
    IBOutlet UIScrollView *theScroller;
    IBOutlet UIImageView *bckgView;
    IBOutlet UIButton *buyDisableTimer;
    IBOutlet UISwitch *disableTimerSwitch;
    IBOutlet UISwitch *sound;
    IBOutlet UIButton *facebook;
    IBOutlet UIButton *restorePurchase;
    
    GameCenterManager *gameCenterManager;
    NSString* currentLeaderBoard;

    
}
-(IBAction)goHome:(id)sender;
-(void)resetScores;
-(IBAction)resetAlert:(id)sender;
-(IBAction)requestInformation:(id)sender;
-(IBAction) showLeaderboard;
-(IBAction) showAchievements;
-(IBAction) goToFacebook:(id)sender;
-(IBAction) restoreIAP:(id)sender;


@property (nonatomic, retain) IBOutlet UIButton *goBack;
@property (nonatomic, retain) IBOutlet UIButton *reset;
@property (nonatomic, retain) IBOutlet UILabel *highScore;
@property (nonatomic, retain) IBOutlet UILabel *quizzesCompleted;
@property (nonatomic, retain) IBOutlet UILabel *userOutput;
@property (nonatomic, retain) IBOutlet UIScrollView *theScroller;
@property (nonatomic, retain) IBOutlet UIImageView *bckgView;
@property (nonatomic, retain) IBOutlet UIButton *buyDisableTimer;
@property (nonatomic, retain) IBOutlet UISwitch *disableTimerSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *sound;
@property (nonatomic, retain) IBOutlet UIButton *facebook;
@property (nonatomic, retain) IBOutlet UIButton *restorePurchase;

@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;

@end
