//
//  SKStoreRootViewController.m
//  StoreKitUI
//
//  Created by Jason C. Martin on 12/28/09.
//  Copyright 2009 New Media Geekz. All rights reserved.
//

#import "SKStoreViewController.h"
#import "StoreKitUI/SKProductsManager.h"
#import "SKProgressView.h"

@implementation SKStoreViewController

@synthesize productIDs;

- (id)init {
	if(self = [super initWithStyle:UITableViewStylePlain]) {
		[[SKProductsManager productManager] addObserver:self forKeyPath:@"products" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPurchase:) name:@"StoreKitUIDidFinishPurchase" object:nil];
		
		self.navigationItem.title = NSLocalizedString(@"Store", @"Store");
		
		progressView = [[SKProgressView alloc] init];
		progressView.label.text = NSLocalizedString(@"Loading...", @"Loading...");
		[progressView.label sizeToFit];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"products"]) {
		[progressView hide];
		
		[[self tableView] reloadData];
    }
}

- (void)didPurchase:(id)unused {
	[progressView hide];
	
	[[self tableView] reloadData];
}

- (void)setProductIDs:(NSSet *)newProducts {
	@synchronized(self) {
		if(newProducts != productIDs) {
			[productIDs release];
			productIDs = [newProducts copy];
			
			if(productIDs) {
				[[SKProductsManager productManager] loadProducts:productIDs];
				
				[progressView performSelector:@selector(show) withObject:nil afterDelay:0.3];
			}
		}
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[SKProductsManager productManager] products] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SKUIStoreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	SKProduct *product = [[[SKProductsManager productManager] products] objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [product localizedTitle];
	
	if([[SKProductsManager productManager] isProductPurchased:product.productIdentifier]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
		[currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
		
		cell.detailTextLabel.text = [currencyStyle stringFromNumber:product.price];
		[currencyStyle release];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([[SKProductsManager productManager] isProductPurchased:[(SKProduct *)[[[SKProductsManager productManager] products] objectAtIndex:indexPath.row] productIdentifier]])
	   return;
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	progressView.label.text = NSLocalizedString(@"Purchasing...", @"Purchasing...");
	[progressView.label sizeToFit];
	[progressView show];
	
	[[SKProductsManager productManager] purchaseProductAtIndex:indexPath.row];
}

- (void)dealloc {
	[[SKProductsManager productManager] removeObserver:self forKeyPath:@"products"];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[progressView release];
	progressView = nil;
	
    [super dealloc];
}


@end

