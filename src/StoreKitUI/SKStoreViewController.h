//
//  SKStoreRootViewController.h
//  StoreKitUI
//
//  Created by Jason C. Martin on 12/28/09.
//  Copyright 2009 New Media Geekz. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

@interface SKStoreViewController : UITableViewController {
	@private
		NSSet *productIDs;
}

@property (nonatomic, copy) NSSet *productIDs;

@end

#endif
