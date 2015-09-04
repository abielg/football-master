//
//  QuizViewViewController.m
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 9/3/12.
//  Copyright (c) 2012 ASFM. All rights reserved.
//

#import "QuizViewViewController.h"
#import "XYZViewController.h"
#import "CorrectAnswer.h"
#import "IncorrectAnswer.h"
#import "NextLevel.h"
#import "GameCompleted.h"
#import "GameOver.h"

@interface QuizViewViewController ()

@end

@implementation QuizViewViewController

@synthesize bckgView;
@synthesize levelNumber;
@synthesize pointsCount;
@synthesize timeLabel;
@synthesize timeCount;
@synthesize soccerCrest;
@synthesize answerOne;
@synthesize answerTwo;
@synthesize answerThree;
@synthesize answerFour;
@synthesize livesLabel;
@synthesize lifeOne;
@synthesize lifeTwo;
@synthesize lifeThree;
@synthesize backButton;
@synthesize fiftyFifty;
@synthesize fiftyFiftyNumber;
@synthesize soundOption;
@synthesize soundOptionImage;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    timeBonus = 0;
    pointsAwarded = 10;
    time = 14;
    timeCount.text = @"15";
    viewIsPresent = TRUE;
    timeIsUp = FALSE;
    
    //Show all buttons in case they were previously hidden in 50-50 option
    [answerOne setHidden:NO];
    [answerTwo setHidden:NO];
    [answerThree setHidden:NO];
    [answerFour setHidden:NO];
    
    //Timer setup
    quizTicker = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(manageTime) userInfo:nil repeats:YES];
    
    //Points Label
    NSString *numberOfPoints = [NSString stringWithFormat:@"%i Points", points];
    pointsCount.text = numberOfPoints;
    
    //FiftyFifty Label
    NSString *fiftyAmount = [NSString stringWithFormat:@"%i", fiftyFiftyAmount];
    fiftyFiftyNumber.text = fiftyAmount;
    
    
        //Update the number of soccer balls that state # of lives
        if (lives==3) 
        {
            lifeOne.image = [UIImage imageNamed:@"soccerball.png"];
            lifeTwo.image = [UIImage imageNamed:@"soccerball.png"];
            lifeThree.image = [UIImage imageNamed:@"soccerball.png"];
        }
    
        else if (lives==2) 
        {
            lifeOne.image = [UIImage imageNamed:@"soccerball.png"];
            lifeTwo.image = [UIImage imageNamed:@"soccerball.png"];
            lifeThree.image = nil;
        }
    
        else if (lives==1) 
        {
            lifeOne.image = [UIImage imageNamed:@"soccerball.png"];
            lifeTwo.image = nil;
            lifeThree.image = nil;
        }
    

        //Update the current Level label
        if (totalQuestions<5) 
        {
            levelArray=levelOne;
            levelNumber.text=@"Level 1";
        }
   
        else if (totalQuestions<10) 
        {
            levelArray=levelTwo;
            levelNumber.text=@"Level 2";
        }
   
        else if (totalQuestions<15) 
        {
            levelArray=levelThree;
            levelNumber.text=@"Level 3";
        }
    
        else if (totalQuestions<20) 
        {
            levelArray=levelFour;
            levelNumber.text=@"Level 4";
        }
    
        else if (totalQuestions<25) 
        {
            levelArray=levelFive;
            levelNumber.text=@"Level 5";
        }
    
        else if (totalQuestions<30) 
        {
            levelArray=levelSix;
            levelNumber.text=@"Level 6";
        }
        else if (totalQuestions<35)
        {
            levelArray=levelSeven;
            levelNumber.text=@"Level 7";
        }
        else if (totalQuestions<40)
        {
            levelArray=levelEight;
            levelNumber.text=@"Level 8";
        }
        else if (totalQuestions<45)
        {
            levelArray=levelNine;
            levelNumber.text=@"Level 9";
        }
        else if (totalQuestions<50)
        {
            levelArray=levelTen;
            levelNumber.text=@"Level 10";
        }
        else if (totalQuestions<55)
        {
            levelArray=levelEleven;
            levelNumber.text=@"Level 11";
        }
        else if (totalQuestions<60)
        {
            levelArray=levelTwelve;
            levelNumber.text=@"Level 12";
        }
        else if (totalQuestions<65)
        {
            levelArray=levelThirteen;
            levelNumber.text=@"Level 13";
        }
    
   
    //Set all answering buttons with their correspoding options
    NSUInteger randomIndex = arc4random() % [levelArray count];
    
    teamArray = [levelArray objectAtIndex: randomIndex];
    
    //Used to randomize the order of answer options
    NSMutableArray *answerButtons = [[NSMutableArray alloc] initWithCapacity:4];
    [answerButtons addObject:answerOne];
    [answerButtons addObject:answerTwo];
    [answerButtons addObject:answerThree];
    [answerButtons addObject:answerFour];
    
    soccerCrest.image = [teamArray objectAtIndex:0];
    for(int i = 1; i<5; i++)
    {
        NSUInteger randomIndex1 = arc4random() % [answerButtons count];
        [[answerButtons objectAtIndex:randomIndex1] setTitle: [teamArray objectAtIndex:i] forState: UIControlStateNormal];
        [answerButtons removeObjectAtIndex:randomIndex1];
    }
    
    /*
    [answerOne setTitle: [teamArray objectAtIndex:1] forState: UIControlStateNormal];
    [answerTwo setTitle: [teamArray objectAtIndex:2] forState: UIControlStateNormal];
    [answerThree setTitle: [teamArray objectAtIndex:3] forState: UIControlStateNormal];
    [answerFour setTitle: [teamArray objectAtIndex:4] forState: UIControlStateNormal];
    */
    
    [levelArray removeObjectAtIndex:randomIndex];
    
    
    //Show or remove fiftyFifty button and label
    if ( fiftyFiftyAmount==0 )
    {
        [fiftyFifty setHidden:YES];
        [fiftyFiftyNumber setHidden:YES];
    }
    
    else if (fiftyFiftyAmount>0)
    {
        [fiftyFifty setHidden:NO];
        [fiftyFiftyNumber setHidden:NO];
    }
}



//Manage the timer and resetting it depending on the scenario
-(void) manageTime 
{
        
    NSString *timerDigits = [NSString stringWithFormat:@"%i", time];
    timeCount.text = timerDigits;
    
        if (time<6 && time>0 && [[NSUserDefaults standardUserDefaults] boolForKey:@"soundWanted"] == YES)
        {
            SystemSoundID SoundID;
            NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"runningOut" ofType:@"wav"];
            AudioServicesCreateSystemSoundID((CFURLRef) [NSURL fileURLWithPath:soundFile], &SoundID);
            AudioServicesPlaySystemSound(SoundID);
        }
   
    time -=1;
    
        if (viewIsPresent==FALSE)
        {
            [quizTicker invalidate];
            quizTicker = nil;
            time = 14;
        }
    
        else if (time==-1 && [[NSUserDefaults standardUserDefaults] boolForKey:@"switchState"] == NO)
        {
            [quizTicker invalidate];
            quizTicker = nil;
    
            timeIsUp = TRUE;
            time = 14;
            lives -=1;
            wrongAnswers++;
            points -= 10;

            
                if (lives==0) 
                {
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundWanted"] == YES)
                    {
                        SystemSoundID SoundID;
                        NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"gameOver" ofType:@"wav"];
                        AudioServicesCreateSystemSoundID((CFURLRef) [NSURL fileURLWithPath:soundFile], &SoundID);
                        AudioServicesPlaySystemSound(SoundID);
                    }
                    
                    GameOver *over = [[GameOver alloc] initWithNibName:nil bundle:nil];
                    [self presentViewController:over animated:NO completion:nil];
                }
            
                else
                {
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundWanted"] == YES)
                    {
                        SystemSoundID SoundID;
                        NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"incorrect" ofType:@"wav"];
                        AudioServicesCreateSystemSoundID((CFURLRef) [NSURL fileURLWithPath:soundFile], &SoundID);
                        AudioServicesPlaySystemSound(SoundID);
                    }
                    
                    IncorrectAnswer *incorrect = [[IncorrectAnswer alloc] initWithNibName:nil bundle:nil];
                    [self presentViewController:incorrect animated:YES completion:nil];
                }
        }
        
}

//Change viewIsPresent boolean whenever the view has dissappeared (for use in timer)
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    viewIsPresent=FALSE;
    
    
    if (answerStreak==7 && lives<3)
    {
        if( points + time % 2 == 0) //the condition is to make it random between extra life or 50-50
        {
            fiftyFiftyAmount += 1;
            fiftyNotif = TRUE;
        }
        
        else
        {
            lives += 1;
            lifeNotif = TRUE;
        }
        
        answerStreak = 0;
    }
    
    else if (answerStreak==7)
    {
        fiftyFiftyAmount += 1;
        fiftyNotif = TRUE;
        answerStreak = 0;
    }
}


-(IBAction)fiftyFifty:(id)sender
{
    NSArray *ffOption = [[NSArray alloc] initWithObjects:answerOne, answerTwo, answerThree, answerFour, nil];
    
    int cleared = 0;
   
    for ( int i=0; i<[ffOption count] && cleared<2; i++)
    {
        UIButton *label = [ffOption objectAtIndex:i];
        
        if ( label.currentTitle != [teamArray objectAtIndex:5] )
        {
            [label setHidden:YES];
            cleared ++;
        }
    }
    fiftyFiftyAmount--;
    
    NSString *fiftyAmount = [NSString stringWithFormat:@"%i", fiftyFiftyAmount];
    fiftyFiftyNumber.text = fiftyAmount;
    [fiftyFifty setHidden:YES];
}


