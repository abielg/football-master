//
//  CorrectAnswer.h
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/3/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CorrectAnswer : UIViewController{
    
    IBOutlet UIImageView *bckgView;
    
    NSArray *playerArray;
    IBOutlet UIButton *next;
    IBOutlet UILabel *pointsEarned;
    IBOutlet UILabel *pointsBonus;
    IBOutlet UILabel *bonusNotification;
    IBOutlet UIImageView *playerCelebrating;
    
}

-(IBAction)nextQuestion:(id)sender;

@property (nonatomic, retain) IBOutlet UIImageView *bckgView;
@property (nonatomic, retain) IBOutlet UILabel *pointsEarned;
@property (nonatomic, retain) IBOutlet UILabel *pointsBonus;
@property (nonatomic, retain) IBOutlet UIButton *next;
@property (nonatomic, retain) IBOutlet UIImageView *playerCelebrating;

@end

int points;
int pointsAwarded;
int answersNeededForNextLevel;
int questionsAnswered;
int totalQuestions;
int lives;
int timeBonus;
bool lifeNotif;
bool fiftyNotif;