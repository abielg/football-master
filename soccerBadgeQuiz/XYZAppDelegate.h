//
//  XYZAppDelegate.h
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/3/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class XYZViewController;

@interface XYZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) XYZViewController *viewController;


@end
//original
extern int points; //total number of points
extern int pointsAwarded; //points gained each question
extern int answersNeededForNextLevel; //name says it
extern int questionsAnswered; //questions answered correctly
extern int totalQuestions; //total questions answered
extern int lives; //number of lives
extern bool timeIsUp; //changes the label in IncorrectAnswer from "incorrect" to "time ran down"
extern int answerStreak; //for bonus hints and lives
extern int timeBonus; //points given for answering quickly
extern bool fiftyNotif; //tells wether a 50-50 bonus has been awarded or not
extern bool lifeNotif; //tells wether a life has been awarded or not
extern int wrongAnswers;
extern int timesLevelsOneToThreeBeatenPerfectly;
