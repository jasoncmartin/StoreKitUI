//
//  SKProductsManager.h
//  StoreKitUI
//
//  Created by Jason C. Martin on 12/28/09.
//  Copyright 2009 New Media Geekz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

@protocol SKProductsManagerDelegate;

@interface SKProductsManager : NSObject <SKProductsRequestDelegate> {
	@private
	NSArray *products;
	id <SKProductsManagerDelegate> delegate;
	
	BOOL sandbox;
}

@property (nonatomic, copy, readonly) NSArray *products;
@property (nonatomic, assign) id <SKProductsManagerDelegate> delegate;
@property (nonatomic, assign, getter=isSandbox) BOOL sandbox;

+ (SKProductsManager *)productManager;

- (void)loadProducts:(NSSet *)allProducts;

@end

@protocol SKProductsManagerDelegate <NSObject>

@optional

- (void)productsManagerDidGetNewProducts:(NSArray *)newProducts;

@end

#endif
