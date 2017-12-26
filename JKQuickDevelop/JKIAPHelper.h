//
//  JKIAPHelper.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/3/29.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JKIAPHelperDelegate <NSObject>

/**
 请求商品信息回调

 @param products 返回商品数组
 */
- (void)iapProductsRequestWithResult:(NSArray *)products;


/**
 购买成功回调

 @param productId 商品ID
 */
- (void)iapPurchaseSucceedWithProductId:(NSString *)productId;


/**
 购买失败回调

 @param productId 商品ID
 */
- (void)iapPurchaseFailedWithProductId:(NSString *)productId;

/**
 之前已经购买回调
 
 @param productId 商品ID
 */
- (void)iapPurchaseRestoreWithProductId:(NSString *)productId;

/**
 Appstore购买认证回调

 @param success 是否成功
 @param productId 商品ID
 */
- (void)iapVerifyResult:(BOOL)success productId:(NSString *)productId;
@end

@interface JKIAPHelper : NSObject

/**
 购买结束后检测
 */
@property (nonatomic, assign)BOOL checkAfterPay;
@property (nonatomic, strong) id<JKIAPHelperDelegate> delegate;

/**
 The helpr instance to do in purchase

 @return the helper instance
 */;
+ (JKIAPHelper *)sharedHelper;


/**
 根据商品ID请求商品列表

 @param ids 商品id数组
 */
- (void)requestProductsWithProductIDs:(NSArray *)ids;


/**
 购买根据商品ID商品

 @param productIdentifier 待购买商品id
 */
- (void)purchaseProduct:(NSString *)productIdentifier;

@end
