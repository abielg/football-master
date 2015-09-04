//
//  XYZViewController.h
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/3/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import "AppSpecificValues.h"
#import "GameCenterManager.h"

@class GameCenterManager;
@interface XYZViewController : UIViewController <ADBannerViewDelegate, UIActionSheetDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate>
{
    
    IBOutlet UIButton *startGame;
    IBOutlet UIButton *options;
    IBOutlet UIButton *unlocks;
    IBOutlet UIImageView *bckgView;
    ADBannerView *adBannerView;
    
    GameCenterManager *gameCenterManager;
    NSString* currentLeaderBoard;
    
}
-(IBAction) initiateGame:(id)sender;
-(IBAction) goToOptions:(id)sender;
-(IBAction) goToUnlocks:(id)sender;


@property (nonatomic, retain) IBOutlet UIButton *startGame;
@property (nonatomic, retain) IBOutlet UIButton *options;
@property (nonatomic, retain) IBOutlet UIButton *unlocks;
@property (nonatomic, retain) IBOutlet UIImageView *bckgView;
@property (nonatomic, retain) IBOutlet ADBannerView *adView;
@property (nonatomic, retain) ADBannerView *adBannerView;

@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;


@end
