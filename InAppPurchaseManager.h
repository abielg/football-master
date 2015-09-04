//
//  InAppPurchaseManager.h
//  soccerBadgeQuiz
//
//  Created by Abiel Gutierrez on 6/17/13.
//  Copyright (c) 2013 ASFM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "Options.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *disableTimerProduct;
    SKProductsRequest *productsRequest;
}
- (void)loadStore;
- (void) restoreIAP2;
- (BOOL)canMakePurchases;
- (void)purchaseDisableTimer;

@end