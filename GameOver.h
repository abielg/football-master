//
//  GameOver.h
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/11/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameOver : UIViewController{
    
    IBOutlet UIImageView *bckgView;
    IBOutlet UILabel *gameOverLabel;
    IBOutlet UILabel *finalScoreLabel;
    IBOutlet UILabel *highScoreLabel;
    IBOutlet UIButton *goHome;
    
    NSString* currentLeaderBoard;
    int64_t  currentScore;
    
}
-(IBAction) goHome:(id)sender;

@property (nonatomic, retain) IBOutlet UIImageView *bckgView;
@property (nonatomic, retain) IBOutlet UILabel *gameOverLabel;
@property (nonatomic, retain) IBOutlet UILabel *finalScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *highScoreLabel;
@property (nonatomic, retain) IBOutlet UIButton *goHome;

@property (nonatomic, retain) NSString* currentLeaderBoard;
@property (nonatomic, assign) int64_t currentScore;


@end

int points;
int pointsAwarded;
int answersNeededForNextLevel;
int questionsAnswered;
int totalQuestions;
int lives;

