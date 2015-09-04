//
//  IncorrectAnswer.h
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/4/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncorrectAnswer : UIViewController{
    
    IBOutlet UIImageView *bckgView;
    
    IBOutlet UIButton *next;
    IBOutlet UILabel *incorrectLabel;
    IBOutlet UILabel *numberOfLives;
}
-(IBAction)nextQuestion:(id)sender;

@property (nonatomic, retain) IBOutlet UIButton *next;
@property (nonatomic, retain) IBOutlet UIImageView *bckgView;
@property (nonatomic, retain) IBOutlet UILabel *incorrectLabel;
@property (nonatomic, retain) IBOutlet UILabel *numberOfLives;

@end

int points;
int pointsAwarded;
int answersNeededForNextLevel;
int questionsAnswered;
int totalQuestions;
int lives;
bool timeIsUp;