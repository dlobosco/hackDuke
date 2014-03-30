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
@interface ViewController ()<MyModalViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIImage* imageFromPicker;
@property (nonatomic,strong) PeakMoment* myMoment;
@end

@implementation ViewController

@synthesize dayPost,tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    //declare delegate/datasource for tableview
    tableView.delegate = self;
    tableView.dataSource = self;
    
    
    
    //UINib *nib = [UINib nibWithNibName:@"" bundle:nil];
    //[[self tableView] registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    
}

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
    PeakMoment* current =[dayPost objectAtIndex:0];
    cell.caption.text = current.caption;
    cell.imageView.image = current.photo;
    
    //    NSDate *object = _objects[indexPath.row];
    //    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
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


-(void)allDone:(PeakMoment *)moment{
//    NSString* cap = moment.caption;
//    UIImage* pic = moment.photo;
    //self.myMoment = [[PeakMoment alloc] initWithImage:moment.photo];
    //self.myMoment.caption = [[NSString alloc] initWithString:moment.caption];
    self.myMoment = moment;
    [self dismissViewControllerAnimated:YES completion:^{
        if(!dayPost){
            dayPost=[[NSMutableArray alloc] init];
        }
        [dayPost insertObject:self.myMoment atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
       
        NSLog(@"%@", self.myMoment);
    }];
   // NSLog(@"%@", self.myMoment.caption);
   
}

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

@end
