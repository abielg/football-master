//
//  Unlocks.m
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 7/12/14.
//  Copyright (c) 2014 ASFM. All rights reserved.
//

#import "Unlocks.h"

@interface Unlocks ()

@end

@implementation Unlocks

@synthesize bckgView;
@synthesize goBack;
@synthesize facebook;
@synthesize appStore;
@synthesize lock1;
@synthesize lock2;
@synthesize lock3;
@synthesize lock4;
@synthesize count;
@synthesize skipLevelsSwitch;
@synthesize skipTheLevels;
@synthesize levelsUnlocked;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(IBAction)goHome:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) facebookCheck
{
    lock2.image = [UIImage imageNamed:@"ios7checkmark.png"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"likeFacebook"] == YES && [[NSUserDefaults standardUserDefaults] boolForKey:@"beatLevel10"] == YES)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"1113notif"] != YES)
        {
            UIAlertView *unlockNotification;
            
            unlockNotification = [[UIAlertView alloc]
                                  initWithTitle:@"Feature Unlocked!"
                                  message:@"You have unlocked levels 11-13."
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles: nil];
            
            [unlockNotification show];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"1113notif"];
        }
    }
}

-(void) appStoreCheck
{
    lock4.image = [UIImage imageNamed:@"ios7checkmark.png"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"achieved10Perfects"] == YES && [[NSUserDefaults standardUserDefaults] boolForKey:@"rateAppStore"] == YES)
    {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"skipLevels"];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"notifiedUser13"] != YES)
        {
            UIAlertView *unlockNotification;
            
            unlockNotification = [[UIAlertView alloc]
                                  initWithTitle:@"Feature Unlocked!"
                                  message:@"You can now enable the option to skip levels 1-3."
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles: nil];
            
            [unlockNotification show];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notifiedUser13"];
        }
        
        [skipTheLevels setHidden:NO];
        [skipLevelsSwitch setHidden:NO];
    }

}

-(IBAction)goToFacebook:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"fb://profile/595153780509096"];
    [[UIApplication sharedApplication] openURL:url];
    
    //Record that the button has been clicked
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"likeFacebook" ];
    
    [self performSelector:@selector(facebookCheck) withObject:nil afterDelay:1];
}

-(IBAction) goToAppStore:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/football-master/id651608590?ls=1&mt=8"]];
    
    //Record that the button has been clicked
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rateAppStore"];
    
    [self performSelector:@selector(appStoreCheck) withObject:nil afterDelay:1];
}

-(void) viewWillDisappear:(BOOL)animated
{
    if (skipLevelsSwitch.isOn == TRUE)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"wantsToSkipLevels"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"levelsSwitchState" ];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"wantsToSkipLevels"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"levelsSwitchState" ];
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
            bckgImage = [UIImage imageNamed:@"UnlocksBckg@2X.png"];
        }
        if(result.height == 568)
        {
            bckgImage = [UIImage imageNamed:@"UnlocksBckg-568h@2X.png"];
        }
    }
    
    bckgView.image = bckgImage;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"levelsSwitchState"] == YES)
    {
        [skipLevelsSwitch setOn:YES];
    }
    else
    {
        [skipLevelsSwitch setOn:NO];
    }

    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"beatLevel10"] == YES)
    {
        lock1.image = [UIImage imageNamed:@"ios7checkmark.png"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"likeFacebook"] == YES)
    {
        lock2.image = [UIImage imageNamed:@"ios7checkmark.png"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"rateAppStore"] == YES)
    {
        lock4.image = [UIImage imageNamed:@"ios7checkmark.png"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"achieved10Perfects"] == YES)
    {
        lock3.image = [UIImage imageNamed:@"ios7checkmark.png"];
    }
    
    //Count of levels 1-3 beaten perfectly
    int k = [[NSUserDefaults standardUserDefaults] integerForKey:@"timesLevels13Beaten"];
    NSString *count1 = [NSString stringWithFormat:@"(count: %i)", k];
    count.text = count1;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"skipLevels"] == NO)
    {
        [skipTheLevels setHidden:YES];
        [skipLevelsSwitch setHidden:YES];
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"skipLevels"] == YES)
    {
        [skipTheLevels setHidden:NO];
        [skipLevelsSwitch setHidden:NO];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"likeFacebook"] != YES || [[NSUserDefaults standardUserDefaults] boolForKey:@"beatLevel10"] != YES)
    {
        [levelsUnlocked setHidden:YES];
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"likeFacebook"] == YES && [[NSUserDefaults standardUserDefaults] boolForKey:@"beatLevel10"] == YES)
    {
        [levelsUnlocked setHidden:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
