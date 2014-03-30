//
//  ViewController.m
//  Peak
//
//  Created by David LoBosco on 3/29/14.
//  Copyright (c) 2014 David LoBosco. All rights reserved.
//

#import "ViewController.h"
#import "MyCustomTableViewCell.h"
#import "PeakMoment.h"
#import "MyModalViewController.h"

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#include <stdlib.h>

@interface ViewController ()<MyModalViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
//parseLogins>

@property (strong, nonatomic) UIImage* imageFromPicker;
@property (nonatomic,strong) PeakMoment* myMoment;
//@property (nonatomic) MBProgressHUD *HUD;
//@property (nonatomic)MBProgressHUD *refreshHUD;

@end

@implementation ViewController

@synthesize dayPost,tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    dayPost = [NSMutableArray new];
    
    //declare delegate/datasource for tableview
    tableView.delegate = self;
    tableView.dataSource = self;
    
    NSMutableArray *moments = [NSMutableArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Peak_Data"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      
        for (PFObject *object in objects)
        {
            PeakMoment *moment = [PeakMoment new];
            [moment setCaption:object[@"caption"]];
            PFFile *file = object[@"photo"];
            NSData *data = [file getData:nil];
            UIImage *image = [[UIImage alloc] initWithData:data];
            [moment setPhoto:image];
            [moments addObject:moment];
        }
        
        [dayPost addObjectsFromArray:moments];
        [tableView reloadData];
        
    }];
    
//  Parse Practice below
    //PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //testObject[@"foo"] = @"bar";
   //[testObject saveInBackground];
    
}

/* DB STUFF
 

 
 
 
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    /* PARSE*/
    /** uncomment for db stuff 
     
     
     
     
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        NSLog(@"NO USER..yet");
        
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }/*else{
        
        PFUser *user = [PFUser currentUser];
        
        
        // Find all posts by the current user
        PFQuery *query = [PFQuery queryWithClassName:@"Post"];
        query.limit = 3;
        [query whereKey:@"user" equalTo:user];
        
        NSArray *usersPosts = [query findObjects];
        dayPost = [[NSMutableArray alloc] initWithArray:usersPosts];
     
     
     
     
     
    }
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dayPost.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCustomCell" forIndexPath:indexPath];
    PeakMoment *current =[dayPost objectAtIndex:[indexPath row]];
    cell.caption.text = current.caption;
    cell.pic.image = current.photo;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 273;
}


- (IBAction)add:(id)sender {
    UIImagePickerController *controller = [UIImagePickerController new];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:^{
    
    }];
}


-(void)allDone:(PeakMoment *)moment
{
    self.myMoment = moment;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if(!dayPost)
        {
            dayPost=[[NSMutableArray alloc] init];
        }
        
        [dayPost insertObject:self.myMoment atIndex:0];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSData *imageData = UIImagePNGRepresentation([moment photo]);
        PFFile *photo = [PFFile fileWithName:@"image.png" data:imageData];
        
        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
           
            // Look at succeeded, throw error alert if needed
            // [error localizedDescription] error reason
            
            PFObject *myObject = [PFObject objectWithClassName:@"Peak_Data"];
            myObject[@"caption"] = [moment caption];
            myObject[@"photo"] = photo;
            [myObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                // Look at succeeed make sure is YES, error if needed
                
                // dismiess waiting view

                
            }];
            
        }];
        

        
        
    }];
}


        /* DB stuff
         
         
         
         
        PFObject *addStuff = [PFObject objectWithClassName:@"Peak_Data"];
        [addStuff setObject: self.myMoment.caption forKey:@"caption"];
        //[addStuff setObject:[PFUser currentUser] forKey:@"user"];
        [addStuff saveInBackground];
        NSData *imageData = UIImageJPEGRepresentation(self.myMoment.photo, 0.05f);
        self.imageFile = [PFFile new];
        self.imageFile=[PFFile fileWithName:@"Photo" data:imageData];
         
         
         
         */
   // }];
    /*
    [self.imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:self.imageFile forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self refresh:nil];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            [self.HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        self.HUD.progress = (float)percentDone/100;
    }];*/
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MyModalViewController *myModal = [segue destinationViewController];
    myModal.imageToDisplay = self.imageFromPicker;
    
    [myModal setDelegate:self];
    
}


#pragma mark - UIImagePickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageFromPicker = image;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self performSegueWithIdentifier:@"Modal" sender:nil];
        
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/*DB Stuff
 
 

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

*/
@end
