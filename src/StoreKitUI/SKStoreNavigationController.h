//
//  SKStoreNavigationController.h
//  StoreKitUI
//
//  Created by Jason C. Martin on 12/28/09.
//  Copyright 2009 New Media Geekz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKitUI/SKProductsManager.h>

@interface SKStoreNavigationController : UINavigationController {
	@private
		NSArray *productIDs;
}

@property (nonatomic, copy) NSArray *productIDs;

@end
