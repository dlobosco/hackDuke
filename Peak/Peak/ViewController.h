//
//  ViewController.h
//  Peak
//
//  Created by David LoBosco on 3/29/14.
//  Copyright (c) 2014 David LoBosco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
@interface ViewController : UIViewController
    <UITableViewDelegate,UITableViewDataSource>


@property (nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic) PFFile *imageFile;
@property (nonatomic) NSMutableArray *dayPost;


//- (void)hudWasHidden:(MBProgressHUD *)hud;
@end