//Determine whether the answer is correct, and add points/subtract lives depending on outcome
-(IBAction) determineButton:(UIButton *)sender
{
    
    if (sender==answerOne)
    {
        selectedButton=answerOne;
    }
    else if (sender==answerTwo) 
    {
        selectedButton=answerTwo;
    }
    else if (sender==answerThree) 
    {
        selectedButton=answerThree;
    }
    else if (sender==answerFour) 
    {
        selectedButton=answerFour;
    }
    
    
    if (selectedButton.currentTitle==[teamArray objectAtIndex:5])
    {
        
        if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"switchState"] == NO)
        {
            timeBonus = time + 1;
        }
        else
        {
            timeBonus = 14;
        }
        pointsAwarded += timeBonus;
        points+= pointsAwarded;
        questionsAnswered+=1;
        totalQuestions+=1;
        answersNeededForNextLevel=5-questionsAnswered;
        answerStreak +=1;
        
        
        if (totalQuestions==65)
        {
            GameCompleted *complete = [[GameCompleted alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:complete animated:YES completion:nil];
        }   
        else if (totalQuestions==50 && [[NSUserDefaults standardUserDefaults] boolForKey:@"likeFacebook"] == NO)
        {
            GameCompleted *complete = [[GameCompleted alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:complete animated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"beatLevel10"];
        }
        else if (questionsAnswered==5)
        {
            NextLevel *next = [[NextLevel alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:next animated:YES completion:nil];
            questionsAnswered=0;
        }
        else 
        {
            CorrectAnswer *correct = [[CorrectAnswer alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:correct animated:YES completion:nil];
        }
    }   
    
    
    
    
    else if (selectedButton.currentTitle != [teamArray objectAtIndex:5]) 
    {
        lives-=1;
        answerStreak = 0;
        wrongAnswers ++;
        points -= 10;
        
        if (lives==0) 
        {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundWanted"] == YES)
            {
                SystemSoundID SoundID;
                NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"gameOver" ofType:@"wav"];
                AudioServicesCreateSystemSoundID((CFURLRef) [NSURL fileURLWithPath:soundFile], &SoundID);
                AudioServicesPlaySystemSound(SoundID);
            }
            
            GameOver *over = [[GameOver alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:over animated:NO completion:nil];
        } 
    
        else 
        {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundWanted"] == YES)
            {
                SystemSoundID SoundID;
                NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"incorrect" ofType:@"wav"];
                AudioServicesCreateSystemSoundID((CFURLRef) [NSURL fileURLWithPath:soundFile], &SoundID);
                AudioServicesPlaySystemSound(SoundID);
            }
            
            IncorrectAnswer *incorrect = [[IncorrectAnswer alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:incorrect animated:YES completion:nil];
        }
    }
}

-(IBAction)changeSound:(id)sender
{
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"soundWanted"] == NO)
    {
        soundOptionImage.image = [UIImage imageNamed:@"soundOn.png"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"soundWanted" ];
        
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundWanted"] == YES)
    {
        soundOptionImage.image = [UIImage imageNamed:@"soundOff.png"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"soundWanted" ];
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
            bckgImage = [UIImage imageNamed:@"quizViewBckg1@2X.png"];
        }
        if(result.height == 568)
        {
            bckgImage = [UIImage imageNamed:@"quizViewBckg1-568h@2X.png"];
        }
    }
    
    bckgView.image = bckgImage;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"switchState"] == YES)
    {
        [timeCount setHidden:YES];
    }

    
    //Sound Configuration
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"soundWanted"] == NO)
    {
        soundOptionImage.image = [UIImage imageNamed:@"soundOff.png"];
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundWanted"] == YES)
    {
        soundOptionImage.image = [UIImage imageNamed:@"soundOn.png"];
    }
    
    //Default points and scores
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"wantsToSkipLevels"] == YES)
    {
        points = 360;
        pointsCount.text=@"360 Points";
        questionsAnswered = 0;
        totalQuestions=15;
        lives = 3;
        fiftyFiftyAmount = 0;
        answerStreak = 0;
        wrongAnswers = 0;
    }
    else
    {
    points = 0;
    pointsCount.text=@"0 Points";
    questionsAnswered = 0;
    totalQuestions=0;
    lives = 3;
    fiftyFiftyAmount = 0;
    answerStreak = 0;
    wrongAnswers = 0;
    }
    
    ////////      LEVEL 1       /////////
    
    //AC Milan
    UIImage *milanCrest = [UIImage imageNamed:@"ACMilan.png"]; 
    NSString *milanOne = @"AC Milan";
    NSString *milanTwo = @"Cesena";
    NSString *milanThree = @"Liverpool";
    NSString *milanFour = @"Middlesbrough";
    NSString *milanAnswer = @"AC Milan";
    NSArray *milanArray = [[NSArray alloc] initWithObjects:milanCrest, milanOne, milanTwo, milanThree, milanFour, milanAnswer, nil];
    
    //Arsenal
    UIImage *arsenalCrest = [UIImage imageNamed:@"Arsenal.png"]; 
    NSString *arsenalOne = @"Charlton Athletic";
    NSString *arsenalTwo = @"Arsenal";
    NSString *arsenalThree = @"Granada CF";
    NSString *arsenalFour = @"Kaiserlautern";
    NSString *arsenalAnswer = @"Arsenal";
    NSArray *arsenalArray = [[NSArray alloc] initWithObjects:arsenalCrest, arsenalOne, arsenalTwo, arsenalThree, arsenalFour, arsenalAnswer, nil];
    
    //Atletico Madrid
    UIImage *atletiCrest = [UIImage imageNamed:@"AtleticoMadrid.png"]; 
    NSString *atletiOne = @"Athletic Bilbao";
    NSString *atletiTwo = @"Stoke City";
    NSString *atletiThree = @"Atletico Madrid";
    NSString *atletiFour = @"Estudiantes La Plata";
    NSString *atletiAnswer = @"Atletico Madrid";
    NSArray *atletiArray = [[NSArray alloc] initWithObjects:atletiCrest, atletiOne, atletiTwo, atletiThree, atletiFour, atletiAnswer, nil];
    
    //Barcelona
    UIImage *barcaCrest = [UIImage imageNamed:@"Barcelona.png"]; 
    NSString *barcaOne = @"Levante";
    NSString *barcaTwo = @"Livorno";
    NSString *barcaThree = @"Valencia";
    NSString *barcaFour = @"Barcelona";
    NSString *barcaAnswer = @"Barcelona";
    NSArray *barcaArray = [[NSArray alloc] initWithObjects:barcaCrest, barcaOne, barcaTwo, barcaThree, barcaFour, barcaAnswer, nil];
    
    //Bayern Munich
    UIImage *bayernCrest = [UIImage imageNamed:@"BayernMunich.png"]; 
    NSString *bayernOne = @"Bayern Munich";
    NSString *bayernTwo = @"Schalke 04";
    NSString *bayernThree = @"Deportivo La Coruña";
    NSString *bayernFour = @"FC Cologne";
    NSString *bayernAnswer = @"Bayern Munich";
    NSArray *bayernArray = [[NSArray alloc] initWithObjects:bayernCrest, bayernOne, bayernTwo, bayernThree, bayernFour, bayernAnswer, nil];
    
    //Borussia Dortmund
    UIImage *dortCrest = [UIImage imageNamed:@"BorussiaDortmund.png"]; 
    NSString *dortOne = @"BATE Borisov";
    NSString *dortTwo = @"Borussia Dortmund";
    NSString *dortThree = @"Villarreal";
    NSString *dortFour = @"Valladolid";
    NSString *dortAnswer = @"Borussia Dortmund";
    NSArray *dortArray = [[NSArray alloc] initWithObjects:dortCrest, dortOne, dortTwo, dortThree, dortFour, dortAnswer, nil];
    
    //Chelsea
    UIImage *chelseaCrest = [UIImage imageNamed:@"Chelsea.png"]; 
    NSString *chelseaOne = @"Wigan";
    NSString *chelseaTwo = @"Leeds United";
    NSString *chelseaThree = @"Chelsea";
    NSString *chelseaFour = @"Rangers";
    NSString *chelseaAnswer = @"Chelsea";
    NSArray *chelseaArray = [[NSArray alloc] initWithObjects:chelseaCrest, chelseaOne, chelseaTwo, chelseaThree, chelseaFour, chelseaAnswer, nil];
    
    //Inter Milan
    UIImage *interCrest = [UIImage imageNamed:@"InterMilan.png"]; 
    NSString *interOne = @"Inter Porto Alegre";
    NSString *interTwo = @"Fiorentina";
    NSString *interThree = @"Montpellier";
    NSString *interFour = @"Inter Milan";
    NSString *interAnswer = @"Inter Milan";
    NSArray *interArray = [[NSArray alloc] initWithObjects:interCrest, interOne, interTwo, interThree, interFour, interAnswer, nil];
    
    //Juventus
    UIImage *juveCrest = [UIImage imageNamed:@"Juventus.png"]; 
    NSString *juveOne = @"Juventus";
    NSString *juveTwo = @"Siena";
    NSString *juveThree = @"Udinese";
    NSString *juveFour = @"Mochengladbach";
    NSString *juveAnswer = @"Juventus";
    NSArray *juveArray = [[NSArray alloc] initWithObjects:juveCrest, juveOne, juveTwo, juveThree, juveFour, juveAnswer, nil];
    
    //Liverpool
    UIImage *liverCrest = [UIImage imageNamed:@"Liverpool.png"]; 
    NSString *liverOne = @"Southampton";
    NSString *liverTwo = @"Liverpool";
    NSString *liverThree = @"Sunderland";
    NSString *liverFour = @"Aston Villa";
    NSString *liverAnswer = @"Liverpool";
    NSArray *liverArray = [[NSArray alloc] initWithObjects:liverCrest, liverOne, liverTwo, liverThree, liverFour, liverAnswer, nil];
    
    //Lyon
    UIImage *lyonCrest = [UIImage imageNamed:@"Lyon.png"]; 
    NSString *lyonOne = @"Olympique Marseille";
    NSString *lyonTwo = @"LOSC Lille";
    NSString *lyonThree = @"Lyon";
    NSString *lyonFour = @"Levante";
    NSString *lyonAnswer = @"Lyon";
    NSArray *lyonArray = [[NSArray alloc] initWithObjects:lyonCrest, lyonOne, lyonTwo, lyonThree, lyonFour, lyonAnswer, nil];
    
    //Manchester City
    UIImage *mancityCrest = [UIImage imageNamed:@"ManchesterCity.png"]; 
    NSString *mancityOne = @"Napoli";
    NSString *mancityTwo = @"Lazio";
    NSString *mancityThree = @"Hoffenheim";
    NSString *mancityFour = @"Manchester City";
    NSString *mancityAnswer = @"Manchester City";
    NSArray *mancityArray = [[NSArray alloc] initWithObjects:mancityCrest, mancityOne, mancityTwo, mancityThree, mancityFour, mancityAnswer, nil];
    
    //Manchester United
    UIImage *manutdCrest = [UIImage imageNamed:@"ManchesterUnited.png"]; 
    NSString *manutdOne = @"Manchester United";
    NSString *manutdTwo = @"AS Saint Etienne";
    NSString *manutdThree = @"Stoke City";
    NSString *manutdFour = @"Dusseldorf";
    NSString *manutdAnswer = @"Manchester United";
    NSArray *manutdArray = [[NSArray alloc] initWithObjects:manutdCrest, manutdOne, manutdTwo, manutdThree, manutdFour, manutdAnswer, nil];
    
    //PSG
    UIImage *psgCrest = [UIImage imageNamed:@"PSG.png"]; 
    NSString *psgOne = @"FC Lorient";
    NSString *psgTwo = @"Paris Saint-Germain";
    NSString *psgThree = @"SC Bastia";
    NSString *psgFour = @"Parma";
    NSString *psgAnswer = @"Paris Saint-Germain";
    NSArray *psgArray = [[NSArray alloc] initWithObjects:psgCrest, psgOne, psgTwo, psgThree, psgFour, psgAnswer, nil];
    
    //Real Madrid
    UIImage *madridCrest = [UIImage imageNamed:@"RealMadrid.png"]; 
    NSString *madridOne = @"Malaga";
    NSString *madridTwo = @"Real Murcia";
    NSString *madridThree = @"Real Madrid";
    NSString *madridFour = @"Mallorca";
    NSString *madridAnswer = @"Real Madrid";
    NSArray *madridArray = [[NSArray alloc] initWithObjects:madridCrest, madridOne, madridTwo, madridThree, madridFour, madridAnswer, nil];
    
    //Roma
    UIImage *romaCrest = [UIImage imageNamed:@"Roma.png"]; 
    NSString *romaOne = @"Galatasaray";
    NSString *romaTwo = @"Sparta Prague";
    NSString *romaThree = @"Atalanta";
    NSString *romaFour = @"Roma";
    NSString *romaAnswer = @"Roma";
    NSArray *romaArray = [[NSArray alloc] initWithObjects:romaCrest, romaOne, romaTwo, romaThree, romaFour, romaAnswer, nil];
    
    //Schalke 04
    UIImage *schalkeCrest = [UIImage imageNamed:@"Schalke04.png"]; 
    NSString *schalkeOne = @"Schalke 04";
    NSString *schalkeTwo = @"Sporting Gijon";
    NSString *schalkeThree = @"Stuttgart";
    NSString *schalkeFour = @"Groningen";
    NSString *schalkeAnswer = @"Schalke 04";
    NSArray *schalkeArray = [[NSArray alloc] initWithObjects:schalkeCrest, schalkeOne, schalkeTwo, schalkeThree, schalkeFour, schalkeAnswer, nil];
    
    //Tottenham
    UIImage *tottenCrest = [UIImage imageNamed:@"Tottenham.png"]; 
    NSString *tottenOne = @"Swansea City";
    NSString *tottenTwo = @"Tottenham";
    NSString *tottenThree = @"Feyenoord";
    NSString *tottenFour = @"Bordeaux";
    NSString *tottenAnswer = @"Tottenham";
    NSArray *tottenArray = [[NSArray alloc] initWithObjects:tottenCrest, tottenOne, tottenTwo, tottenThree, tottenFour, tottenAnswer, nil];
    
    
    levelOne = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelOne addObject:milanArray];
    [levelOne addObject:arsenalArray];
    [levelOne addObject:atletiArray];
    [levelOne addObject:barcaArray];
    [levelOne addObject:bayernArray];
    [levelOne addObject:dortArray];
    [levelOne addObject:chelseaArray];
    [levelOne addObject:interArray];
    [levelOne addObject:juveArray];
    [levelOne addObject:liverArray];
    [levelOne addObject:lyonArray];
    [levelOne addObject:mancityArray];
    [levelOne addObject:manutdArray];
    [levelOne addObject:psgArray];
    [levelOne addObject:madridArray];
    [levelOne addObject:romaArray];
    [levelOne addObject:schalkeArray];
    [levelOne addObject:tottenArray];
    
    
    ////////      LEVEL 2       /////////
    
    //Ajax
    UIImage *ajaxCrest = [UIImage imageNamed:@"Ajax.png"]; 
    NSString *ajaxOne = @"Utrecht";
    NSString *ajaxTwo = @"Heracles";
    NSString *ajaxThree = @"Ajax";
    NSString *ajaxFour = @"Vitesse";
    NSString *ajaxAnswer = @"Ajax";
    NSArray *ajaxArray = [[NSArray alloc] initWithObjects:ajaxCrest, ajaxOne, ajaxTwo, ajaxThree, ajaxFour, ajaxAnswer, nil];
    
    //Athletic Bilbao
    UIImage *bilbaoCrest = [UIImage imageNamed:@"AthleticBilbao.png"]; 
    NSString *bilbaoOne = @"Madrid";
    NSString *bilbaoTwo = @"Stoke City";
    NSString *bilbaoThree = @"Sunderland";
    NSString *bilbaoFour = @"Bilbao";
    NSString *bilbaoAnswer = @"Bilbao";
    NSArray *bilbaoArray = [[NSArray alloc] initWithObjects:bilbaoCrest, bilbaoOne, bilbaoTwo, bilbaoThree, bilbaoFour, bilbaoAnswer, nil];
    
    //Benfica
    UIImage *benficaCrest = [UIImage imageNamed:@"Benfica.png"]; 
    NSString *benficaOne = @"Benfica";
    NSString *benficaTwo = @"Sporting Lisbon";
    NSString *benficaThree = @"SC Bastia";
    NSString *benficaFour = @"Vasco da Gama";
    NSString *benficaAnswer = @"Benfica";
    NSArray *benficaArray = [[NSArray alloc] initWithObjects:benficaCrest, benficaOne, benficaTwo, benficaThree, benficaFour, benficaAnswer, nil];
    
    //Boca Juniors
    UIImage *bocaCrest = [UIImage imageNamed:@"BocaJuniors.png"]; 
    NSString *bocaOne = @"Botafogo";
    NSString *bocaTwo = @"Boca Juniors";
    NSString *bocaThree = @"Quilmes";
    NSString *bocaFour = @"Cruz Azul";
    NSString *bocaAnswer = @"Boca Juniors";
    NSArray *bocaArray = [[NSArray alloc] initWithObjects:bocaCrest, bocaOne, bocaTwo, bocaThree, bocaFour, bocaAnswer, nil];
    
    //Celtic
    UIImage *celticCrest = [UIImage imageNamed:@"Celtic.png"]; 
    NSString *celticOne = @"Panathinaikos";
    NSString *celticTwo = @"Rangers";
    NSString *celticThree = @"Celtic";
    NSString *celticFour = @"Willem II";
    NSString *celticAnswer = @"Celtic";
    NSArray *celticArray = [[NSArray alloc] initWithObjects:celticCrest, celticOne, celticTwo, celticThree, celticFour, celticAnswer, nil];
    
    //Everton
    UIImage *evertonCrest = [UIImage imageNamed:@"Everton.png"]; 
    NSString *evertonOne = @"Cardiff City";
    NSString *evertonTwo = @"Porto";
    NSString *evertonThree = @"Queens Park Rangers";
    NSString *evertonFour = @"Everton";
    NSString *evertonAnswer = @"Everton";
    NSArray *evertonArray = [[NSArray alloc] initWithObjects:evertonCrest, evertonOne, evertonTwo, evertonThree, evertonFour, evertonAnswer, nil];
    
    //Fulham
    UIImage *fulhamCrest = [UIImage imageNamed:@"Fulham.png"]; 
    NSString *fulhamOne = @"Fulham";
    NSString *fulhamTwo = @"Feyenoord";
    NSString *fulhamThree = @"Freiburg";
    NSString *fulhamFour = @"Fluminese";
    NSString *fulhamAnswer = @"Fulham";
    NSArray *fulhamArray = [[NSArray alloc] initWithObjects:fulhamCrest, fulhamOne, fulhamTwo, fulhamThree, fulhamFour, fulhamAnswer, nil];
    
    //LA Galaxy
    UIImage *galaxyCrest = [UIImage imageNamed:@"LAGalaxy.png"]; 
    NSString *galaxyOne = @"Dynamo";
    NSString *galaxyTwo = @"Galaxy";
    NSString *galaxyThree = @"Sounders";
    NSString *galaxyFour = @"Rapids";
    NSString *galaxyAnswer = @"Galaxy";
    NSArray *galaxyArray = [[NSArray alloc] initWithObjects:galaxyCrest, galaxyOne, galaxyTwo, galaxyThree, galaxyFour, galaxyAnswer, nil];
    
    //Marseille
    UIImage *marseilleCrest = [UIImage imageNamed:@"Marseille.png"]; 
    NSString *marseilleOne = @"Montpellier";
    NSString *marseilleTwo = @"Mainz 05";
    NSString *marseilleThree = @"Marseille";
    NSString *marseilleFour = @"Mallorca";
    NSString *marseilleAnswer = @"Marseille";
    NSArray *marseilleArray = [[NSArray alloc] initWithObjects:marseilleCrest, marseilleOne, marseilleTwo, marseilleThree, marseilleFour, marseilleAnswer, nil];
    
    //Napoli
    UIImage *napoliCrest = [UIImage imageNamed:@"Napoli.png"]; 
    NSString *napoliOne = @"OGC Nice";
    NSString *napoliTwo = @"Nuremberg";
    NSString *napoliThree = @"CD Nacional";
    NSString *napoliFour = @"Napoli";
    NSString *napoliAnswer = @"Napoli";
    NSArray *napoliArray = [[NSArray alloc] initWithObjects:napoliCrest, napoliOne, napoliTwo, napoliThree, napoliFour, napoliAnswer, nil];
    
    //Newcastle
    UIImage *castleCrest = [UIImage imageNamed:@"Newcastle.png"]; 
    NSString *castleOne = @"Newcastle";
    NSString *castleTwo = @"Udinese";
    NSString *castleThree = @"Steaua Bucharest";
    NSString *castleFour = @"Siena";
    NSString *castleAnswer = @"Newcastle";
    NSArray *castleArray = [[NSArray alloc] initWithObjects:castleCrest, castleOne, castleTwo, castleThree, castleFour, castleAnswer, nil];
    
    //Porto
    UIImage *portoCrest = [UIImage imageNamed:@"Porto.png"]; 
    NSString *portoOne = @"Parma";
    NSString *portoTwo = @"Porto";
    NSString *portoThree = @"Atl. Paranaense";
    NSString *portoFour = @"Palmeiras";
    NSString *portoAnswer = @"Porto";
    NSArray *portoArray = [[NSArray alloc] initWithObjects:portoCrest, portoOne, portoTwo, portoThree, portoFour, portoAnswer, nil];
    
    //River Plate
    UIImage *riverCrest = [UIImage imageNamed:@"RiverPlate.png"]; 
    NSString *riverOne = @"Estudiantes La Plata";
    NSString *riverTwo = @"Deportivo Cali";
    NSString *riverThree = @"River Plate";
    NSString *riverFour = @"Rayo Vallecano";
    NSString *riverAnswer = @"River Plate";
    NSArray *riverArray = [[NSArray alloc] initWithObjects:riverCrest, riverOne, riverTwo, riverThree, riverFour, riverAnswer, nil];
    
    //Santos
    UIImage *santosCrest = [UIImage imageNamed:@"Santos.png"]; 
    NSString *santosOne = @"Saprissa";
    NSString *santosTwo = @"Sporting Braga";
    NSString *santosThree = @"Sao Paulo";
    NSString *santosFour = @"Santos";
    NSString *santosAnswer = @"Santos";
    NSArray *santosArray = [[NSArray alloc] initWithObjects:santosCrest, santosOne, santosTwo, santosThree, santosFour, santosAnswer, nil];
    
    //Sevilla
    UIImage *sevillaCrest = [UIImage imageNamed:@"Sevilla.png"]; 
    NSString *sevillaOne = @"Sevilla";
    NSString *sevillaTwo = @"Sporting Gijon";
    NSString *sevillaThree = @"Almeria";
    NSString *sevillaFour = @"Stade Brestois";
    NSString *sevillaAnswer = @"Sevilla";
    NSArray *sevillaArray = [[NSArray alloc] initWithObjects:sevillaCrest, sevillaOne, sevillaTwo, sevillaThree, sevillaFour, sevillaAnswer, nil];
    
    //Stuttgart
    UIImage *stuttCrest = [UIImage imageNamed:@"Stuttgart.png"]; 
    NSString *stuttOne = @"Augsburg";
    NSString *stuttTwo = @"Stuttgart";
    NSString *stuttThree = @"AC Ajaccio";
    NSString *stuttFour = @"Valenciennes FC";
    NSString *stuttAnswer = @"Stuttgart";
    NSArray *stuttArray = [[NSArray alloc] initWithObjects:stuttCrest, stuttOne, stuttTwo, stuttThree, stuttFour, stuttAnswer, nil];
    
    //Valencia
    UIImage *valenCrest = [UIImage imageNamed:@"Valencia.png"]; 
    NSString *valenOne = @"Espanyol";
    NSString *valenTwo = @"Valladolid";
    NSString *valenThree = @"Valencia";
    NSString *valenFour = @"Cagliari";
    NSString *valenAnswer = @"Valencia";
    NSArray *valenArray = [[NSArray alloc] initWithObjects:valenCrest, valenOne, valenTwo, valenThree, valenFour, valenAnswer, nil];
    
    //West Ham
    UIImage *hamCrest = [UIImage imageNamed:@"WestHam.png"]; 
    NSString *hamOne = @"Aston Villa";
    NSString *hamTwo = @"Newcastle";
    NSString *hamThree = @"AS Saint-Etienne";
    NSString *hamFour = @"West Ham";
    NSString *hamAnswer = @"West Ham";
    NSArray *hamArray = [[NSArray alloc] initWithObjects:hamCrest, hamOne, hamTwo, hamThree, hamFour, hamAnswer, nil];
    
    
    levelTwo = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelTwo addObject:ajaxArray];
    [levelTwo addObject:bilbaoArray];
    [levelTwo addObject:benficaArray];
    [levelTwo addObject:bocaArray];
    [levelTwo addObject:celticArray];
    [levelTwo addObject:evertonArray];
    [levelTwo addObject:fulhamArray];
    [levelTwo addObject:galaxyArray];
    [levelTwo addObject:marseilleArray];
    [levelTwo addObject:napoliArray];
    [levelTwo addObject:castleArray];
    [levelTwo addObject:portoArray];
    [levelTwo addObject:riverArray];
    [levelTwo addObject:santosArray];
    [levelTwo addObject:sevillaArray];
    [levelTwo addObject:stuttArray];
    [levelTwo addObject:valenArray];
    [levelTwo addObject:hamArray];
    
    
    ////////      LEVEL 3       /////////
    
    //Aston Villa
    UIImage *villaCrest = [UIImage imageNamed:@"AstonVilla.png"]; 
    NSString *villaOne = @"Aston Villa";
    NSString *villaTwo = @"West Ham";
    NSString *villaThree = @"Atalanta";
    NSString *villaFour = @"Augsburg";
    NSString *villaAnswer = @"Aston Villa";
    NSArray *villaArray = [[NSArray alloc] initWithObjects:villaCrest, villaOne, villaTwo, villaThree, villaFour, villaAnswer, nil];
    
    //AZ Alkmaar
    UIImage *azCrest = [UIImage imageNamed:@"AZAlkmaar.png"]; 
    NSString *azOne = @"Ajax";
    NSString *azTwo = @"Alkmaar";
    NSString *azThree = @"Utrecht";
    NSString *azFour = @"Heracles";
    NSString *azAnswer = @"Alkmaar";
    NSArray *azArray = [[NSArray alloc] initWithObjects:azCrest, azOne, azTwo, azThree, azFour, azAnswer, nil];
    
    //BayerLeverkusen
    UIImage *leverCrest = [UIImage imageNamed:@"BayerLeverkusen.png"]; 
    NSString *leverOne = @"Dortmund";
    NSString *leverTwo = @"Munich";
    NSString *leverThree = @"Leverkusen";
    NSString *leverFour = @"Freiburg";
    NSString *leverAnswer = @"Leverkusen";
    NSArray *leverArray = [[NSArray alloc] initWithObjects:leverCrest,leverOne, leverTwo, leverThree, leverFour, leverAnswer, nil];
    
    //Corinthians
    UIImage *corinCrest = [UIImage imageNamed:@"Corinthians.png"]; 
    NSString *corinOne = @"Moreirense";
    NSString *corinTwo = @"Cruzeiro";
    NSString *corinThree = @"Gremio";
    NSString *corinFour = @"Corinthians";
    NSString *corinAnswer = @"Corinthians";
    NSArray *corinArray = [[NSArray alloc] initWithObjects:corinCrest, corinOne, corinTwo, corinThree, corinFour, corinAnswer, nil];
    
    //Espanyol
    UIImage *espanyolCrest = [UIImage imageNamed:@"Espanyol.png"]; 
    NSString *espanyolOne = @"Espanyol";
    NSString *espanyolTwo = @"Racing";
    NSString *espanyolThree = @"Zaragoza";
    NSString *espanyolFour = @"Getafe";
    NSString *espanyolAnswer = @"Espanyol";
    NSArray *espanyolArray = [[NSArray alloc] initWithObjects:espanyolCrest, espanyolOne, espanyolTwo, espanyolThree, espanyolFour, espanyolAnswer, nil];
    
    //Fiorentina
    UIImage *fioreCrest = [UIImage imageNamed:@"Fiorentina.png"]; 
    NSString *fioreOne = @"FC Lorient";
    NSString *fioreTwo = @"Fiorentina";
    NSString *fioreThree = @"AS Nancy Lorraine";
    NSString *fioreFour = @"Frankfurt";
    NSString *fioreAnswer = @"Fiorentina";
    NSArray *fioreArray = [[NSArray alloc] initWithObjects:fioreCrest, fioreOne, fioreTwo, fioreThree, fioreFour,fioreAnswer, nil];
    
    //Hamburg
    UIImage *hamburgCrest = [UIImage imageNamed:@"Hamburg.png"]; 
    NSString *hamburgOne = @"ADO Den Haag";
    NSString *hamburgTwo = @"Auxerre";
    NSString *hamburgThree = @"Hamburg";
    NSString *hamburgFour = @"Hertha Berlin";
    NSString *hamburgAnswer = @"Hamburg";
    NSArray *hamburgArray = [[NSArray alloc] initWithObjects:hamburgCrest, hamburgOne, hamburgTwo, hamburgThree, hamburgFour, hamburgAnswer, nil];
    
    //Internacional
    UIImage *interpaCrest = [UIImage imageNamed:@"Internacional.png"]; 
    NSString *interpaOne = @"Stuttgart";
    NSString *interpaTwo = @"Eintracht Frankfurt";
    NSString *interpaThree = @"San Lorenzo";
    NSString *interpaFour = @"Internacional";
    NSString *interpaAnswer = @"Internacional";
    NSArray *interpaArray = [[NSArray alloc] initWithObjects:interpaCrest, interpaOne, interpaTwo, interpaThree, interpaFour,interpaAnswer, nil];
    
    //Malaga
    UIImage *malagaCrest = [UIImage imageNamed:@"Malaga.png"]; 
    NSString *malagaOne = @"Malaga";
    NSString *malagaTwo = @"Deportiva La Coruna";
    NSString *malagaThree = @"Celta de Vigo";
    NSString *malagaFour = @"Genoa";
    NSString *malagaAnswer = @"Malaga";
    NSArray *malagaArray = [[NSArray alloc] initWithObjects:malagaCrest, malagaOne, malagaTwo, malagaThree, malagaFour, malagaAnswer, nil];
    
    //NY Bulls
    UIImage *nyCrest = [UIImage imageNamed:@"NYBulls.png"]; 
    NSString *nyOne = @"Los Angeles";
    NSString *nyTwo = @"New York";
    NSString *nyThree = @"Colorado";
    NSString *nyFour = @"Dallas";
    NSString *nyAnswer = @"New York";
    NSArray *nyArray = [[NSArray alloc] initWithObjects:nyCrest, nyOne, nyTwo, nyThree, nyFour, nyAnswer, nil];
    
    //Olympiakos
    UIImage *olympCrest = [UIImage imageNamed:@"Olympiakos.png"]; 
    NSString *olympOne = @"AEK Athens";
    NSString *olympTwo = @"Panathinaikos";
    NSString *olympThree = @"Olympiakos";
    NSString *olympFour = @"Levadiakos";
    NSString *olympAnswer = @"Olympiakos";
    NSArray *olympArray = [[NSArray alloc] initWithObjects:olympCrest, olympOne, olympTwo, olympThree, olympFour, olympAnswer, nil];
    
    //PSV Eindhoven
    UIImage *psvCrest = [UIImage imageNamed:@"PSV.png"]; 
    NSString *psvOne = @"Fluminese";
    NSString *psvTwo = @"Independiente";
    NSString *psvThree = @"FC Twente";
    NSString *psvFour = @"PSV Eindhoven";
    NSString *psvAnswer = @"PSV Eindhoven";
    NSArray *psvArray = [[NSArray alloc] initWithObjects:psvCrest, psvOne, psvTwo, psvThree, psvFour, psvAnswer, nil];
    
    //Sao Paulo
    UIImage *saoCrest = [UIImage imageNamed:@"SaoPaulo.png"]; 
    NSString *saoOne = @"Sao Paulo";
    NSString *saoTwo = @"Zenit St. Petersburg";
    NSString *saoThree = @"Peñarol";
    NSString *saoFour = @"Sparta Prague";
    NSString *saoAnswer = @"Sao Paulo";
    NSArray *saoArray = [[NSArray alloc] initWithObjects:saoCrest, saoOne, saoTwo, saoThree, saoFour, saoAnswer, nil];
    
    //Stoke City
    UIImage *stokeCrest = [UIImage imageNamed:@"StokeCity.png"]; 
    NSString *stokeOne = @"Hull";
    NSString *stokeTwo = @"Stoke";
    NSString *stokeThree = @"Bristol";
    NSString *stokeFour = @"Cardiff";
    NSString *stokeAnswer = @"Stoke";
    NSArray *stokeArray = [[NSArray alloc] initWithObjects:stokeCrest, stokeOne, stokeTwo, stokeThree, stokeFour, stokeAnswer, nil];
    
    //Sunderland
    UIImage *sunderCrest = [UIImage imageNamed:@"Sunderland.png"]; 
    NSString *sunderOne = @"Stoke City";
    NSString *sunderTwo = @"Sporting Gijon";
    NSString *sunderThree = @"Sunderland";
    NSString *sunderFour = @"ESTAC Troyes";
    NSString *sunderAnswer = @"Sunderland";
    NSArray *sunderArray = [[NSArray alloc] initWithObjects:sunderCrest, sunderOne, sunderTwo, sunderThree, sunderFour, sunderAnswer, nil];
    
    //West Bromwich Albion
    UIImage *wbaCrest = [UIImage imageNamed:@"WBA.png"]; 
    NSString *wbaOne = @"Middlesbrough";
    NSString *wbaTwo = @"Blackburn";
    NSString *wbaThree = @"Norwich City";
    NSString *wbaFour = @"West Bromwich";
    NSString *wbaAnswer = @"West Bromwich";
    NSArray *wbaArray = [[NSArray alloc] initWithObjects:wbaCrest, wbaOne, wbaTwo, wbaThree, wbaFour, wbaAnswer, nil];
    
    //Werder Bremen
    UIImage *werderCrest = [UIImage imageNamed:@"WerderBremen.png"]; 
    NSString *werderOne = @"Werder Bremen";
    NSString *werderTwo = @"Wolfsburg";
    NSString *werderThree = @"Willem II";
    NSString *werderFour = @"Wigan Athletic";
    NSString *werderAnswer = @"Werder Bremen";
    NSArray *werderArray = [[NSArray alloc] initWithObjects:werderCrest, werderOne, werderTwo, werderThree, werderFour, werderAnswer, nil];
    
    //Wigan Athletic
    UIImage *wiganCrest = [UIImage imageNamed:@"Wigan.png"]; 
    NSString *wiganOne = @"Birmingham";
    NSString *wiganTwo = @"Wigan";
    NSString *wiganThree = @"Rangers";
    NSString *wiganFour = @"Southampton";
    NSString *wiganAnswer = @"Wigan";
    NSArray *wiganArray = [[NSArray alloc] initWithObjects:wiganCrest, wiganOne, wiganTwo, wiganThree, wiganFour, wiganAnswer, nil];
    
    
    
    levelThree = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelThree addObject:villaArray];
    [levelThree addObject:azArray];
    [levelThree addObject:leverArray];
    [levelThree addObject:corinArray];
    [levelThree addObject:espanyolArray];
    [levelThree addObject:fioreArray];
    [levelThree addObject:hamburgArray];
    [levelThree addObject:interpaArray];
    [levelThree addObject:malagaArray];
    [levelThree addObject:nyArray];
    [levelThree addObject:olympArray];
    [levelThree addObject:psvArray];
    [levelThree addObject:saoArray];
    [levelThree addObject:stokeArray];
    [levelThree addObject:sunderArray];
    [levelThree addObject:wbaArray];
    [levelThree addObject:werderArray];
    [levelThree addObject:wiganArray];
    
    
    ////////      LEVEL 4       /////////
   
    
    //Real Betis
    UIImage *betisCrest = [UIImage imageNamed:@"Betis.png"]; 
    NSString *betisOne = @"Basel";
    NSString *betisTwo = @"NAC Breda";
    NSString *betisThree = @"Real Betis";
    NSString *betisFour = @"Werder Bremen";
    NSString *betisAnswer = @"Real Betis";
    NSArray *betisArray = [[NSArray alloc] initWithObjects:betisCrest, betisOne, betisTwo, betisThree, betisFour, betisAnswer, nil];
    
    //CSKA Moscow
    UIImage *cskaCrest = [UIImage imageNamed:@"CSKAMoscow.png"]; 
    NSString *cskaOne = @"Anzhi Makhachkala";
    NSString *cskaTwo = @"Dynamo Kiev";
    NSString *cskaThree = @"Rubin Kazan";
    NSString *cskaFour = @"CSKA Moscow";
    NSString *cskaAnswer = @"CSKA Moscow";
    NSArray *cskaArray = [[NSArray alloc] initWithObjects:cskaCrest,cskaOne, cskaTwo, cskaThree, cskaFour, cskaAnswer, nil];
    
    //Feyenoord
    UIImage *feyerCrest = [UIImage imageNamed:@"Feyenoord.png"]; 
    NSString *feyerOne = @"Feyenoord";
    NSString *feyerTwo = @"Fiorentina";
    NSString *feyerThree = @"Fenerbahce";
    NSString *feyerFour = @"Furth";
    NSString *feyerAnswer = @"Feyenoord";
    NSArray *feyerArray = [[NSArray alloc] initWithObjects:feyerCrest, feyerOne, feyerTwo, feyerThree, feyerFour, feyerAnswer, nil];
    
    //Flamengo
    UIImage *flamCrest = [UIImage imageNamed:@"Flamengo.png"]; 
    NSString *flamOne = @"Eintracht Frankfurt";
    NSString *flamTwo = @"Flamengo";
    NSString *flamThree = @"Racing Club";
    NSString *flamFour = @"Fluminese";
    NSString *flamAnswer = @"Flamengo";
    NSArray *flamArray = [[NSArray alloc] initWithObjects:flamCrest, flamOne, flamTwo, flamThree, flamFour, flamAnswer, nil];
    
    //Galatasaray
    UIImage *galatCrest = [UIImage imageNamed:@"Galatasaray.png"]; 
    NSString *galatOne = @"Gremio";
    NSString *galatTwo = @"Siena";
    NSString *galatThree = @"Galatasaray";
    NSString *galatFour = @"Sporting Gijon";
    NSString *galatAnswer = @"Galatasaray";
    NSArray *galatArray = [[NSArray alloc] initWithObjects:galatCrest, galatOne, galatTwo, galatThree, galatFour, galatAnswer, nil];
    
    //Getafe
    UIImage *getafeCrest = [UIImage imageNamed:@"Getafe.png"]; 
    NSString *getafeOne = @"Granada";
    NSString *getafeTwo = @"Catania";
    NSString *getafeThree = @"Anderlecht";
    NSString *getafeFour = @"Getafe";
    NSString *getafeAnswer = @"Getafe";
    NSArray *getafeArray = [[NSArray alloc] initWithObjects:getafeCrest, getafeOne, getafeTwo, getafeThree, getafeFour, getafeAnswer, nil];
    
    
    //Levante
    UIImage *levanCrest = [UIImage imageNamed:@"Levante.png"]; 
    NSString *levanOne = @"Levante";
    NSString *levanTwo = @"San Lorenzo";
    NSString *levanThree = @"Lanus";
    NSString *levanFour = @"Valencia";
    NSString *levanAnswer = @"Levante";
    NSArray *levanArray = [[NSArray alloc] initWithObjects:levanCrest, levanOne, levanTwo, levanThree, levanFour, levanAnswer, nil];
    
    
    //Mallorca
    UIImage *malloCrest = [UIImage imageNamed:@"Mallorca.png"]; 
    NSString *malloOne = @"Valenciennes FC";
    NSString *malloTwo = @"Mallorca";
    NSString *malloThree = @"Dusseldorf";
    NSString *malloFour = @"Club Brugge";
    NSString *malloAnswer = @"Mallorca";
    NSArray *malloArray = [[NSArray alloc] initWithObjects:malloCrest, malloOne, malloTwo, malloThree, malloFour, malloAnswer, nil];
    
    
    //Norwich City
    UIImage *norwCrest = [UIImage imageNamed:@"Norwich.png"]; 
    NSString *norwOne = @"Copenhaguen FC";
    NSString *norwTwo = @"Nottingham Forest";
    NSString *norwThree = @"Norwich City";
    NSString *norwFour = @"Barnsely";
    NSString *norwAnswer = @"Norwich City";
    NSArray *norwArray = [[NSArray alloc] initWithObjects:norwCrest, norwOne, norwTwo, norwThree, norwFour, norwAnswer, nil];
    
    
    //QPR
    UIImage *qprCrest = [UIImage imageNamed:@"QPR.png"]; 
    NSString *qprOne = @"Burnley";
    NSString *qprTwo = @"Derby County FC";
    NSString *qprThree = @"Crystal Palace";
    NSString *qprFour = @"Queens Park Rangers";
    NSString *qprAnswer = @"Queens Park Rangers";
    NSArray *qprArray = [[NSArray alloc] initWithObjects:qprCrest, qprOne, qprTwo, qprThree, qprFour, qprAnswer, nil];
    
    
    //Real Sociedad
    UIImage *socieCrest = [UIImage imageNamed:@"RealSociedad.png"]; 
    NSString *socieOne = @"Real Sociedad";
    NSString *socieTwo = @"Stade Rennais";
    NSString *socieThree = @"Recreativo Huelva";
    NSString *socieFour = @"AEK Athens";
    NSString *socieAnswer = @"Real Sociedad";
    NSArray *socieArray = [[NSArray alloc] initWithObjects:socieCrest, socieOne, socieTwo, socieThree, socieFour, socieAnswer, nil];
    
    
    //Siena
    UIImage *sienaCrest = [UIImage imageNamed:@"siena.png"];
    NSString *sienaOne = @"Udinese";
    NSString *sienaTwo = @"Siena";
    NSString *sienaThree = @"Newcastle";
    NSString *sienaFour = @"Vasco da Gama";
    NSString *sienaAnswer = @"Siena";
    NSArray *sienaArray = [[NSArray alloc] initWithObjects:sienaCrest, sienaOne, sienaTwo, sienaThree, sienaFour, sienaAnswer, nil];
    
    
    //Sporting Lisbon
    UIImage *lisbonCrest = [UIImage imageNamed:@"Sporting.png"]; 
    NSString *lisbonOne = @"Moreirense";
    NSString *lisbonTwo = @"CS Maritimo";
    NSString *lisbonThree = @"Sporting Lisbon";
    NSString *lisbonFour = @"CD Nacional";
    NSString *lisbonAnswer = @"Sporting Lisbon";
    NSArray *lisbonArray = [[NSArray alloc] initWithObjects:lisbonCrest, lisbonOne, lisbonTwo, lisbonThree, lisbonFour, lisbonAnswer, nil];
    
    
    //Swansea City
    UIImage *swanCrest = [UIImage imageNamed:@"Swansea.png"]; 
    NSString *swanOne = @"AC Ajaccio";
    NSString *swanTwo = @"CS Maritimo";
    NSString *swanThree = @"Brescia";
    NSString *swanFour = @"Swansea City";
    NSString *swanAnswer = @"Swansea City";
    NSArray *swanArray = [[NSArray alloc] initWithObjects:swanCrest, swanOne, swanTwo, swanThree, swanFour, swanAnswer, nil];
    
    
    //Twente
    UIImage *twentCrest = [UIImage imageNamed:@"Twente.png"]; 
    NSString *twentOne = @"FC Twente";
    NSString *twentTwo = @"Sochaux-Montbeliard";
    NSString *twentThree = @"FC Lorient";
    NSString *twentFour = @"FC Utrecht";
    NSString *twentAnswer = @"FC Twente";
    NSArray *twentArray = [[NSArray alloc] initWithObjects:twentCrest, twentOne, twentTwo, twentThree, twentFour, twentAnswer, nil];
    
    
    //Udinese
    UIImage *udineCrest = [UIImage imageNamed:@"Udinese.png"]; 
    NSString *udineOne = @"Vitesse";
    NSString *udineTwo = @"Udinese";
    NSString *udineThree = @"Palermo";
    NSString *udineFour = @"Cesena";
    NSString *udineAnswer = @"Udinese";
    NSArray *udineArray = [[NSArray alloc] initWithObjects:udineCrest, udineOne, udineTwo, udineThree, udineFour, udineAnswer, nil];
    
    
    //Velez Sarfield
    UIImage *velezCrest = [UIImage imageNamed:@"VelezSarfield.png"]; 
    NSString *velezOne = @"Ulsan Hyundai";
    NSString *velezTwo = @"Alajuelense";
    NSString *velezThree = @"Velez Sarfield";
    NSString *velezFour = @"Universidad Catolica";
    NSString *velezAnswer = @"Velez Sarfield";
    NSArray *velezArray = [[NSArray alloc] initWithObjects:velezCrest, velezOne, velezTwo, velezThree, velezFour, velezAnswer, nil];
    
    
    //Villarreal
    UIImage *villarCrest = [UIImage imageNamed:@"Villarreal.png"]; 
    NSString *villarOne = @"Celta de Vigo";
    NSString *villarTwo = @"Rayo Vallecano";
    NSString *villarThree = @"Valladolid";
    NSString *villarFour = @"Villarreal";
    NSString *villarAnswer = @"Villarreal";
    NSArray *villarArray = [[NSArray alloc] initWithObjects:villarCrest, villarOne, villarTwo, villarThree, villarFour, villarAnswer, nil];
    
    
    
   
    levelFour = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelFour addObject:betisArray];
    [levelFour addObject:cskaArray];
    [levelFour addObject:feyerArray];
    [levelFour addObject:flamArray];
    [levelFour addObject:galatArray];
    [levelFour addObject:getafeArray];
    [levelFour addObject:levanArray];
    [levelFour addObject:malloArray];
    [levelFour addObject:norwArray];
    [levelFour addObject:qprArray];
    [levelFour addObject:socieArray];
    [levelFour addObject:sienaArray];
    [levelFour addObject:lisbonArray];
    [levelFour addObject:swanArray];
    [levelFour addObject:twentArray];
    [levelFour addObject:udineArray];
    [levelFour addObject:velezArray];
    [levelFour addObject:villarArray];
    
    
    ////////      LEVEL 5       /////////
    
    //Atalanta
    UIImage *atalaCrest = [UIImage imageNamed:@"Atalanta.png"]; 
    NSString *atalaOne = @"Atalanta";
    NSString *atalaTwo = @"Reggina";
    NSString *atalaThree = @"FC Cologne";
    NSString *atalaFour = @"Evian TG FC";
    NSString *atalaAnswer = @"Atalanta";
    NSArray *atalaArray = [[NSArray alloc] initWithObjects:atalaCrest, atalaOne, atalaTwo, atalaThree, atalaFour, atalaAnswer, nil];
    
    //Celta de Vigo
    UIImage *vigoCrest = [UIImage imageNamed:@"CeltaDeVigo.png"]; 
    NSString *vigoOne = @"Murcia";
    NSString *vigoTwo = @"Celta de Vigo";
    NSString *vigoThree = @"Xerez";
    NSString *vigoFour = @"ESTAC Troyes";
    NSString *vigoAnswer = @"Celta de Vigo";
    NSArray *vigoArray = [[NSArray alloc] initWithObjects:vigoCrest, vigoOne, vigoTwo, vigoThree, vigoFour, vigoAnswer, nil];
    
    //Deportivo La Coruna
    UIImage *deporCrest = [UIImage imageNamed:@"DepLaCoruna.png"]; 
    NSString *deporOne = @"Real Zaragoza";
    NSString *deporTwo = @"Anderlecht";
    NSString *deporThree = @"Deportivo La Coruña";
    NSString *deporFour = @"Sporting Braga";
    NSString *deporAnswer = @"Deportivo La Coruña";
    NSArray *deporArray = [[NSArray alloc] initWithObjects:deporCrest, deporOne, deporTwo, deporThree, deporFour, deporAnswer, nil];
    
    //Estudiantes La Plata
    UIImage *plataCrest = [UIImage imageNamed:@"EstudiantesLaPlata.png"]; 
    NSString *plataOne = @"Internacional";
    NSString *plataTwo = @"Deportivo Cali";
    NSString *plataThree = @"Independiente";
    NSString *plataFour = @"Estudiantes La Plata";
    NSString *plataAnswer = @"Estudiantes La Plata";
    NSArray *plataArray = [[NSArray alloc] initWithObjects:plataCrest, plataOne, plataTwo, plataThree, plataFour, plataAnswer, nil];
    
    //Fenerbahce
    UIImage *fenerCrest = [UIImage imageNamed:@"Fenerbahce.png"]; 
    NSString *fenerOne = @"Fenerbahce";
    NSString *fenerTwo = @"Basel";
    NSString *fenerThree = @"Shakhtar";
    NSString *fenerFour = @"Copenhaguen";
    NSString *fenerAnswer = @"Fenerbahce";
    NSArray *fenerArray = [[NSArray alloc] initWithObjects:fenerCrest, fenerOne, fenerTwo, fenerThree, fenerFour, fenerAnswer, nil];
    
    //Fluminese
    UIImage *flumiCrest = [UIImage imageNamed:@"Fluminese.png"]; 
    NSString *flumiOne = @"Flamengo";
    NSString *flumiTwo = @"Fluminese";
    NSString *flumiThree = @"Gremio";
    NSString *flumiFour = @"Rio Ave";
    NSString *flumiAnswer = @"Fluminese";
    NSArray *flumiArray = [[NSArray alloc] initWithObjects:flumiCrest, flumiOne, flumiTwo, flumiThree, flumiFour, flumiAnswer, nil];
    
    //Frankfurt
    UIImage *frankCrest = [UIImage imageNamed:@"Frankfurt.png"]; 
    NSString *frankOne = @"PSV Eindhoven";
    NSString *frankTwo = @"Estoril Praia";
    NSString *frankThree = @"Eintracht Frankfurt";
    NSString *frankFour = @"Evian TG FC";
    NSString *frankAnswer = @"Eintracht Frankfurt";
    NSArray *frankArray = [[NSArray alloc] initWithObjects:frankCrest, frankOne, frankTwo, frankThree, frankFour, frankAnswer, nil];
    
    //Hannover 96
    UIImage *hannoCrest = [UIImage imageNamed:@"Hannover96.png"]; 
    NSString *hannoOne = @"Augsburg";
    NSString *hannoTwo = @"Hamburg";
    NSString *hannoThree = @"Mainz";
    NSString *hannoFour = @"Hannover";
    NSString *hannoAnswer = @"Hannover";
    NSArray *hannoArray = [[NSArray alloc] initWithObjects:hannoCrest, hannoOne, hannoTwo, hannoThree, hannoFour, hannoAnswer, nil];
    
    //Houston Dynamo
    UIImage *houCrest = [UIImage imageNamed:@"HoustonDynamo.png"]; 
    NSString *houOne = @"Houston";
    NSString *houTwo = @"Columbus";
    NSString *houThree = @"Seattle";
    NSString *houFour = @"Colorado";
    NSString *houAnswer = @"Houston";
    NSArray *houArray = [[NSArray alloc] initWithObjects:houCrest, houOne, houTwo, houThree, houFour, houAnswer, nil];
    
    //Lazio
    UIImage *lazCrest = [UIImage imageNamed:@"Lazio.png"]; 
    NSString *lazOne = @"Brescia";
    NSString *lazTwo = @"Lazio";
    NSString *lazThree = @"Torino";
    NSString *lazFour = @"Parma";
    NSString *lazAnswer = @"Lazio";
    NSArray *lazArray = [[NSArray alloc] initWithObjects:lazCrest, lazOne, lazTwo, lazThree, lazFour, lazAnswer, nil];
    
    //Osasuna
    UIImage *osaCrest = [UIImage imageNamed:@"Osasuna.png"]; 
    NSString *osaOne = @"Cagliari";
    NSString *osaTwo = @"Catania";
    NSString *osaThree = @"Osasuna";
    NSString *osaFour = @"Cesena";
    NSString *osaAnswer = @"Osasuna";
    NSArray *osaArray = [[NSArray alloc] initWithObjects:osaCrest, osaOne, osaTwo, osaThree, osaFour, osaAnswer, nil];
    
    //Parma
    UIImage *parmaCrest = [UIImage imageNamed:@"Parma.png"]; 
    NSString *parmaOne = @"Leicester City";
    NSString *parmaTwo = @"Leeds United";
    NSString *parmaThree = @"Dynamo Kiev";
    NSString *parmaFour = @"Parma";
    NSString *parmaAnswer = @"Parma";
    NSArray *parmaArray = [[NSArray alloc] initWithObjects:parmaCrest, parmaOne, parmaTwo, parmaThree, parmaFour, parmaAnswer, nil];
    
    //Reading
    UIImage *readCrest = [UIImage imageNamed:@"Reading.png"]; 
    NSString *readOne = @"Reading";
    NSString *readTwo = @"Southampton";
    NSString *readThree = @"Watford";
    NSString *readFour = @"Blackpool";
    NSString *readAnswer = @"Reading";
    NSArray *readArray = [[NSArray alloc] initWithObjects:readCrest, readOne, readTwo, readThree, readFour, readAnswer, nil];
    
    //San Lorenzo
    UIImage *lorenCrest = [UIImage imageNamed:@"SanLorenzo.png"]; 
    NSString *lorenOne = @"Cruzeiro";
    NSString *lorenTwo = @"San Lorenzo";
    NSString *lorenThree = @"Lanus";
    NSString *lorenFour = @"Racing Club";
    NSString *lorenAnswer = @"San Lorenzo";
    NSArray *lorenArray = [[NSArray alloc] initWithObjects:lorenCrest, lorenOne, lorenTwo, lorenThree, lorenFour, lorenAnswer, nil];
    
    //Southampton
    UIImage *southCrest = [UIImage imageNamed:@"Southampton.png"]; 
    NSString *southOne = @"Vitesse";
    NSString *southTwo = @"Millwall";
    NSString *southThree = @"Southampton";
    NSString *southFour = @"Valenciennes";
    NSString *southAnswer = @"Southampton";
    NSArray *southArray = [[NSArray alloc] initWithObjects:southCrest, southOne, southTwo, southThree, southFour, southAnswer, nil];
    
    //Valladolid
    UIImage *vallaCrest = [UIImage imageNamed:@"Valladolid.png"]; 
    NSString *vallaOne = @"Deportivo la Coruña";
    NSString *vallaTwo = @"Reacreativo Huelva";
    NSString *vallaThree = @"Celta de Vigo";
    NSString *vallaFour = @"Valladolid";
    NSString *vallaAnswer = @"Valladolid";
    NSArray *vallaArray = [[NSArray alloc] initWithObjects:vallaCrest, vallaOne, vallaTwo, vallaThree, vallaFour, vallaAnswer, nil];
    
    //Zaragoza
    UIImage *zaraCrest = [UIImage imageNamed:@"Zaragoza.png"]; 
    NSString *zaraOne = @"Zaragoza";
    NSString *zaraTwo = @"Wolfsburg";
    NSString *zaraThree = @"Mochengladbach";
    NSString *zaraFour = @"Nuremberg";
    NSString *zaraAnswer = @"Zaragoza";
    NSArray *zaraArray = [[NSArray alloc] initWithObjects:zaraCrest, zaraOne, zaraTwo, zaraThree, zaraFour, zaraAnswer, nil];
    
    //Zenit
    UIImage *zenitCrest = [UIImage imageNamed:@"Zenit.png"]; 
    NSString *zenitOne = @"Rubin Kazan";
    NSString *zenitTwo = @"Zenit St Petersburg";
    NSString *zenitThree = @"Dinamo Zagreb";
    NSString *zenitFour = @"Shakhtar Donetsk";
    NSString *zenitAnswer = @"Zenit St Petersburg";
    NSArray *zenitArray = [[NSArray alloc] initWithObjects:zenitCrest, zenitOne, zenitTwo, zenitThree, zenitFour, zenitAnswer, nil];

    
    
    levelFive = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelFive addObject:atalaArray];
    [levelFive addObject:vigoArray];
    [levelFive addObject:deporArray];
    [levelFive addObject:plataArray];
    [levelFive addObject:fenerArray];
    [levelFive addObject:flumiArray];
    [levelFive addObject:frankArray];
    [levelFive addObject:hannoArray];
    [levelFive addObject:houArray];
    [levelFive addObject:lazArray];
    [levelFive addObject:osaArray];
    [levelFive addObject:parmaArray];
    [levelFive addObject:readArray];
    [levelFive addObject:lorenArray];
    [levelFive addObject:southArray];
    [levelFive addObject:vallaArray];
    [levelFive addObject:zaraArray];
    [levelFive addObject:zenitArray];
    
    
    ////////      LEVEL 6       /////////
    
    //AEK Athens
    UIImage *aekCrest = [UIImage imageNamed:@"AEKAthens.png"]; 
    NSString *aekOne = @"Heracles";
    NSString *aekTwo = @"NAC Breda";
    NSString *aekThree = @"AEK Athens";
    NSString *aekFour = @"Dusseldorf";
    NSString *aekAnswer = @"AEK Athens";
    NSArray *aekArray = [[NSArray alloc] initWithObjects:aekCrest, aekOne, aekTwo, aekThree, aekFour, aekAnswer, nil];
    
    //Al Ahly
    UIImage *ahlyCrest = [UIImage imageNamed:@"AlAhly.png"]; 
    NSString *ahlyOne = @"Auckland City";
    NSString *ahlyTwo = @"APOEL";
    NSString *ahlyThree = @"Groningen";
    NSString *ahlyFour = @"Al Ahly";
    NSString *ahlyAnswer = @"Al Ahly";
    NSArray *ahlyArray = [[NSArray alloc] initWithObjects:ahlyCrest, ahlyOne, ahlyTwo, ahlyThree, ahlyFour, ahlyAnswer, nil];
    
    //Anderlecht
    UIImage *anderCrest = [UIImage imageNamed:@"Anderlecht.png"]; 
    NSString *anderOne = @"Anderlecht";
    NSString *anderTwo = @"Steaua Bucharest";
    NSString *anderThree = @"Willem II";
    NSString *anderFour = @"Hertha Berlin";
    NSString *anderAnswer = @"Anderlecht";
    NSArray *anderArray = [[NSArray alloc] initWithObjects:anderCrest, anderOne, anderTwo, anderThree, anderFour, anderAnswer, nil];
    
    //Atletico Mineiro
    UIImage *mineiCrest = [UIImage imageNamed:@"AtleticoMineiro.png"]; 
    NSString *mineiOne = @"Santos";
    NSString *mineiTwo = @"Atletico Mineiro";
    NSString *mineiThree = @"Botafogo";
    NSString *mineiFour = @"Peñarol";
    NSString *mineiAnswer = @"Atletico Mineiro";
    NSArray *mineiArray = [[NSArray alloc] initWithObjects:mineiCrest, mineiOne, mineiTwo, mineiThree, mineiFour, mineiAnswer, nil];
    
    //Blackburn
    UIImage *blackCrest = [UIImage imageNamed:@"Blackburn.png"]; 
    NSString *blackOne = @"AC Ajaccio";
    NSString *blackTwo = @"Ipswich Town";
    NSString *blackThree = @"Blackburn";
    NSString *blackFour = @"AS Saint-Etienne";
    NSString *blackAnswer = @"Blackburn";
    NSArray *blackArray = [[NSArray alloc] initWithObjects:blackCrest, blackOne, blackTwo, blackThree, blackFour, blackAnswer, nil];
    
    //Bordeaux
    UIImage *bordCrest = [UIImage imageNamed:@"Bordeaux.png"]; 
    NSString *bordOne = @"Vitesse";
    NSString *bordTwo = @"Toulouse FC";
    NSString *bordThree = @"Velez Sarfield";
    NSString *bordFour = @"Bordeaux";
    NSString *bordAnswer = @"Bordeaux";
    NSArray *bordArray = [[NSArray alloc] initWithObjects:bordCrest, bordOne, bordTwo, bordThree, bordFour, bordAnswer, nil];
    
    //Catania
    UIImage *cataCrest = [UIImage imageNamed:@"Catania.png"]; 
    NSString *cataOne = @"Catania";
    NSString *cataTwo = @"Saprissa";
    NSString *cataThree = @"Livorno";
    NSString *cataFour = @"Murcia";
    NSString *cataAnswer = @"Catania";
    NSArray *cataArray = [[NSArray alloc] initWithObjects:cataCrest, cataOne, cataTwo, cataThree, cataFour, cataAnswer, nil];
    
    //Chievo
    UIImage *chievoCrest = [UIImage imageNamed:@"Chievo.png"]; 
    NSString *chievoOne = @"BSC Young Boys";
    NSString *chievoTwo = @"Chievo Verona";
    NSString *chievoThree = @"Leeds United";
    NSString *chievoFour = @"Derby County";
    NSString *chievoAnswer = @"Chievo Verona";
    NSArray *chievoArray = [[NSArray alloc] initWithObjects:chievoCrest, chievoOne, chievoTwo, chievoThree, chievoFour, chievoAnswer, nil];
    
    //Independiente
    UIImage *indeCrest = [UIImage imageNamed:@"Independiente.png"]; 
    NSString *indeOne = @"Millonarios";
    NSString *indeTwo = @"Deportivo Cali";
    NSString *indeThree = @"Independiente";
    NSString *indeFour = @"River Plate";
    NSString *indeAnswer = @"Independiente";
    NSArray *indeArray = [[NSArray alloc] initWithObjects:indeCrest, indeOne, indeTwo, indeThree, indeFour, indeAnswer, nil];
    
    //LOSC Lille
    UIImage *lilleCrest = [UIImage imageNamed:@"LOSCLille.png"]; 
    NSString *lilleOne = @"Nice";
    NSString *lilleTwo = @"Troyes";
    NSString *lilleThree = @"Lyonnais";
    NSString *lilleFour = @"Lille";
    NSString *lilleAnswer = @"Lille";
    NSArray *lilleArray = [[NSArray alloc] initWithObjects:lilleCrest, lilleOne, lilleTwo, lilleThree, lilleFour, lilleAnswer, nil];
    
    //Monaco
    UIImage *monaCrest = [UIImage imageNamed:@"Monaco.png"]; 
    NSString *monaOne = @"AS Monaco";
    NSString *monaTwo = @"Almeria";
    NSString *monaThree = @"Sporting Gijon";
    NSString *monaFour = @"Ajax";
    NSString *monaAnswer = @"AS Monaco";
    NSArray *monaArray = [[NSArray alloc] initWithObjects:monaCrest, monaOne, monaTwo, monaThree, monaFour, monaAnswer, nil];
    
    //Montpelllier
    UIImage *montpCrest = [UIImage imageNamed:@"Montpellier.png"]; 
    NSString *montpOne = @"Dynamo Kiev";
    NSString *montpTwo = @"Montpellier";
    NSString *montpThree = @"Stade Rennais";
    NSString *montpFour = @"Auxerre";
    NSString *montpAnswer = @"Montpellier";
    NSArray *montpArray = [[NSArray alloc] initWithObjects:montpCrest, montpOne, montpTwo, montpThree, montpFour, montpAnswer, nil];
    
    //Palermo
    UIImage *palerCrest = [UIImage imageNamed:@"Palermo.png"]; 
    NSString *palerOne = @"Brescia";
    NSString *palerTwo = @"Sampdoria";
    NSString *palerThree = @"Palermo";
    NSString *palerFour = @"Juventus";
    NSString *palerAnswer = @"Palermo";
    NSArray *palerArray = [[NSArray alloc] initWithObjects:palerCrest, palerOne, palerTwo, palerThree, palerFour, palerAnswer, nil];
    
    //Panathinaikos
    UIImage *panaCrest = [UIImage imageNamed:@"Panathinaikos.png"]; 
    NSString *panaOne = @"Basel";
    NSString *panaTwo = @"Gil Vicente FC";
    NSString *panaThree = @"Rangers FC";
    NSString *panaFour = @"Panathinaikos";
    NSString *panaAnswer = @"Panathinaikos";
    NSArray *panaArray = [[NSArray alloc] initWithObjects:panaCrest, panaOne, panaTwo, panaThree, panaFour, panaAnswer, nil];
    
    //Rangers
    UIImage *rangCrest = [UIImage imageNamed:@"Rangers.png"]; 
    NSString *rangOne = @"Rangers";
    NSString *rangTwo = @"Reading";
    NSString *rangThree = @"Fulham";
    NSString *rangFour = @"Cardiff City";
    NSString *rangAnswer = @"Rangers";
    NSArray *rangArray = [[NSArray alloc] initWithObjects:rangCrest, rangOne, rangTwo, rangThree, rangFour, rangAnswer, nil];
    
    //Shakhtar Donetsk
    UIImage *shakCrest = [UIImage imageNamed:@"Shakhtar.png"]; 
    NSString *shakOne = @"Sparta Prague";
    NSString *shakTwo = @"Shakhtar Donetsk";
    NSString *shakThree = @"Dinamo Zagreb";
    NSString *shakFour = @"CSKA Moscow";
    NSString *shakAnswer = @"Shakhtar Donetsk";
    NSArray *shakArray = [[NSArray alloc] initWithObjects:shakCrest, shakOne, shakTwo, shakThree, shakFour, shakAnswer, nil];
    
    //Torino
    UIImage *torCrest = [UIImage imageNamed:@"Torino.png"]; 
    NSString *torOne = @"Atalanta";
    NSString *torTwo = @"Freiburg";
    NSString *torThree = @"Torino";
    NSString *torFour = @"Willem II";
    NSString *torAnswer = @"Torino";
    NSArray *torArray = [[NSArray alloc] initWithObjects:torCrest, torOne, torTwo, torThree, torFour, torAnswer, nil];
    
    //Wolverhampton
    UIImage *wolveCrest = [UIImage imageNamed:@"Wolverhampton.png"]; 
    NSString *wolveOne = @"Wolfsburg";
    NSString *wolveTwo = @"Kaiserlautern";
    NSString *wolveThree = @"CA Tigre";
    NSString *wolveFour = @"Wolverhampton";
    NSString *wolveAnswer = @"Wolverhampton";
    NSArray *wolveArray = [[NSArray alloc] initWithObjects:wolveCrest, wolveOne, wolveTwo, wolveThree, wolveFour, wolveAnswer, nil];
    
    
    levelSix = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelSix addObject:aekArray];
    [levelSix addObject:ahlyArray];
    [levelSix addObject:anderArray];
    [levelSix addObject:mineiArray];
    [levelSix addObject:blackArray];
    [levelSix addObject:bordArray];
    [levelSix addObject:cataArray];
    [levelSix addObject:chievoArray];
    [levelSix addObject:indeArray];
    [levelSix addObject:lilleArray];
    [levelSix addObject:monaArray];
    [levelSix addObject:montpArray];
    [levelSix addObject:palerArray];
    [levelSix addObject:panaArray];
    [levelSix addObject:rangArray];
    [levelSix addObject:shakArray];
    [levelSix addObject:torArray];
    [levelSix addObject:wolveArray];
    
    
    ////////      LEVEL 7       /////////
    
    //Anzhi Makhachkala
    UIImage *anzCrest = [UIImage imageNamed:@"AnzhiMakhachkala.png"];
    NSString *anzOne = @"Anzhi Makhachkala";
    NSString *anzTwo = @"Fenerbahce";
    NSString *anzThree = @"AEK Athens";
    NSString *anzFour = @"Groningen";
    NSString *anzAnswer = @"Anzhi Makhachkala";
    NSArray *anzArray = [[NSArray alloc] initWithObjects:anzCrest, anzOne, anzTwo, anzThree, anzFour, anzAnswer, nil];
    
    //Auxerre
    UIImage *auxCrest = [UIImage imageNamed:@"Auxerre.png"];
    NSString *auxOne = @"Heracles";
    NSString *auxTwo = @"Auxerre";
    NSString *auxThree = @"Torino";
    NSString *auxFour = @"SC Bastia";
    NSString *auxAnswer = @"Auxerre";
    NSArray *auxArray = [[NSArray alloc] initWithObjects:auxCrest, auxOne, auxTwo, auxThree, auxFour, auxAnswer, nil];
    
    //Colo Colo
    UIImage *coloCrest = [UIImage imageNamed:@"ColoColo.png"];
    NSString *coloOne = @"Alajulense";
    NSString *coloTwo = @"Cerro Porteño";
    NSString *coloThree = @"Colo Colo";
    NSString *coloFour = @"TP Mazembe";
    NSString *coloAnswer = @"Colo Colo";
    NSArray *coloArray = [[NSArray alloc] initWithObjects:coloCrest, coloOne, coloTwo, coloThree, coloFour, coloAnswer, nil];
    
    //Cruzeiro
    UIImage *cruCrest = [UIImage imageNamed:@"Cruzeiro.png"];
    NSString *cruOne = @"Gremio";
    NSString *cruTwo = @"Maritimo";
    NSString *cruThree = @"Gil Vicente";
    NSString *cruFour = @"Cruzeiro";
    NSString *cruAnswer = @"Cruzeiro";
    NSArray *cruArray = [[NSArray alloc] initWithObjects:cruCrest, cruOne, cruTwo, cruThree, cruFour, cruAnswer, nil];
    
    //DynamoKiev
    UIImage *kievCrest = [UIImage imageNamed:@"DynamoKiev.png"];
    NSString *kievOne = @"Dynamo Kiev";
    NSString *kievTwo = @"Derby County";
    NSString *kievThree = @"Deportivo La Coruña";
    NSString *kievFour = @"Dusseldorf";
    NSString *kievAnswer = @"Dynamo Kiev";
    NSArray *kievArray = [[NSArray alloc] initWithObjects:kievCrest, kievOne, kievTwo, kievThree, kievFour, kievAnswer, nil];
    
    //FC Basel
    UIImage *baseCrest = [UIImage imageNamed:@"FCBasel.png"];
    NSString *baseOne = @"Fenerbahce";
    NSString *baseTwo = @"FC Basel";
    NSString *baseThree = @"Bologna";
    NSString *baseFour = @"Steaua Bucharest";
    NSString *baseAnswer = @"FC Basel";
    NSArray *baseArray = [[NSArray alloc] initWithObjects:baseCrest, baseOne, baseTwo, baseThree, baseFour, baseAnswer, nil];
    
    //Genoa
    UIImage *genoCrest = [UIImage imageNamed:@"Genoa.png"];
    NSString *genoOne = @"FC Lorient";
    NSString *genoTwo = @"Heracles";
    NSString *genoThree = @"Genoa";
    NSString *genoFour = @"AS Saint-Etienne";
    NSString *genoAnswer = @"Genoa";
    NSArray *genoArray = [[NSArray alloc] initWithObjects:genoCrest, genoOne, genoTwo, genoThree, genoFour, genoAnswer, nil];
    
    //Lorient
    UIImage *lorCrest = [UIImage imageNamed:@"Lorient.png"];
    NSString *lorOne = @"Rio Ave FC";
    NSString *lorTwo = @"Montpellier";
    NSString *lorThree = @"Shakhtar Donetsk";
    NSString *lorFour = @"FC Lorient";
    NSString *lorAnswer = @"FC Lorient";
    NSArray *lorArray = [[NSArray alloc] initWithObjects:lorCrest, lorOne, lorTwo, lorThree, lorFour, lorAnswer, nil];
    
    //Mainz 05
    UIImage *mainzCrest = [UIImage imageNamed:@"Mainz05.png"];
    NSString *mainzOne = @"Mainz 05";
    NSString *mainzTwo = @"Millonarios";
    NSString *mainzThree = @"Maccabi Tel Aviv";
    NSString *mainzFour = @"CF Monterrey";
    NSString *mainzAnswer = @"Mainz 05";
    NSArray *mainzArray = [[NSArray alloc] initWithObjects:mainzCrest, mainzOne, mainzTwo, mainzThree, mainzFour, mainzAnswer, nil];
    
    //Mochengladbach
    UIImage *mochCrest = [UIImage imageNamed:@"Mochengladbach.png"];
    NSString *mochOne = @"Botafogo";
    NSString *mochTwo = @"Mochengladbach";
    NSString *mochThree = @"Bristol City";
    NSString *mochFour = @"Brescia";
    NSString *mochAnswer = @"Mochengladbach";
    NSArray *mochArray = [[NSArray alloc] initWithObjects:mochCrest, mochOne, mochTwo, mochThree, mochFour, mochAnswer, nil];
    
    //Monterrey
    UIImage *monCrest = [UIImage imageNamed:@"Monterrey.png"];
    NSString *monOne = @"Montpellier";
    NSString *monTwo = @"Morereinse";
    NSString *monThree = @"CF Monterrey";
    NSString *monFour = @"Millonarios";
    NSString *monAnswer = @"CF Monterrey";
    NSArray *monArray = [[NSArray alloc] initWithObjects:monCrest, monOne, monTwo, monThree, monFour, monAnswer, nil];
    
    //Nacional
    UIImage *naciCrest = [UIImage imageNamed:@"Nacional.png"];
    NSString *naciOne = @"Recreativo Huelva";
    NSString *naciTwo = @"San Lorenzo";
    NSString *naciThree = @"Velez Sarfield";
    NSString *naciFour = @"Nacional";
    NSString *naciAnswer = @"Nacional";
    NSArray *naciArray = [[NSArray alloc] initWithObjects:naciCrest, naciOne, naciTwo, naciThree, naciFour, naciAnswer, nil];
    
    //Nuremberg
    UIImage *nurCrest = [UIImage imageNamed:@"Nuremberg.png"];
    NSString *nurOne = @"Nuremberg";
    NSString *nurTwo = @"NAC Breda";
    NSString *nurThree = @"Nacional";
    NSString *nurFour = @"Newell's";
    NSString *nurAnswer = @"Nuremberg";
    NSArray *nurArray = [[NSArray alloc] initWithObjects:nurCrest, nurOne, nurTwo, nurThree, nurFour, nurAnswer, nil];
    
    //Rubin Kazan
    UIImage *rubinCrest = [UIImage imageNamed:@"RubinKazan.png"];
    NSString *rubinOne = @"Auckland City";
    NSString *rubinTwo = @"Rubin Kazan";
    NSString *rubinThree = @"Huddersfield";
    NSString *rubinFour = @"Al Ahly";
    NSString *rubinAnswer = @"Rubin Kazan";
    NSArray *rubinArray = [[NSArray alloc] initWithObjects:rubinCrest, rubinOne, rubinTwo, rubinThree, rubinFour, rubinAnswer, nil];
    
    //Sampdoria
    UIImage *sampCrest = [UIImage imageNamed:@"Sampdoria.png"];
    NSString *sampOne = @"FC Sochaux-Montbeliard";
    NSString *sampTwo = @"Augsburg";
    NSString *sampThree = @"Sampdoria";
    NSString *sampFour = @"Evian TG FC";
    NSString *sampAnswer = @"Sampdoria";
    NSArray *sampArray = [[NSArray alloc] initWithObjects:sampCrest, sampOne, sampTwo, sampThree, sampFour, sampAnswer, nil];
    
    //Seattle Sounders
    UIImage *seatCrest = [UIImage imageNamed:@"SeattleSounders.png"];
    NSString *seatOne = @"Vancouver Whitecaps";
    NSString *seatTwo = @"San Jose Earthquakes";
    NSString *seatThree = @"Toronto FC";
    NSString *seatFour = @"Seattle Sounders";
    NSString *seatAnswer = @"Seattle Sounders";
    NSArray *seatArray = [[NSArray alloc] initWithObjects:seatCrest, seatOne, seatTwo, seatThree, seatFour, seatAnswer, nil];
    
    //Sparta Prague
    UIImage *spartCrest = [UIImage imageNamed:@"SpartaPrague.png"];
    NSString *spartOne = @"Sparta Prague";
    NSString *spartTwo = @"Stade Brestois";
    NSString *spartThree = @"Sporting Lisbon";
    NSString *spartFour = @"Steaua Bucharest";
    NSString *spartAnswer = @"Sparta Prague";
    NSArray *spartArray = [[NSArray alloc] initWithObjects:spartCrest, spartOne, spartTwo, spartThree, spartFour, spartAnswer, nil];
    
    //Wolfsburg
    UIImage *wolfCrest = [UIImage imageNamed:@"Wolfsburg.png"];
    NSString *wolfOne = @"Watford";
    NSString *wolfTwo = @"Wolfsburg";
    NSString *wolfThree = @"Werder Bremen";
    NSString *wolfFour = @"Wolverhampton";
    NSString *wolfAnswer = @"Wolfsburg";
    NSArray *wolfArray = [[NSArray alloc] initWithObjects:wolfCrest, wolfOne, wolfTwo, wolfThree, wolfFour, wolfAnswer, nil];
    
    levelSeven = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelSeven addObject:anzArray];
    [levelSeven addObject:auxArray];
    [levelSeven addObject:coloArray];
    [levelSeven addObject:cruArray];
    [levelSeven addObject:kievArray];
    [levelSeven addObject:baseArray];
    [levelSeven addObject:genoArray];
    [levelSeven addObject:lorArray];
    [levelSeven addObject:mainzArray];
    [levelSeven addObject:mochArray];
    [levelSeven addObject:monArray];
    [levelSeven addObject:naciArray];
    [levelSeven addObject:nurArray];
    [levelSeven addObject:rubinArray];
    [levelSeven addObject:sampArray];
    [levelSeven addObject:seatArray];
    [levelSeven addObject:spartArray];
    [levelSeven addObject:wolfArray];
    
    
    ////////      LEVEL 8       /////////
    
    //America 
    UIImage *ameriCrest = [UIImage imageNamed:@"America.png"];
    NSString *ameriOne = @"Once Caldas";
    NSString *ameriTwo = @"Universidad de Chile";
    NSString *ameriThree = @"America";
    NSString *ameriFour = @"Alajulense";
    NSString *ameriAnswer = @"America";
    NSArray *ameriArray = [[NSArray alloc] initWithObjects:ameriCrest, ameriOne, ameriTwo, ameriThree, ameriFour, ameriAnswer, nil];
    
    //Birmingham City
    UIImage *birmCrest = [UIImage imageNamed:@"BirminghamCity.png"];
    NSString *birmOne = @"Bolton Wanderers";
    NSString *birmTwo = @"Blackburn";
    NSString *birmThree = @"Ipswich Town";
    NSString *birmFour = @"Birmingham City";
    NSString *birmAnswer = @"Birmingham City";
    NSArray *birmArray = [[NSArray alloc] initWithObjects:birmCrest, birmOne, birmTwo, birmThree, birmFour, birmAnswer, nil];
    
    //Cagliari
    UIImage *cagliCrest = [UIImage imageNamed:@"Cagliari.png"];
    NSString *cagliOne = @"Cagliari";
    NSString *cagliTwo = @"Genoa";
    NSString *cagliThree = @"FC Basel";
    NSString *cagliFour = @"Livorno";
    NSString *cagliAnswer = @"Cagliari";
    NSArray *cagliArray = [[NSArray alloc] initWithObjects:cagliCrest, cagliOne, cagliTwo, cagliThree, cagliFour, cagliAnswer, nil];
    
    //Chicago Fire
    UIImage *chiCrest = [UIImage imageNamed:@"ChicagoFire.png"];
    NSString *chiOne = @"Crystal Palace";
    NSString *chiTwo = @"Chicago Fire";
    NSString *chiThree = @"Catania";
    NSString *chiFour = @"FC Cologne";
    NSString *chiAnswer = @"Chicago Fire";
    NSArray *chiArray = [[NSArray alloc] initWithObjects:chiCrest, chiOne, chiTwo, chiThree, chiFour, chiAnswer, nil];
    
    //Chivas
    UIImage *chivCrest = [UIImage imageNamed:@"Chivas.png"];
    NSString *chivOne = @"Hercules";
    NSString *chivTwo = @"Libertad";
    NSString *chivThree = @"Chivas";
    NSString *chivFour = @"Alianza Lima";
    NSString *chivAnswer = @"Chivas";
    NSArray *chivArray = [[NSArray alloc] initWithObjects:chivCrest, chivOne, chivTwo, chivThree, chivFour, chivAnswer, nil];
    
    //Deportivo Cali
    UIImage *caliCrest = [UIImage imageNamed:@"DeportivoCali.png"];
    NSString *caliOne = @"Beira Mar";
    NSString *caliTwo = @"Palmeiras";
    NSString *caliThree = @"Santa Fe";
    NSString *caliFour = @"Deportivo Cali";
    NSString *caliAnswer = @"Deportivo Cali";
    NSArray *caliArray = [[NSArray alloc] initWithObjects:caliCrest, caliOne, caliTwo, caliThree, caliFour, caliAnswer, nil];
    
    //Dinamo Zagreb
    UIImage *zagCrest = [UIImage imageNamed:@"DinamoZagreb.png"];
    NSString *zagOne = @"Dinamo Zagreb";
    NSString *zagTwo = @"Dynamo Kiev";
    NSString *zagThree = @"Dusseldorf";
    NSString *zagFour = @"DC United";
    NSString *zagAnswer = @"Dinamo Zagreb";
    NSArray *zagArray = [[NSArray alloc] initWithObjects:zagCrest, zagOne, zagTwo, zagThree, zagFour, zagAnswer, nil];
    
    //FC Dallas
    UIImage *dalCrest = [UIImage imageNamed:@"FCDallas.png"];
    NSString *dalOne = @"Millwall FC";
    NSString *dalTwo = @"FC Dallas";
    NSString *dalThree = @"Sporting Kansas City";
    NSString *dalFour = @"Rangers";
    NSString *dalAnswer = @"FC Dallas";
    NSArray *dalArray = [[NSArray alloc] initWithObjects:dalCrest, dalOne, dalTwo, dalThree, dalFour, dalAnswer, nil];
    
    //Kaiserlautern
    UIImage *kaisCrest = [UIImage imageNamed:@"Kaiserlautern.png"];
    NSString *kaisOne = @"Frankfurt";
    NSString *kaisTwo = @"AZ Alkmaar";
    NSString *kaisThree = @"Kaiserlautern";
    NSString *kaisFour = @"Dynamo Kiev";
    NSString *kaisAnswer = @"Kaiserlautern";
    NSArray *kaisArray = [[NSArray alloc] initWithObjects:kaisCrest, kaisOne, kaisTwo, kaisThree, kaisFour, kaisAnswer, nil];
    
    //Lanus
    UIImage *lanuCrest = [UIImage imageNamed:@"Lanus.png"];
    NSString *lanuOne = @"Flamengo";
    NSString *lanuTwo = @"Club Brugge";
    NSString *lanuThree = @"FC Copenhagen";
    NSString *lanuFour = @"Lanus";
    NSString *lanuAnswer = @"Lanus";
    NSArray *lanuArray = [[NSArray alloc] initWithObjects:lanuCrest, lanuOne, lanuTwo, lanuThree, lanuFour, lanuAnswer, nil];
    
    //Leeds United
    UIImage *leedCrest = [UIImage imageNamed:@"leeds.png"];
    NSString *leedOne = @"Leeds United";
    NSString *leedTwo = @"APOEL";
    NSString *leedThree = @"Derby County FC";
    NSString *leedFour = @"AC Ajaccio";
    NSString *leedAnswer = @"Leeds United";
    NSArray *leedArray = [[NSArray alloc] initWithObjects:leedCrest, leedOne, leedTwo, leedThree, leedFour, leedAnswer, nil];
    
    //NAC Breda
    UIImage *nacCrest = [UIImage imageNamed:@"NACBreda.gif"];
    NSString *nacOne = @"Cerro Porteño";
    NSString *nacTwo = @"NAC Breda";
    NSString *nacThree = @"AEK Athens";
    NSString *nacFour = @"Al Ahly";
    NSString *nacAnswer = @"NAC Breda";
    NSArray *nacArray = [[NSArray alloc] initWithObjects:nacCrest, nacOne, nacTwo, nacThree, nacFour, nacAnswer, nil];
    
    //Penarol
    UIImage *penaCrest = [UIImage imageNamed:@"Penarol.png"];
    NSString *penaOne = @"Quilmes";
    NSString *penaTwo = @"Nacional";
    NSString *penaThree = @"Peñarol";
    NSString *penaFour = @"BSC Young Boys";
    NSString *penaAnswer = @"Peñarol";
    NSArray *penaArray = [[NSArray alloc] initWithObjects:penaCrest, penaOne, penaTwo, penaThree, penaFour, penaAnswer, nil];
    
    //Rayo Vallecano
    UIImage *rayoCrest = [UIImage imageNamed:@"RayoVallecano.png"];
    NSString *rayoOne = @"River Plate";
    NSString *rayoTwo = @"Hospitalet";
    NSString *rayoThree = @"Xerez";
    NSString *rayoFour = @"Rayo Vallecano";
    NSString *rayoAnswer = @"Rayo Vallecano";
    NSArray *rayoArray = [[NSArray alloc] initWithObjects:rayoCrest, rayoOne, rayoTwo, rayoThree, rayoFour, rayoAnswer, nil];
    
    //Saint Etienne
    UIImage *etienCrest = [UIImage imageNamed:@"SaintEtienne.png"];
    NSString *etienOne = @"AS Saint-Etienne";
    NSString *etienTwo = @"Stade Rennais";
    NSString *etienThree = @"Vitesse";
    NSString *etienFour = @"Pescara";
    NSString *etienAnswer = @"AS Saint-Etienne";
    NSArray *etienArray = [[NSArray alloc] initWithObjects:etienCrest, etienOne, etienTwo, etienThree, etienFour, etienAnswer, nil];
    
    //Stade Rennais
    UIImage *rennCrest = [UIImage imageNamed:@"StadeRennais.png"];
    NSString *rennOne = @"Cagliari";
    NSString *rennTwo = @"Stade Rennais";
    NSString *rennThree = @"Freiburg";
    NSString *rennFour = @"Bologna";
    NSString *rennAnswer = @"Stade Rennais";
    NSArray *rennArray = [[NSArray alloc] initWithObjects:rennCrest, rennOne, rennTwo, rennThree, rennFour, rennAnswer, nil];
    
    //Steaua Bucharest
    UIImage *steauaCrest = [UIImage imageNamed:@"SteauaBucharest.png"];
    NSString *steauaOne = @"FC Basel";
    NSString *steauaTwo = @"Independiente Medellin";
    NSString *steauaThree = @"Steaua Bucharest";
    NSString *steauaFour = @"CSKA Moscow";
    NSString *steauaAnswer = @"Steaua Bucharest";
    NSArray *steauaArray = [[NSArray alloc] initWithObjects:steauaCrest, steauaOne, steauaTwo, steauaThree, steauaFour, steauaAnswer, nil];
    
    //Tigre
    UIImage *tigCrest = [UIImage imageNamed:@"Tigre.png"];
    NSString *tigOne = @"Tigres UANL";
    NSString *tigTwo = @"San Lorenzo";
    NSString *tigThree = @"FC Twente";
    NSString *tigFour = @"CA Tigre";
    NSString *tigAnswer = @"CA Tigre";
    NSArray *tigArray = [[NSArray alloc] initWithObjects:tigCrest, tigOne, tigTwo, tigThree, tigFour, tigAnswer, nil];
    
    levelEight = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelEight addObject:ameriArray];
    [levelEight addObject:birmArray];
    [levelEight addObject:cagliArray];
    [levelEight addObject:chiArray];
    [levelEight addObject:chivArray];
    [levelEight addObject:caliArray];
    [levelEight addObject:zagArray];
    [levelEight addObject:dalArray];
    [levelEight addObject:kaisArray];
    [levelEight addObject:lanuArray];
    [levelEight addObject:leedArray];
    [levelEight addObject:nacArray];
    [levelEight addObject:penaArray];
    [levelEight addObject:rayoArray];
    [levelEight addObject:etienArray];
    [levelEight addObject:rennArray];
    [levelEight addObject:steauaArray];
    [levelEight addObject:tigArray];
    
    
    ////////      LEVEL 9       /////////
    
    //Almeria
    UIImage *almCrest = [UIImage imageNamed:@"Almeria.png"];
    NSString *almOne = @"Almeria";
    NSString *almTwo = @"Sporting Gijon";
    NSString *almThree = @"Sporting Braga";
    NSString *almFour = @"SC Bastia";
    NSString *almAnswer = @"Almeria";
    NSArray *almArray = [[NSArray alloc] initWithObjects:almCrest, almOne, almTwo, almThree, almFour, almAnswer, nil];
    
    //APOEL
    UIImage *apoCrest = [UIImage imageNamed:@"APOEL.png"];
    NSString *apoOne = @"Kashiwa Reysol";
    NSString *apoTwo = @"APOEL";
    NSString *apoThree = @"Sparta Prague";
    NSString *apoFour = @"Alianza Lima";
    NSString *apoAnswer = @"APOEL";
    NSArray *apoArray = [[NSArray alloc] initWithObjects:apoCrest, apoOne, apoTwo, apoThree, apoFour, apoAnswer, nil];
    
    //Botafogo
    UIImage *botaCrest = [UIImage imageNamed:@"Botafogo.png"];
    NSString *botaOne = @"Brescia";
    NSString *botaTwo = @"Blackpool";
    NSString *botaThree = @"Botafogo";
    NSString *botaFour = @"Burnley";
    NSString *botaAnswer = @"Botafogo";
    NSArray *botaArray = [[NSArray alloc] initWithObjects:botaCrest, botaOne, botaTwo, botaThree, botaFour, botaAnswer, nil];
    
    //Charlton Athletic
    UIImage *charCrest = [UIImage imageNamed:@"CharltonAthletic.png"];
    NSString *charOne = @"Hercules";
    NSString *charTwo = @"Furth";
    NSString *charThree = @"Chievo Verona";
    NSString *charFour = @"Charlton Athletic";
    NSString *charAnswer = @"Charlton Athletic";
    NSArray *charArray = [[NSArray alloc] initWithObjects:charCrest, charOne, charTwo, charThree, charFour, charAnswer, nil];
    
    //Cruz Azul
    UIImage *cruzaCrest = [UIImage imageNamed:@"CruzAzul.png"];
    NSString *cruzaOne = @"Cruz Azul";
    NSString *cruzaTwo = @"America";
    NSString *cruzaThree = @"Atlante";
    NSString *cruzaFour = @"Chivas";
    NSString *cruzaAnswer = @"Cruz Azul";
    NSArray *cruzaArray = [[NSArray alloc] initWithObjects:cruzaCrest, cruzaOne, cruzaTwo, cruzaThree, cruzaFour, cruzaAnswer, nil];
    
    //Dusseldorf
    UIImage *dussCrest = [UIImage imageNamed:@"Dusseldorf.png"];
    NSString *dussOne = @"Frankfurt";
    NSString *dussTwo = @"Dusseldorf";
    NSString *dussThree = @"Fluminese";
    NSString *dussFour = @"Flamengo";
    NSString *dussAnswer = @"Dusseldorf";
    NSArray *dussArray = [[NSArray alloc] initWithObjects:dussCrest, dussOne, dussTwo, dussThree, dussFour, dussAnswer, nil];
    
    //Granada
    UIImage *granCrest = [UIImage imageNamed:@"Granada.png"];
    NSString *granOne = @"Heracles";
    NSString *granTwo = @"OGC Nice";
    NSString *granThree = @"Granada";
    NSString *granFour = @"Cadiz";
    NSString *granAnswer = @"Granada";
    NSArray *granArray = [[NSArray alloc] initWithObjects:granCrest, granOne, granTwo, granThree, granFour, granAnswer, nil];
 
    //Gremio
    UIImage *gremCrest = [UIImage imageNamed:@"Gremio.png"];
    NSString *gremOne = @"Cruzeiro";
    NSString *gremTwo = @"Leicester City";
    NSString *gremThree = @"Colorado Rapids";
    NSString *gremFour = @"Gremio";
    NSString *gremAnswer = @"Gremio";
    NSArray *gremArray = [[NSArray alloc] initWithObjects:gremCrest, gremOne, gremTwo, gremThree, gremFour, gremAnswer, nil];
    
    //Hoffenheim
    UIImage *hoffCrest = [UIImage imageNamed:@"Hoffenheim.png"];
    NSString *hoffOne = @"Hoffenheim";
    NSString *hoffTwo = @"Toulouse";
    NSString *hoffThree = @"Freiburg";
    NSString *hoffFour = @"Groningen";
    NSString *hoffAnswer = @"Hoffenheim";
    NSArray *hoffArray = [[NSArray alloc] initWithObjects:hoffCrest, hoffOne, hoffTwo, hoffThree, hoffFour, hoffAnswer, nil];
    
    //Independiente Medellin
    UIImage *indepCrest = [UIImage imageNamed:@"IndependienteMedellin.png"];
    NSString *indepOne = @"Deportivo La Coruña";
    NSString *indepTwo = @"Independiente Medellin";
    NSString *indepThree = @"Universidad de Chile";
    NSString *indepFour = @"Moreirense";
    NSString *indepAnswer = @"Independiente Medellin";
    NSArray *indepArray = [[NSArray alloc] initWithObjects:indepCrest, indepOne, indepTwo, indepThree, indepFour, indepAnswer, nil];
    
    //Middlesbrough
    UIImage *midCrest = [UIImage imageNamed:@"Middlesbrough.png"];
    NSString *midOne = @"Kaiserlautern";
    NSString *midTwo = @"Losc Lille";
    NSString *midThree = @"Middlesbrough";
    NSString *midFour = @"Sporting Braga";
    NSString *midAnswer = @"Middlesbrough";
    NSArray *midArray = [[NSArray alloc] initWithObjects:midCrest, midOne, midTwo, midThree, midFour, midAnswer, nil];
    
    //Newells
    UIImage *neweCrest = [UIImage imageNamed:@"Newells.png"];
    NSString *neweOne = @"Atlas";
    NSString *neweTwo = @"Hoffenheim";
    NSString *neweThree = @"Auckland City";
    NSString *neweFour = @"Newells Old Boys";
    NSString *neweAnswer = @"Newells Old Boys";
    NSArray *neweArray = [[NSArray alloc] initWithObjects:neweCrest, neweOne, neweTwo, neweThree, neweFour, neweAnswer, nil];
    
    //OnceCaldas
    UIImage *onceCrest = [UIImage imageNamed:@"OnceCaldas.png"];
    NSString *onceOne = @"Once Caldas";
    NSString *onceTwo = @"Cesena";
    NSString *onceThree = @"Catania";
    NSString *onceFour = @"Cagliari";
    NSString *onceAnswer = @"Once Caldas";
    NSArray *onceArray = [[NSArray alloc] initWithObjects:onceCrest, onceOne, onceTwo, onceThree, onceFour, onceAnswer, nil];
    
    //PohangSteelers
    UIImage *pohCrest = [UIImage imageNamed:@"PohangSteelers.png"];
    NSString *pohOne = @"Sporting Kansas City";
    NSString *pohTwo = @"Pohang Steelers";
    NSString *pohThree = @"Salt Lake City";
    NSString *pohFour = @"Sparta Prague";
    NSString *pohAnswer = @"Pohang Steelers";
    NSArray *pohArray = [[NSArray alloc] initWithObjects:pohCrest, pohOne, pohTwo, pohThree, pohFour, pohAnswer, nil];
    
    //SportingBraga
    UIImage *bragCrest = [UIImage imageNamed:@"SportingBraga.png"];
    NSString *bragOne = @"Monaco";
    NSString *bragTwo = @"Auxerre";
    NSString *bragThree = @"Sporting Braga";
    NSString *bragFour = @"Copenhagen";
    NSString *bragAnswer = @"Sporting Braga";
    NSArray *bragArray = [[NSArray alloc] initWithObjects:bragCrest, bragOne, bragTwo, bragThree, bragFour, bragAnswer, nil];
    
    //SportingGijon
    UIImage *gijCrest = [UIImage imageNamed:@"SportingGijon.png"];
    NSString *gijOne = @"Granada";
    NSString *gijTwo = @"Getafe";
    NSString *gijThree = @"Sevilla";
    NSString *gijFour = @"Sporting Gijon";
    NSString *gijAnswer = @"Sporting Gijon";
    NSArray *gijArray = [[NSArray alloc] initWithObjects:gijCrest, gijOne, gijTwo, gijThree, gijFour, gijAnswer, nil];
    
    //TigresUANL
    UIImage *uanlCrest = [UIImage imageNamed:@"TigresUANL.png"];
    NSString *uanlOne = @"Tigres UANL";
    NSString *uanlTwo = @"CA Tigre";
    NSString *uanlThree = @"Universidad de Chile";
    NSString *uanlFour = @"Universidad Catolica";
    NSString *uanlAnswer = @"Tigres UANL";
    NSArray *uanlArray = [[NSArray alloc] initWithObjects:uanlCrest, uanlOne, uanlTwo, uanlThree, uanlFour, uanlAnswer, nil];
    
    //Toulouse
    UIImage *touCrest = [UIImage imageNamed:@"Toulouse.png"];
    NSString *touOne = @"Tenerife";
    NSString *touTwo = @"Toulouse";
    NSString *touThree = @"FC Twente";
    NSString *touFour = @"Fiorentina";
    NSString *touAnswer = @"Toulouse";
    NSArray *touArray = [[NSArray alloc] initWithObjects:touCrest, touOne, touTwo, touThree, touFour, touAnswer, nil];
    
    
    levelNine = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelNine addObject:almArray];
    [levelNine addObject:apoArray];
    [levelNine addObject:botaArray];
    [levelNine addObject:charArray];
    [levelNine addObject:cruzaArray];
    [levelNine addObject:dussArray];
    [levelNine addObject:granArray];
    [levelNine addObject:gremArray];
    [levelNine addObject:hoffArray];
    [levelNine addObject:indepArray];
    [levelNine addObject:midArray];
    [levelNine addObject:neweArray];
    [levelNine addObject:onceArray];
    [levelNine addObject:pohArray];
    [levelNine addObject:bragArray];
    [levelNine addObject:gijArray];
    [levelNine addObject:uanlArray];
    [levelNine addObject:touArray];
    
    
    ////////      LEVEL 10       /////////
    
    //Ajaccio
    UIImage *ajaCrest = [UIImage imageNamed:@"Ajaccio.png"];
    NSString *ajaOne = @"Augsburg";
    NSString *ajaTwo = @"Alkmaar";
    NSString *ajaThree = @"Ajaccio";
    NSString *ajaFour = @"Atalanta";
    NSString *ajaAnswer = @"Ajaccio";
    NSArray *ajaArray = [[NSArray alloc] initWithObjects:ajaCrest, ajaOne, ajaTwo, ajaThree, ajaFour, ajaAnswer, nil];
    
    //Alianza Lima
    UIImage *limaCrest = [UIImage imageNamed:@"AlianzaLima.png"];
    NSString *limaOne = @"Alajulense";
    NSString *limaTwo = @"Cerro Porteño";
    NSString *limaThree = @"Recreativo Huelva";
    NSString *limaFour = @"Alianza Lima";
    NSString *limaAnswer = @"Alianza Lima";
    NSArray *limaArray = [[NSArray alloc] initWithObjects:limaCrest, limaOne, limaTwo, limaThree, limaFour, limaAnswer, nil];
    
    //BATE Borisov
    UIImage *bateCrest = [UIImage imageNamed:@"BATEBorisov.png"];
    NSString *bateOne = @"BATE Borisov";
    NSString *bateTwo = @"Fenerbahce";
    NSString *bateThree = @"Dinamo Zagreb";
    NSString *bateFour = @"Dynamo Kiev";
    NSString *bateAnswer = @"BATE Borisov";
    NSArray *bateArray = [[NSArray alloc] initWithObjects:bateCrest, bateOne, bateTwo, bateThree, bateFour, bateAnswer, nil];
    
    //Brescia
    UIImage *breCrest = [UIImage imageNamed:@"Brescia.png"];
    NSString *breOne = @"Sochaux-Montbeliard";
    NSString *breTwo = @"Brescia";
    NSString *breThree = @"Reggina";
    NSString *breFour = @"Sampdoria";
    NSString *breAnswer = @"Brescia";
    NSArray *breArray = [[NSArray alloc] initWithObjects:breCrest, breOne, breTwo, breThree, breFour, breAnswer, nil];
    
    //Cardiff City
    UIImage *cardCrest = [UIImage imageNamed:@"CardiffCity.png"];
    NSString *cardOne = @"Pohang Steelers";
    NSString *cardTwo = @"Ipswich Town";
    NSString *cardThree = @"Cardiff City";
    NSString *cardFour = @"Blackburn";
    NSString *cardAnswer = @"Cardiff City";
    NSArray *cardArray = [[NSArray alloc] initWithObjects:cardCrest, cardOne, cardTwo, cardThree, cardFour, cardAnswer, nil];
    
    //Cerro Porteno
    UIImage *cerroCrest = [UIImage imageNamed:@"CerroPorteno.png"];
    NSString *cerroOne = @"Deportivo Cali";
    NSString *cerroTwo = @"San Lorenzo";
    NSString *cerroThree = @"Universidad Catolica";
    NSString *cerroFour = @"Cerro Porteño";
    NSString *cerroAnswer = @"Cerro Porteño";
    NSArray *cerroArray = [[NSArray alloc] initWithObjects:cerroCrest, cerroOne, cerroTwo, cerroThree, cerroFour, cerroAnswer, nil];
    
    //Cesena
    UIImage *cesCrest = [UIImage imageNamed:@"Cesena.png"];
    NSString *cesOne = @"Cesena";
    NSString *cesTwo = @"Pescara";
    NSString *cesThree = @"Heracles";
    NSString *cesFour = @"Siena";
    NSString *cesAnswer = @"Cesena";
    NSArray *cesArray = [[NSArray alloc] initWithObjects:cesCrest, cesOne, cesTwo, cesThree, cesFour, cesAnswer, nil];
    
    //Club Libertad
    UIImage *libCrest = [UIImage imageNamed:@"ClubLibertad.png"];
    NSString *libOne = @"Vasco da Gama";
    NSString *libTwo = @"Libertad";
    NSString *libThree = @"Orlando Pirates";
    NSString *libFour = @"TP Mazembe";
    NSString *libAnswer = @"Libertad";
    NSArray *libArray = [[NSArray alloc] initWithObjects:libCrest, libOne, libTwo, libThree, libFour, libAnswer, nil];
 
    //Cologne
    UIImage *colCrest = [UIImage imageNamed:@"Cologne.png"];
    NSString *colOne = @"Utrecht";
    NSString *colTwo = @"Willem II";
    NSString *colThree = @"Cologne";
    NSString *colFour = @"Dusseldorf";
    NSString *colAnswer = @"Cologne";
    NSArray *colArray = [[NSArray alloc] initWithObjects:colCrest, colOne, colTwo, colThree, colFour, colAnswer, nil];
    
    //Crystal Palace
    UIImage *crysCrest = [UIImage imageNamed:@"CrystalPalace.png"];
    NSString *crysOne = @"Nottingham Forest";
    NSString *crysTwo = @"Peterborough";
    NSString *crysThree = @"Rio Ave FC";
    NSString *crysFour = @"Crystal Palace";
    NSString *crysAnswer = @"Crystal Palace";
    NSArray *crysArray = [[NSArray alloc] initWithObjects:crysCrest, crysOne, crysTwo, crysThree, crysFour, crysAnswer, nil];
    
    //Groningen
    UIImage *gronCrest = [UIImage imageNamed:@"Groningen.png"];
    NSString *gronOne = @"Groningen";
    NSString *gronTwo = @"Hertha Berlin";
    NSString *gronThree = @"Evian TG FC";
    NSString *gronFour = @"Gil Vicente";
    NSString *gronAnswer = @"Groningen";
    NSArray *gronArray = [[NSArray alloc] initWithObjects:gronCrest, gronOne, gronTwo, gronThree, gronFour, gronAnswer, nil];
    
    //Hertha Berlin
    UIImage *herCrest = [UIImage imageNamed:@"HerthaBerlin.png"];
    NSString *herOne = @"Barnsely";
    NSString *herTwo = @"Hertha Berlin";
    NSString *herThree = @"Hamburg";
    NSString *herFour = @"Stade Brestois";
    NSString *herAnswer = @"Hertha Berlin";
    NSArray *herArray = [[NSArray alloc] initWithObjects:herCrest, herOne, herTwo, herThree, herFour, herAnswer, nil];
    
    //Hull City
    UIImage *hullCrest = [UIImage imageNamed:@"HullCity.png"];
    NSString *hullOne = @"Mochengladbach";
    NSString *hullTwo = @"CA Tigre";
    NSString *hullThree = @"Hull City";
    NSString *hullFour = @"Wolverhampton";
    NSString *hullAnswer = @"Hull City";
    NSArray *hullArray = [[NSArray alloc] initWithObjects:hullCrest, hullOne, hullTwo, hullThree, hullFour, hullAnswer, nil];
    
    //Palmeiras
    UIImage *palmCrest = [UIImage imageNamed:@"Palmeiras.png"];
    NSString *palmOne = @"Pescara";
    NSString *palmTwo = @"Pacos de Ferreira";
    NSString *palmThree = @"Atl. Paranaense";
    NSString *palmFour = @"Palmeiras";
    NSString *palmAnswer = @"Palmeiras";
    NSArray *palmArray = [[NSArray alloc] initWithObjects:palmCrest, palmOne, palmTwo, palmThree, palmFour, palmAnswer, nil];
    
    //Racing Santander
    UIImage *racCrest = [UIImage imageNamed:@"RacingSantander.png"];
    NSString *racOne = @"Racing Santander";
    NSString *racTwo = @"Recreativo Huelva";
    NSString *racThree = @"Xerez";
    NSString *racFour = @"Auxerre";
    NSString *racAnswer = @"Racing Santander";
    NSArray *racArray = [[NSArray alloc] initWithObjects:racCrest, racOne, racTwo, racThree, racFour, racAnswer, nil];
    
    //Santos Laguna
    UIImage *santCrest = [UIImage imageNamed:@"SantosLaguna.png"];
    NSString *santOne = @"Quilmes";
    NSString *santTwo = @"Santos Laguna";
    NSString *santThree = @"Murcia";
    NSString *santFour = @"Club Leon";
    NSString *santAnswer = @"Santos Laguna";
    NSArray *santArray = [[NSArray alloc] initWithObjects:santCrest, santOne, santTwo, santThree, santFour, santAnswer, nil];
    
    //Universidad Catolica
    UIImage *ucCrest = [UIImage imageNamed:@"UCatolica.png"];
    NSString *ucOne = @"Deportivo Cali";
    NSString *ucTwo = @"Cadiz";
    NSString *ucThree = @"Universidad Catolica";
    NSString *ucFour = @"Universidad de Chile";
    NSString *ucAnswer = @"Universidad Catolica";
    NSArray *ucArray = [[NSArray alloc] initWithObjects:ucCrest, ucOne, ucTwo, ucThree, ucFour, ucAnswer, nil];
    
    //ValenciennesFC
    UIImage *valCrest = [UIImage imageNamed:@"ValenciennesFC.png"];
    NSString *valOne = @"SC Bastia";
    NSString *valTwo = @"AS Nancy Lorraine";
    NSString *valThree = @"OGC Nice";
    NSString *valFour = @"Valenciennes";
    NSString *valAnswer = @"Valenciennes";
    NSArray *valArray = [[NSArray alloc] initWithObjects:valCrest, valOne, valTwo, valThree, valFour, valAnswer, nil];

    
    levelTen = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelTen addObject:ajaArray];
    [levelTen addObject:limaArray];
    [levelTen addObject:bateArray];
    [levelTen addObject:breArray];
    [levelTen addObject:cardArray];
    [levelTen addObject:cerroArray];
    [levelTen addObject:cesArray];
    [levelTen addObject:libArray];
    [levelTen addObject:colArray];
    [levelTen addObject:crysArray];
    [levelTen addObject:gronArray];
    [levelTen addObject:herArray];
    [levelTen addObject:hullArray];
    [levelTen addObject:palmArray];
    [levelTen addObject:racArray];
    [levelTen addObject:santArray];
    [levelTen addObject:ucArray];
    [levelTen addObject:valArray];
    
    
    ////////      LEVEL 11       /////////
    
    //Augsburg
    UIImage *augCrest = [UIImage imageNamed:@"Augsburg.png"];
    NSString *augOne = @"Augsburg";
    NSString *augTwo = @"Angers SCO";
    NSString *augThree = @"Academica de Coimbra";
    NSString *augFour = @"Club Sol de America";
    NSString *augAnswer = @"Augsburg";
    NSArray *augArray = [[NSArray alloc] initWithObjects:augCrest, augOne, augTwo, augThree, augFour, augAnswer, nil];
    
    //Blackpool
    UIImage *bpoolCrest = [UIImage imageNamed:@"Blackpool.png"];
    NSString *bpoolOne = @"Barnsley";
    NSString *bpoolTwo = @"Blackpool";
    NSString *bpoolThree = @"Sheffield Wednesday";
    NSString *bpoolFour = @"Burnley";
    NSString *bpoolAnswer = @"Blackpool";
    NSArray *bpoolArray = [[NSArray alloc] initWithObjects:bpoolCrest, bpoolOne, bpoolTwo, bpoolThree, bpoolFour, bpoolAnswer, nil];
    
    //Bologna
    UIImage *bolCrest = [UIImage imageNamed:@"Bologna.png"];
    NSString *bolOne = @"Bari";
    NSString *bolTwo = @"Bahia";
    NSString *bolThree = @"Bologna";
    NSString *bolFour = @"Belgrano";
    NSString *bolAnswer = @"Bologna";
    NSArray *bolArray = [[NSArray alloc] initWithObjects:bolCrest, bolOne, bolTwo, bolThree, bolFour, bolAnswer, nil];
    
    //Columbus Crew
    UIImage *crewCrest = [UIImage imageNamed:@"ColumbusCrew.png"];
    NSString *crewOne = @"Arsenal de Sarandi";
    NSString *crewTwo = @"CA Progreso";
    NSString *crewThree = @"Pohang Steelers";
    NSString *crewFour = @"Columbus Crew";
    NSString *crewAnswer = @"Columbus Crew";
    NSArray *crewArray = [[NSArray alloc] initWithObjects:crewCrest, crewOne, crewTwo, crewThree, crewFour, crewAnswer, nil];
    
    //DCUnited
    UIImage *dcCrest = [UIImage imageNamed:@"DCUnited.png"];
    NSString *dcOne = @"DC United";
    NSString *dcTwo = @"Cucuta Deportivo";
    NSString *dcThree = @"LB Chateauroux";
    NSString *dcFour = @"Hibernians FC";
    NSString *dcAnswer = @"DC United";
    NSArray *dcArray = [[NSArray alloc] initWithObjects:dcCrest, dcOne, dcTwo, dcThree, dcFour, dcAnswer, nil];
    
    //Heracles
    UIImage *heraCrest = [UIImage imageNamed:@"Heracles.png"];
    NSString *heraOne = @"Willem II";
    NSString *heraTwo = @"Heracles";
    NSString *heraThree = @"Spartak Moscow";
    NSString *heraFour = @"FC Sochaux-Montbeliard";
    NSString *heraAnswer = @"Heracles";
    NSArray *heraArray = [[NSArray alloc] initWithObjects:heraCrest, heraOne, heraTwo, heraThree, heraFour, heraAnswer, nil];
    
    //Livorno
    UIImage *livoCrest = [UIImage imageNamed:@"Livorno.png"];
    NSString *livoOne = @"GE La Plata";
    NSString *livoTwo = @"Arsenal de Sarandi";
    NSString *livoThree = @"Livorno";
    NSString *livoFour = @"Alajuelense";
    NSString *livoAnswer = @"Livorno";
    NSArray *livoArray = [[NSArray alloc] initWithObjects:livoCrest, livoOne, livoTwo, livoThree, livoFour, livoAnswer, nil];
    
    //Millonarios
    UIImage *millCrest = [UIImage imageNamed:@"Millonarios.png"];
    NSString *millOne = @"Montevideo Wanderers";
    NSString *millTwo = @"Olimpo";
    NSString *millThree = @"Modena FC";
    NSString *millFour = @"Millonarios";
    NSString *millAnswer = @"Millonarios";
    NSArray *millArray = [[NSArray alloc] initWithObjects:millCrest, millOne, millTwo, millThree, millFour, millAnswer, nil];
    
    //Notts Forest
    UIImage *nottsCrest = [UIImage imageNamed:@"NottsForest.png"];
    NSString *nottsOne = @"Nottingham Forest";
    NSString *nottsTwo = @"Millwall FC";
    NSString *nottsThree = @"UD Las Palmas";
    NSString *nottsFour = @"Pacos de Ferriera";
    NSString *nottsAnswer = @"Nottingham Forest";
    NSArray *nottsArray = [[NSArray alloc] initWithObjects:nottsCrest, nottsOne, nottsTwo, nottsThree, nottsFour, nottsAnswer, nil];
    
    //OGC Nice
    UIImage *niceCrest = [UIImage imageNamed:@"OGCNice.png"];
    NSString *niceOne = @"FSV Frankfurt";
    NSString *niceTwo = @"OGC Nice";
    NSString *niceThree = @"SC Bastia";
    NSString *niceFour = @"Rio Ave FC";
    NSString *niceAnswer = @"OGC Nice";
    NSArray *niceArray = [[NSArray alloc] initWithObjects:niceCrest, niceOne, niceTwo, niceThree, niceFour, niceAnswer, nil];
    
    //Pachuca
    UIImage *pachuCrest = [UIImage imageNamed:@"Pachuca.png"];
    NSString *pachuOne = @"Queretaro";
    NSString *pachuTwo = @"Godoy Cruz";
    NSString *pachuThree = @"Pachuca";
    NSString *pachuFour = @"CD Santa Fe";
    NSString *pachuAnswer = @"Pachuca";
    NSArray *pachuArray = [[NSArray alloc] initWithObjects:pachuCrest, pachuOne, pachuTwo, pachuThree, pachuFour, pachuAnswer, nil];
    
    //Pumas
    UIImage *pumasCrest = [UIImage imageNamed:@"Pumas.png"];
    NSString *pumasOne = @"TP Mazembe";
    NSString *pumasTwo = @"Saprissa";
    NSString *pumasThree = @"Club Leon";
    NSString *pumasFour = @"Pumas UNAM";
    NSString *pumasAnswer = @"Pumas UNAM";
    NSArray *pumasArray = [[NSArray alloc] initWithObjects:pumasCrest, pumasOne, pumasTwo, pumasThree, pumasFour, pumasAnswer, nil];
    
    //Quilmes
    UIImage *quilmCrest = [UIImage imageNamed:@"Quilmes.png"];
    NSString *quilmOne = @"Quilmes";
    NSString *quilmTwo = @"Queretaro";
    NSString *quilmThree = @"Queen's Park";
    NSString *quilmFour = @"Qatar SC";
    NSString *quilmAnswer = @"Quilmes";
    NSArray *quilmArray = [[NSArray alloc] initWithObjects:quilmCrest, quilmOne, quilmTwo, quilmThree, quilmFour, quilmAnswer, nil];
    
    //Racing Avellaneda
    UIImage *raciCrest = [UIImage imageNamed:@"RacingAvellaneda.png"];
    NSString *raciOne = @"Empoli FC";
    NSString *raciTwo = @"Racing Avellaneda";
    NSString *raciThree = @"Lech Poznan";
    NSString *raciFour = @"Rosario Central";
    NSString *raciAnswer = @"Racing Avellaneda";
    NSArray *raciArray = [[NSArray alloc] initWithObjects:raciCrest, raciOne, raciTwo, raciThree, raciFour, raciAnswer, nil];
    
    //Reggina
    UIImage *reggCrest = [UIImage imageNamed:@"Reggina.png"];
    NSString *reggOne = @"Red Star Belgrade";
    NSString *reggTwo = @"Rochdale AFC";
    NSString *reggThree = @"Reggina";
    NSString *reggFour = @"Rapid Wien";
    NSString *reggAnswer = @"Reggina";
    NSArray *reggArray = [[NSArray alloc] initWithObjects:reggCrest, reggOne, reggTwo, reggThree, reggFour, reggAnswer, nil];
    
    //SC Bastia
    UIImage *bastiaCrest = [UIImage imageNamed:@"SCBastia.png"];
    NSString *bastiaOne = @"Stade de Reims";
    NSString *bastiaTwo = @"Copenhagen";
    NSString *bastiaThree = @"ESTAC Troyes";
    NSString *bastiaFour = @"SC Bastia";
    NSString *bastiaAnswer = @"SC Bastia";
    NSArray *bastiaArray = [[NSArray alloc] initWithObjects:bastiaCrest, bastiaOne, bastiaTwo, bastiaThree, bastiaFour, bastiaAnswer, nil];
    
    //U de Chile
    UIImage *uchileCrest = [UIImage imageNamed:@"UdeChile.png"];
    NSString *uchileOne = @"Universidad de Chile";
    NSString *uchileTwo = @"Estudiantes Tecos";
    NSString *uchileThree = @"Universidad Catolica";
    NSString *uchileFour = @"Correcaminos UAT";
    NSString *uchileAnswer = @"Universidad de Chile";
    NSArray *uchileArray = [[NSArray alloc] initWithObjects:uchileCrest, uchileOne, uchileTwo, uchileThree, uchileFour, uchileAnswer, nil];
    
    //Vasco Da Gama
    UIImage *vascoCrest = [UIImage imageNamed:@"VascoDaGama.png"];
    NSString *vascoOne = @"CA Colon";
    NSString *vascoTwo = @"Vasco da Gama";
    NSString *vascoThree = @"12 de Octubre FC";
    NSString *vascoFour = @"Orlando Pirates";
    NSString *vascoAnswer = @"Vasco da Gama";
    NSArray *vascoArray = [[NSArray alloc] initWithObjects:vascoCrest, vascoOne, vascoTwo, vascoThree, vascoFour, vascoAnswer, nil];
    
    levelEleven = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelEleven addObject:augArray];
    [levelEleven addObject:bpoolArray];
    [levelEleven addObject:bolArray];
    [levelEleven addObject:crewArray];
    [levelEleven addObject:dcArray];
    [levelEleven addObject:heraArray];
    [levelEleven addObject:livoArray];
    [levelEleven addObject:millArray];
    [levelEleven addObject:nottsArray];
    [levelEleven addObject:niceArray];
    [levelEleven addObject:pachuArray];
    [levelEleven addObject:pumasArray];
    [levelEleven addObject:quilmArray];
    [levelEleven addObject:raciArray];
    [levelEleven addObject:reggArray];
    [levelEleven addObject:bastiaArray];
    [levelEleven addObject:uchileArray];
    [levelEleven addObject:vascoArray];
    
    
    ////////      LEVEL 12       /////////
    
    //ADO Den Haag
    UIImage *haagCrest = [UIImage imageNamed:@"ADODenHaag.png"];
    NSString *haagOne = @"Brighton & Hove Albion";
    NSString *haagTwo = @"Coritiba FC";
    NSString *haagThree = @"ADO Den Haag";
    NSString *haagFour = @"SC Beira Mar";
    NSString *haagAnswer = @"ADO Den Haag";
    NSArray *haagArray = [[NSArray alloc] initWithObjects:haagCrest, haagOne, haagTwo, haagThree, haagFour, haagAnswer, nil];
    
    //ASNancy
    UIImage *nancyCrest = [UIImage imageNamed:@"ASNancy.png"];
    NSString *nancyOne = @"LB Chateauroux";
    NSString *nancyTwo = @"Stade Lavallois";
    NSString *nancyThree = @"Evian TG FC";
    NSString *nancyFour = @"AS Nancy Lorraine";
    NSString *nancyAnswer = @"AS Nancy Lorraine";
    NSArray *nancyArray = [[NSArray alloc] initWithObjects:nancyCrest, nancyOne, nancyTwo, nancyThree, nancyFour, nancyAnswer, nil];
    
    //BSC Young Boys
    UIImage *ybCrest = [UIImage imageNamed:@"BSCYoungBoys.png"];
    NSString *ybOne = @"BSC Young Boys";
    NSString *ybTwo = @"Burnley FC";
    NSString *ybThree = @"York City FC";
    NSString *ybFour = @"Belgrano";
    NSString *ybAnswer = @"BSC Young Boys";
    NSArray *ybArray = [[NSArray alloc] initWithObjects:ybCrest, ybOne, ybTwo, ybThree, ybFour, ybAnswer, nil];
    
    //Copenhagen
    UIImage *copCrest = [UIImage imageNamed:@"Copenhagen.png"];
    NSString *copOne = @"Trabzonspor";
    NSString *copTwo = @"Copenhagen";
    NSString *copThree = @"Union Berlin";
    NSString *copFour = @"TSV 1860 Munich";
    NSString *copAnswer = @"Copenhagen";
    NSArray *copArray = [[NSArray alloc] initWithObjects:copCrest, copOne, copTwo, copThree, copFour, copAnswer, nil];
    
    //Deportivo Quito
    UIImage *quitoCrest = [UIImage imageNamed:@"DeportivoQuito.png"];
    NSString *quitoOne = @"Rosario Central";
    NSString *quitoTwo = @"Ulsan Hyundai";
    NSString *quitoThree = @"Deportivo Quito";
    NSString *quitoFour = @"Deportes Tolima";
    NSString *quitoAnswer = @"Deportivo Quito";
    NSArray *quitoArray = [[NSArray alloc] initWithObjects:quitoCrest, quitoOne, quitoTwo, quitoThree, quitoFour, quitoAnswer, nil];
    
    //ESTAC Troyes
    UIImage *troyCrest = [UIImage imageNamed:@"ESTACTroyes.png"];
    NSString *troyOne = @"Bristol City";
    NSString *troyTwo = @"Levski Sofia";
    NSString *troyThree = @"Salt Lake City";
    NSString *troyFour = @"ESTAC Troyes";
    NSString *troyAnswer = @"ESTAC Troyes";
    NSArray *troyArray = [[NSArray alloc] initWithObjects:troyCrest, troyOne, troyTwo, troyThree, troyFour, troyAnswer, nil];
    
    //Estoril Praia
    UIImage *praiaCrest = [UIImage imageNamed:@"EstorilPraia.png"];
    NSString *praiaOne = @"Estoril Praia";
    NSString *praiaTwo = @"Club Sol de America";
    NSString *praiaThree = @"SC Beira Mar";
    NSString *praiaFour = @"Nautico FC";
    NSString *praiaAnswer = @"Estoril Praia";
    NSArray *praiaArray = [[NSArray alloc] initWithObjects:praiaCrest, praiaOne, praiaTwo, praiaThree, praiaFour, praiaAnswer, nil];
    
    //Furth
    UIImage *furthCrest = [UIImage imageNamed:@"Furth.png"];
    NSString *furthOne = @"Utrecht";
    NSString *furthTwo = @"Furth";
    NSString *furthThree = @"Freiburg";
    NSString *furthFour = @"Sturm Graz";
    NSString *furthAnswer = @"Furth";
    NSArray *furthArray = [[NSArray alloc] initWithObjects:furthCrest, furthOne, furthTwo, furthThree, furthFour, furthAnswer, nil];
    
    //Godoy Cruz
    UIImage *godoyCrest = [UIImage imageNamed:@"GodoyCruz.png"];
    NSString *godoyOne = @"Cucuta Deportivo";
    NSString *godoyTwo = @"Central Español FC";
    NSString *godoyThree = @"Godoy Cruz";
    NSString *godoyFour = @"Gimnasia y Esgrima";
    NSString *godoyAnswer = @"Godoy Cruz";
    NSArray *godoyArray = [[NSArray alloc] initWithObjects:godoyCrest, godoyOne, godoyTwo, godoyThree, godoyFour, godoyAnswer, nil];
    
    //Kashiwa Reysol
    UIImage *kashiCrest = [UIImage imageNamed:@"KashiwaReysol.png"];
    NSString *kashiOne = @"Recreativo Huelva";
    NSString *kashiTwo = @"Rosenborg";
    NSString *kashiThree = @"Rapid Bucuresti";
    NSString *kashiFour = @"Kashiwa Reysol";
    NSString *kashiAnswer = @"Kashiwa Reysol";
    NSArray *kashiArray = [[NSArray alloc] initWithObjects:kashiCrest, kashiOne, kashiTwo, kashiThree, kashiFour, kashiAnswer, nil];
    
    //Leicester City
    UIImage *leicCrest = [UIImage imageNamed:@"LeicesterCity.png"];
    NSString *leicOne = @"Leicester City";
    NSString *leicTwo = @"Peterborough";
    NSString *leicThree = @"Bristol Rovers";
    NSString *leicFour = @"Huddersfield";
    NSString *leicAnswer = @"Leicester City";
    NSArray *leicArray = [[NSArray alloc] initWithObjects:leicCrest, leicOne, leicTwo, leicThree, leicFour, leicAnswer, nil];
    
    //Recreativo Huelva
    UIImage *huelvaCrest = [UIImage imageNamed:@"RecreativoHuelva.png"];
    NSString *huelvaOne = @"Cordoba FC";
    NSString *huelvaTwo = @"Recreativo Huelva";
    NSString *huelvaThree = @"Crystal Palace";
    NSString *huelvaFour = @"Clermont Foot";
    NSString *huelvaAnswer = @"Recreativo Huelva";
    NSArray *huelvaArray = [[NSArray alloc] initWithObjects:huelvaCrest, huelvaOne, huelvaTwo, huelvaThree, huelvaFour, huelvaAnswer, nil];
    
    //Stade De Reims
    UIImage *reimsCrest = [UIImage imageNamed:@"StadeDeReims.png"];
    NSString *reimsOne = @"Stade Rennais";
    NSString *reimsTwo = @"Dijon FCO";
    NSString *reimsThree = @"Stade De Reims";
    NSString *reimsFour = @"CFR Cluj";
    NSString *reimsAnswer = @"Stade De Reims";
    NSArray *reimsArray = [[NSArray alloc] initWithObjects:reimsCrest, reimsOne, reimsTwo, reimsThree, reimsFour, reimsAnswer, nil];
    
    //TP Mazembe
    UIImage *mazCrest = [UIImage imageNamed:@"TPMazembe.png"];
    NSString *mazOne = @"SC Olhanense";
    NSString *mazTwo = @"CS Maritimo";
    NSString *mazThree = @"EC Bahia";
    NSString *mazFour = @"TP Mazembe";
    NSString *mazAnswer = @"TP Mazembe";
    NSArray *mazArray = [[NSArray alloc] initWithObjects:mazCrest, mazOne, mazTwo, mazThree, mazFour, mazAnswer, nil];
    
    //Utrecht
    UIImage *utrCrest = [UIImage imageNamed:@"Utrecht.png"];
    NSString *utrOne = @"Utrecht";
    NSString *utrTwo = @"Colon";
    NSString *utrThree = @"Fenix";
    NSString *utrFour = @"Genk";
    NSString *utrAnswer = @"Utrecht";
    NSArray *utrArray = [[NSArray alloc] initWithObjects:utrCrest, utrOne, utrTwo, utrThree, utrFour, utrAnswer, nil];
    
    //Vitesse
    UIImage *vitCrest = [UIImage imageNamed:@"Vitesse.png"];
    NSString *vitOne = @"Gandzasar FC";
    NSString *vitTwo = @"Vitesse";
    NSString *vitThree = @"FC Metalist Kharkiv";
    NSString *vitFour = @"Eintracht Braunschweig";
    NSString *vitAnswer = @"Vitesse";
    NSArray *vitArray = [[NSArray alloc] initWithObjects:vitCrest, vitOne, vitTwo, vitThree, vitFour, vitAnswer, nil];
    
    //Willem II
    UIImage *willCrest = [UIImage imageNamed:@"WillemII.png"];
    NSString *willOne = @"Kaiserlautern";
    NSString *willTwo = @"Calcio Padova";
    NSString *willThree = @"Willem II";
    NSString *willFour = @"Rapid Wien";
    NSString *willAnswer = @"Willem II";
    NSArray *willArray = [[NSArray alloc] initWithObjects:willCrest, willOne, willTwo, willThree, willFour, willAnswer, nil];
    
    //Xerez
    UIImage *xerezCrest = [UIImage imageNamed:@"Xerez.png"];
    NSString *xerezOne = @"Club Olimpo";
    NSString *xerezTwo = @"CE Sabadell";
    NSString *xerezThree = @"Numancia";
    NSString *xerezFour = @"Xerez";
    NSString *xerezAnswer = @"Xerez";
    NSArray *xerezArray = [[NSArray alloc] initWithObjects:xerezCrest, xerezOne, xerezTwo, xerezThree, xerezFour, xerezAnswer, nil];
    
    levelTwelve = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelTwelve addObject:haagArray];
    [levelTwelve addObject:nancyArray];
    [levelTwelve addObject:ybArray];
    [levelTwelve addObject:copArray];
    [levelTwelve addObject:quitoArray];
    [levelTwelve addObject:troyArray];
    [levelTwelve addObject:praiaArray];
    [levelTwelve addObject:furthArray];
    [levelTwelve addObject:godoyArray];
    [levelTwelve addObject:kashiArray];
    [levelTwelve addObject:leicArray];
    [levelTwelve addObject:huelvaArray];
    [levelTwelve addObject:reimsArray];
    [levelTwelve addObject:mazArray];
    [levelTwelve addObject:utrArray];
    [levelTwelve addObject:vitArray];
    [levelTwelve addObject:willArray];
    [levelTwelve addObject:xerezArray];
    
    
    ////////      LEVEL 13       /////////
    
    //Alajuelense
    UIImage *alaCrest = [UIImage imageNamed:@"Alajuelense.png"];
    NSString *alaOne = @"Alajuelense";
    NSString *alaTwo = @"Lokomotiv Moscow";
    NSString *alaThree = @"Red Star Belgrade";
    NSString *alaFour = @"Red Bull Salzburg";
    NSString *alaAnswer = @"Alajuelense";
    NSArray *alaArray = [[NSArray alloc] initWithObjects:alaCrest, alaOne, alaTwo, alaThree, alaFour, alaAnswer, nil];
    
    //Al Ittihad
    UIImage *ittiCrest = [UIImage imageNamed:@"AlIttihad.png"];
    NSString *ittiOne = @"Mansfield Town";
    NSString *ittiTwo = @"Al Ittihad";
    NSString *ittiThree = @"Hibernians FC";
    NSString *ittiFour = @"Dynamo Dresden";
    NSString *ittiAnswer = @"Al Ittihad";
    NSArray *ittiArray = [[NSArray alloc] initWithObjects:ittiCrest, ittiOne, ittiTwo, ittiThree, ittiFour, ittiAnswer, nil];
    
    //Bristol City
    UIImage *bristolCrest = [UIImage imageNamed:@"BristolCity.png"];
    NSString *bristolOne = @"Portsmouth";
    NSString *bristolTwo = @"Tours FC";
    NSString *bristolThree = @"Bristol City";
    NSString *bristolFour = @"Sturm Graz";
    NSString *bristolAnswer = @"Bristol City";
    NSArray *bristolArray = [[NSArray alloc] initWithObjects:bristolCrest, bristolOne, bristolTwo, bristolThree, bristolFour, bristolAnswer, nil];
    
    //CFR Cluj
    UIImage *clujCrest = [UIImage imageNamed:@"CFRCluj.png"];
    NSString *clujOne = @"Asteras Tripolis";
    NSString *clujTwo = @"Nimes Olympique";
    NSString *clujThree = @"FC Metalist Kharkiv";
    NSString *clujFour = @"CFR Cluj";
    NSString *clujAnswer = @"CFR Cluj";
    NSArray *clujArray = [[NSArray alloc] initWithObjects:clujCrest, clujOne, clujTwo, clujThree, clujFour, clujAnswer, nil];
    
    //Club Brugge
    UIImage *bruggeCrest = [UIImage imageNamed:@"ClubBrugge.png"];
    NSString *bruggeOne = @"Club Brugge";
    NSString *bruggeTwo = @"Espanyol";
    NSString *bruggeThree = @"Real Murcia";
    NSString *bruggeFour = @"FK Sarajevo";
    NSString *bruggeAnswer = @"Club Brugge";
    NSArray *bruggeArray = [[NSArray alloc] initWithObjects:bruggeCrest, bruggeOne, bruggeTwo, bruggeThree, bruggeFour, bruggeAnswer, nil];
    
    //Club Olimpia
    UIImage *olimCrest = [UIImage imageNamed:@"ClubOlimpia.png"];
    NSString *olimOne = @"EC Bahia";
    NSString *olimTwo = @"Club Olimpia";
    NSString *olimThree = @"Auckland City";
    NSString *olimFour = @"Guarani FC";
    NSString *olimAnswer = @"Club Olimpia";
    NSArray *olimArray = [[NSArray alloc] initWithObjects:olimCrest, olimOne, olimTwo, olimThree, olimFour, olimAnswer, nil];
    
    //Evian TG FC
    UIImage *evianCrest = [UIImage imageNamed:@"EvianTGFC.png"];
    NSString *evianOne = @"Rapid Wien";
    NSString *evianTwo = @"FC Zurich";
    NSString *evianThree = @"Evian TG FC";
    NSString *evianFour = @"Le Havre FC";
    NSString *evianAnswer = @"Evian TG FC";
    NSArray *evianArray = [[NSArray alloc] initWithObjects:evianCrest, evianOne, evianTwo, evianThree, evianFour, evianAnswer, nil];
    
    //FC Metalist
    UIImage *metaCrest = [UIImage imageNamed:@"FCMetalist.png"];
    NSString *metaOne = @"Metalurh Donetsk";
    NSString *metaTwo = @"Legia Warsaw";
    NSString *metaThree = @"Atromitos Athens";
    NSString *metaFour = @"FC Metalist";
    NSString *metaAnswer = @"FC Metalist";
    NSArray *metaArray = [[NSArray alloc] initWithObjects:metaCrest, metaOne, metaTwo, metaThree, metaFour, metaAnswer, nil];
    
    //Genk
    UIImage *genkCrest = [UIImage imageNamed:@"Genk.png"];
    NSString *genkOne = @"Genk";
    NSString *genkTwo = @"Standard Liege";
    NSString *genkThree = @"Nacional";
    NSString *genkFour = @"Saprissa";
    NSString *genkAnswer = @"Genk";
    NSArray *genkArray = [[NSArray alloc] initWithObjects:genkCrest, genkOne, genkTwo, genkThree, genkFour, genkAnswer, nil];
    
    //Ipswich Town
    UIImage *ipsCrest = [UIImage imageNamed:@"IpswichTown.png"];
    NSString *ipsOne = @"Derby County";
    NSString *ipsTwo = @"Ispwich Town";
    NSString *ipsThree = @"Bolton Wanderers";
    NSString *ipsFour = @"Rochdale";
    NSString *ipsAnswer = @"Ipswich Town";
    NSArray *ipsArray = [[NSArray alloc] initWithObjects:ipsCrest, ipsOne, ipsTwo, ipsThree, ipsFour, ipsAnswer, nil];
    
    //Maccabi Tel Aviv
    UIImage *maccCrest = [UIImage imageNamed:@"Maccabi.png"];
    NSString *maccOne = @"Maccabi Haifa";
    NSString *maccTwo = @"Al Ittihad";
    NSString *maccThree = @"Maccabi Tel Aviv";
    NSString *maccFour = @"El Dakhleya FC ";
    NSString *maccAnswer = @"Maccabi Tel Aviv";
    NSArray *maccArray = [[NSArray alloc] initWithObjects:maccCrest, maccOne, maccTwo, maccThree, maccFour, maccAnswer, nil];
    
    //NE Revolution
    UIImage *neCrest = [UIImage imageNamed:@"NERevolution.png"];
    NSString *neOne = @"Chicago";
    NSString *neTwo = @"San Jose";
    NSString *neThree = @"Portland";
    NSString *neFour = @"New England";
    NSString *neAnswer = @"New England";
    NSArray *neArray = [[NSArray alloc] initWithObjects:neCrest, neOne, neTwo, neThree, neFour, neAnswer, nil];
    
    //Real Salt Lake
    UIImage *rslCrest = [UIImage imageNamed:@"RealSaltLake.png"];
    NSString *rslOne = @"Real Salt Lake";
    NSString *rslTwo = @"Real Cartagena";
    NSString *rslThree = @"Real Colima";
    NSString *rslFour = @"Real Potosi";
    NSString *rslAnswer = @"Real Salt Lake";
    NSArray *rslArray = [[NSArray alloc] initWithObjects:rslCrest, rslOne, rslTwo, rslThree, rslFour, rslAnswer, nil];
    
    //Rosenborg
    UIImage *rosCrest = [UIImage imageNamed:@"Rosenborg.png"];
    NSString *rosOne = @"RB Leipzig";
    NSString *rosTwo = @"Rosenborg";
    NSString *rosThree = @"Rochdale";
    NSString *rosFour = @"Rennes";
    NSString *rosAnswer = @"Rosenborg";
    NSArray *rosArray = [[NSArray alloc] initWithObjects:rosCrest, rosOne, rosTwo, rosThree, rosFour, rosAnswer, nil];
    
    //Stade Brestois
    UIImage *brestCrest = [UIImage imageNamed:@"StadeBrestois.png"];
    NSString *brestOne = @"Stade Lavallois";
    NSString *brestTwo = @"CA Colon";
    NSString *brestThree = @"Stade Brestois";
    NSString *brestFour = @"Rosario Central";
    NSString *brestAnswer = @"Stade Brestois";
    NSArray *brestArray = [[NSArray alloc] initWithObjects:brestCrest, brestOne, brestTwo, brestThree, brestFour, brestAnswer, nil];
    
    //Tijuana
    UIImage *tijCrest = [UIImage imageNamed:@"Tijuana.png"];
    NSString *tijOne = @"Veracruz";
    NSString *tijTwo = @"Deportes Tolima";
    NSString *tijThree = @"Cucuta Deportivo";
    NSString *tijFour = @"Tijuana";
    NSString *tijAnswer = @"Tijuana";
    NSArray *tijArray = [[NSArray alloc] initWithObjects:tijCrest, tijOne, tijTwo, tijThree, tijFour, tijAnswer, nil];
    
    //Ulsan Hyundai
    UIImage *hyunCrest = [UIImage imageNamed:@"UlsanHyundai.png"];
    NSString *hyunOne = @"Ulsan Hyundai";
    NSString *hyunTwo = @"Chesterfield FC";
    NSString *hyunThree = @"FC Seoul";
    NSString *hyunFour = @"Slask Wroclaw";
    NSString *hyunAnswer = @"Ulsan Hyundai";
    NSArray *hyunArray = [[NSArray alloc] initWithObjects:hyunCrest, hyunOne, hyunTwo, hyunThree, hyunFour, hyunAnswer, nil];
    
    //Viktoria Plzen
    UIImage *vikCrest = [UIImage imageNamed:@"ViktoriaPlzen.png"];
    NSString *vikOne = @"Gil Vicente FC";
    NSString *vikTwo = @"FC Viktoria Plzen";
    NSString *vikThree = @"Gandzasar FC";
    NSString *vikFour = @"Metalurh Donetsk";
    NSString *vikAnswer = @"FC Viktoria Plzen";
    NSArray *vikArray = [[NSArray alloc] initWithObjects:vikCrest, vikOne, vikTwo, vikThree, vikFour, vikAnswer, nil];
   
    levelThirteen = [[NSMutableArray alloc]initWithCapacity:18];
    
    [levelThirteen addObject:alaArray];
    [levelThirteen addObject:ittiArray];
    [levelThirteen addObject:bristolArray];
    [levelThirteen addObject:clujArray];
    [levelThirteen addObject:bruggeArray];
    [levelThirteen addObject:olimArray];
    [levelThirteen addObject:evianArray];
    [levelThirteen addObject:metaArray];
    [levelThirteen addObject:genkArray];
    [levelThirteen addObject:ipsArray];
    [levelThirteen addObject:maccArray];
    [levelThirteen addObject:neArray];
    [levelThirteen addObject:rslArray];
    [levelThirteen addObject:rosArray];
    [levelThirteen addObject:brestArray];
    [levelThirteen addObject:tijArray];
    [levelThirteen addObject:hyunArray];
    [levelThirteen addObject:vikArray];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
