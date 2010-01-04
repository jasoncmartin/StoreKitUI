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

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[SKProductsManager productManager] products] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SKUIStoreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	//cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
    
    // Set up the cell...
	SKProduct *product = [[[SKProductsManager productManager] products] objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [product localizedTitle];
	
	if([[SKProductsManager productManager] isProductPurchased:product.productIdentifier]) {
		cell.detailTextLabel.text = NSLocalizedString(@"Purchased", @"Purchased");
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
		[currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
		[currencyStyle setLocale:product.priceLocale];
		
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[[SKProductsManager productManager] removeObserver:self forKeyPath:@"products"];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[progressView release];
	progressView = nil;
	
    [super dealloc];
}


@end

