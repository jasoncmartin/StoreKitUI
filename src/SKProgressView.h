//
//  SKProgressView.h
//  StoreKitUI
//
//  Created by Jason C. Martin on 1/3/10.
//  Copyright 2010 New Media Geekz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SKProgressView : UIView {
	UILabel *label;
}

@property (nonatomic, retain, readonly) UILabel *label;

- (void)show;
- (void)hide;

@end
