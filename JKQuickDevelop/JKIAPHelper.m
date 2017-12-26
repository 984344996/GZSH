//
//  JKIAPHelper.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/3/29.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "JKIAPHelper.h"
#import <StoreKit/StoreKit.h>

#ifdef DEBUG
#define checkURL @"https://sandbox.itunes.apple.com/verifyReceipt"
#else
#define checkURL @"https://buy.itunes.apple.com/verifyReceipt"
#endif

@interface JKIAPHelper ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic, strong) NSMutableDictionary *productsDic;
@end

@implementation JKIAPHelper

#pragma mark - Public methods
+ (JKIAPHelper *)sharedHelper{
    static JKIAPHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JKIAPHelper alloc] init];
    });
    return instance;
}

- (void)requestProductsWithProductIDs:(NSArray *)ids{
    DLog("开始请求商品")
    
    // 能够销售的商品
    NSSet *set                 = [[NSSet alloc] initWithArray:ids];

    // 异步请求商品信息
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate           = self;
    [request start];
}

- (void)purchaseProduct:(NSString *)productIdentifier{
    SKProduct *product = self.productsDic[productIdentifier];

    // 要购买的产品
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    // 加入异步购买队列
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - Privates
- (void)setup{
    self.checkAfterPay = YES;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

/**
 *  恢复商品
 */
- (void)restorePurchase
{
    // 恢复已经完成的所有交易.（仅限永久有效商品）
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


/**
 到苹果服务器验证是否购买成功

 @param productIdentifier 购买产品id
 */
- (void)verifyPruchaseWithID:(NSString *)productIdentifier{
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL   = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];

    /**
     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *payload   = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];

    // 发送网络POST请求，对购买凭据进行验证
    // In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    // In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    // Create a POST request with the receipt data.
    NSURL *url                   = [NSURL URLWithString:checkURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod           = @"POST";
    request.HTTPBody = payloadData;
    // 提交验证请求，并获得官方的验证JSON结果
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) {
            [self.delegate iapVerifyResult:false productId:productIdentifier];
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments error:nil];
        if (dict != nil) {
            // 验证成功,通知代理
            [self.delegate iapVerifyResult:true productId:productIdentifier];
        }else{
            // 验证失败,通知代理
            [self.delegate iapVerifyResult:false productId:productIdentifier];
        }
    }];
    [task resume];
}

#pragma mark - Delegates

/**
 获取询问结果，把可销售的商品加入字典

 @param request 请求内容
 @param response 返回的结果
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    if (self.productsDic == nil) {
        self.productsDic = [NSMutableDictionary dictionaryWithCapacity:response.products.count];
    }
    
    NSMutableArray *productsArray = [NSMutableArray array];
    for (SKProduct *product in response.products) {
        // 填充商品字典
        [self.productsDic setObject:product forKey:product.productIdentifier];
        [productsArray addObject:product];
    }
    // 通知代理
    [self.delegate iapProductsRequestWithResult:productsArray];
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                DLog("用户开始购买...")
                break;
                
            case SKPaymentTransactionStateDeferred:
                DLog("最终状态不确定...")
                break;
                
            case SKPaymentTransactionStateRestored:
                DLog("用户已经购买过...")
                // 通知代理
                [self.delegate iapPurchaseRestoreWithProductId:transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                DLog("用户购买失败...")
                // 通知代理
                [self.delegate iapPurchaseFailedWithProductId:transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            
            case SKPaymentTransactionStatePurchased:
                DLog("用户购买成功...")
                if (self.checkAfterPay) {
                    // 向苹果服务器验证
                    [self verifyPruchaseWithID:transaction.payment.productIdentifier];
                }
                
                // 通知购买成功
                [self.delegate iapPurchaseSucceedWithProductId:transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

@end
