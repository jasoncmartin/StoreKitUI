//
//  SKProgressView.m
//  StoreKitUI
//
//  Created by Jason C. Martin on 1/3/10.
//  Copyright 2010 New Media Geekz. All rights reserved.
//

#import "SKProgressView.h"


@implementation SKProgressView

@synthesize label;

- (id)init {
	if(self = [super initWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]]) {
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		
		self.alpha = 0.0;
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.text = NSLocalizedString(@"Purchasing...", @"Purchasing...");
	}
	
	return self;
}

- (void)layoutSubviews {
	BOOL containsIndicator = NO;
	
	for(UIView *subview in self.subviews) {
		if([subview isKindOfClass:[UIActivityIndicatorView class]])
			containsIndicator = YES;
	}
	
	if(!containsIndicator) {
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[indicator startAnimating];
		indicator.center = [[[UIApplication sharedApplication] keyWindow] center];
		[self addSubview:indicator];
		[indicator release];
	}
	
	[label sizeToFit];
	label.center = CGPointMake(indicator.center.x, indicator.center.y + 30);
	label.adjustsFontSizeToFitWidth = NO;
	label.textAlignment = UITextAlignmentCenter;
	label.opaque = NO;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	
	if(!label.superview)
		[self addSubview:label];
}

- (void)fillRoundedRect:(CGRect)rect inContext:(CGContextRef)context {
    float radius = 10.0f;
    
    CGContextBeginPath(context);
	CGContextSetGrayFillColor(context, 0.0, 0.6);
	CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
	
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)drawRect:(CGRect)rect {
	// Center HUD
	CGRect allRect = self.bounds;
	
	CGContextRef ctxt = UIGraphicsGetCurrentContext();	
	CGContextSetGrayFillColor(ctxt, 0.0, 0.2);
	CGContextFillRect(ctxt, allRect);
	
	// Draw rounded HUD bacgroud rect
	CGRect boxRect = CGRectMake((allRect.size.width-200.0)/2 , (allRect.size.height-150.0)/2, 200.0, 150.0);
	[self fillRoundedRect:boxRect inContext:ctxt];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	[self removeFromSuperview];
}

- (void)show {
	if(!self.superview)
		[[[UIApplication sharedApplication] keyWindow] addSubview:self];
	
	self.transform = CGAffineTransformMakeScale(1.5, 1.5);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.40];
	self.alpha = 1.0;
	self.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

- (void)hide {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.40];
	[UIView setAnimationDidStopSelector:@selector(animationFinished: finished: context:)];
	self.alpha = 0.0;
	//self.transform = CGAffineTransformMakeScale(0.5, 0.5);
	[UIView commitAnimations];
}

- (void)dealloc {
	[label release];
	label = nil;
	
    [super dealloc];
}


@end
