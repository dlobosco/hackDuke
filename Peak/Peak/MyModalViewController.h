//
//  MyModalViewController.h
//  Peak
//
//  Created by David LoBosco on 3/29/14.
//  Copyright (c) 2014 David LoBosco. All rights reserved.
//

#import "ViewController.h"
#import "PeakMoment.h"
@protocol MyModalViewControllerDelegate <NSObject>

-(void)allDone:(PeakMoment *)moment;

@end

@interface MyModalViewController : ViewController

@property (nonatomic, strong) UIImage *imageToDisplay;
@property (nonatomic, weak) id<MyModalViewControllerDelegate> delegate;

@end
