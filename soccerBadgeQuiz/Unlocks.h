//
//  Unlocks.h
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 7/12/14.
//  Copyright (c) 2014 ASFM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Unlocks : UIViewController < UIAlertViewDelegate, UIActionSheetDelegate >
{
    
    IBOutlet UIImageView *bckgView;
    IBOutlet UIButton *goBack;
    IBOutlet UIButton *facebook;
    IBOutlet UIButton *appStore;
    IBOutlet UIImageView *lock1;
    IBOutlet UIImageView *lock2;
    IBOutlet UIImageView *lock3;
    IBOutlet UIImageView *lock4;
    IBOutlet UILabel *count;
    IBOutlet UILabel *skipTheLevels;
    IBOutlet UILabel *levelsUnlocked;
    IBOutlet UISwitch *skipLevelsSwitch;
    
    
}
-(IBAction) goHome:(id)sender;
-(IBAction) goToFacebook:(id)sender;
-(IBAction) goToAppStore:(id)sender;

@property (nonatomic, retain) IBOutlet UIImageView *bckgView;
@property (nonatomic, retain) IBOutlet UIButton *goBack;
@property (nonatomic, retain) IBOutlet UIButton *facebook;
@property (nonatomic, retain) IBOutlet UIButton *appStore;
@property (nonatomic, retain) IBOutlet UIImageView *lock1;
@property (nonatomic, retain) IBOutlet UIImageView *lock2;
@property (nonatomic, retain) IBOutlet UIImageView *lock3;
@property (nonatomic, retain) IBOutlet UIImageView *lock4;
@property (nonatomic, retain) IBOutlet UILabel *count;
@property (nonatomic, retain) IBOutlet UILabel *skipTheLevels;
@property (nonatomic, retain) IBOutlet UILabel *levelsUnlocked;
@property (nonatomic, retain) IBOutlet UISwitch *skipLevelsSwitch;

@end

int timesLevelsOneToThreeBeatenPerfectly;