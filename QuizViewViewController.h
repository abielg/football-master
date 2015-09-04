//
//  QuizViewViewController.h
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/3/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>



@interface QuizViewViewController : UIViewController
{
    
    IBOutlet UIImageView *bckgView;
    
    IBOutlet UIImageView *soccerCrest;
    IBOutlet UIButton *answerOne;
    IBOutlet UIButton *answerTwo;
    IBOutlet UIButton *answerThree;
    IBOutlet UIButton *answerFour;
   
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *soundOption;
    IBOutlet UIImageView *soundOptionImage;
    
    IBOutlet UIButton *fiftyFifty;
    IBOutlet UILabel *fiftyFiftyNumber;
    
    IBOutlet UILabel *levelNumber;
    IBOutlet UILabel *pointsCount;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *timeCount; 
    IBOutlet UILabel *livesLabel;
    IBOutlet UIImageView *lifeOne;
    IBOutlet UIImageView *lifeTwo;
    IBOutlet UIImageView *lifeThree;
    
    
    int time;
    int fiftyFiftyAmount;
    UIButton *selectedButton;
    Boolean viewIsPresent;
    NSTimer *quizTicker;
    NSArray *teamArray;
    NSMutableArray *levelArray;
    NSMutableArray *levelOne;
    NSMutableArray *levelTwo;
    NSMutableArray *levelThree;
    NSMutableArray *levelFour;
    NSMutableArray *levelFive;
    NSMutableArray *levelSix;
    NSMutableArray *levelSeven;
    NSMutableArray *levelEight;
    NSMutableArray *levelNine;
    NSMutableArray *levelTen;
    NSMutableArray *levelEleven;
    NSMutableArray *levelTwelve;
    NSMutableArray *levelThirteen;
    
}

-(IBAction) determineButton:(UIButton *)sender;
-(IBAction)goHome:(id)sender;
-(void) manageTime;
-(IBAction)fiftyFifty:(id)sender;
-(IBAction)changeSound:(id)sender;



@property (nonatomic, retain) IBOutlet UIImageView *bckgView;
@property (nonatomic, retain) IBOutlet UILabel *levelNumber;
@property (nonatomic, retain) IBOutlet UILabel *pointsCount;


@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeCount;

@property (nonatomic, retain) IBOutlet UIImageView *soccerCrest;
@property (nonatomic, retain) IBOutlet UIButton *answerOne;
@property (nonatomic, retain) IBOutlet UIButton *answerTwo;
@property (nonatomic, retain) IBOutlet UIButton *answerThree;
@property (nonatomic, retain) IBOutlet UIButton *answerFour;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *soundOption;
@property (nonatomic, retain) IBOutlet UIImageView *soundOptionImage;

@property (nonatomic, retain) IBOutlet UILabel *livesLabel;
@property (nonatomic, retain) IBOutlet UIImageView *lifeOne;
@property (nonatomic, retain) IBOutlet UIImageView *lifeTwo;
@property (nonatomic, retain) IBOutlet UIImageView *lifeThree;

@property (nonatomic, retain) IBOutlet UIButton *fiftyFifty;
@property (nonatomic, retain) IBOutlet UILabel *fiftyFiftyNumber;



@end

int points;
int pointsAwarded;
int answersNeededForNextLevel;
int questionsAnswered;
int totalQuestions;
int lives;
bool timeIsUp;
int answerStreak;
int timeBonus;
bool fiftyNotif;
bool lifeNotif;
int wrongAnswers;
int questionsAnsweredCorrectly;

