//
//  InAppPurchaseManager.m
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 6/17/13.
//  Copyright (c) 2013 ASFM. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import "XYZViewController.h"

#define kInAppPurchaseDisableTimerProductId @"footballmaster.disabletimer"
@interface InAppPurchaseManager()

@end

@implementation InAppPurchaseManager

Options* optionsObj = nil;

+ (void)initialize
{
    if(!optionsObj)
        optionsObj = [[Options alloc] init];
}

- (void)requestDisableTimerProductData
{
    NSSet *productIdentifiers = [NSSet setWithObject:@"footballmaster.disabletimer" ];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

- (void) restoreIAP2
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue]  restoreCompletedTransactions];
    NSLog(@"RESTOREDDDDDDDDD");
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"METHOD ENTEREDDDDDDDDDDDD");
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDisableTimerPurchased" ];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    disableTimerProduct = [products count] == 1 ? [[products firstObject] retain] : nil;
    if (disableTimerProduct)
    {
    /* 
        NSLog(@"Product title: %@" , disableTimerProduct.localizedTitle);
        NSLog(@"Product description: %@" , disableTimerProduct.localizedDescription);
        NSLog(@"Product price: %@" , disableTimerProduct.price);
        NSLog(@"Product id: %@" , disableTimerProduct.productIdentifier);
     */
        
        NSString *title = [NSString stringWithFormat:@"%@", disableTimerProduct.localizedTitle];
        NSString *message = [NSString stringWithFormat:@"%@", disableTimerProduct.localizedDescription];
        
        UIAlertView *purchaseDialogue;
        
        purchaseDialogue = [[UIAlertView alloc]
                                 initWithTitle:title
                                 message:message
                                 delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 otherButtonTitles:@"Buy for $0.99", nil];
        
        [purchaseDialogue show];
    }
    
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    [productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

- (void) alertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex: buttonIndex] isEqualToString:@"Buy for $0.99"])
    {
		[self purchaseDisableTimer];
	}
}

#pragma mark Public methods

// call this method once on startup
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestDisableTimerProductData];
}

// call this before making a purchase
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}


// kick off the purchase transaction
- (void)purchaseDisableTimer
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseDisableTimerProductId];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


#pragma Purchase helpers

// saves a record of the transaction by storing the receipt to disk
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseDisableTimerProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"disableTimerTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// enable the switch to disable the timer
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kInAppPurchaseDisableTimerProductId])
    {
        // enable the switch
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDisableTimerPurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *purchaseSuccessful;
        
        purchaseSuccessful = [[UIAlertView alloc]
                                 initWithTitle:@"Thank you"
                                 message:@"\"Disable Timer\" was successfully downloaded. Go back to home and return here to see the switch appear."
                                 delegate:self
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles: nil];
        
        [purchaseSuccessful show];
    }
}

// removes the transaction from the queue and posts a notification with the transaction result
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

// called when the transaction was successful
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}



// called when a transaction has been restored and and successfully completed
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

// called when a transaction has failed
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark SKPaymentTransactionObserver methods

// called when the transaction status is updated
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

@end
