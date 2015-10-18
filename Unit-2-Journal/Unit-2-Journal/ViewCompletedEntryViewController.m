//
//  ViewCompletedEntryViewController.m
//  Unit-2-Journal
//
//  Created by Shena Yoshida on 10/10/15.
//  Copyright © 2015 Jamaal Sedayao. All rights reserved.
//

#import "ViewCompletedEntryViewController.h"

@interface ViewCompletedEntryViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *completedImageView;
@property (weak, nonatomic) IBOutlet UILabel *completedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedCreatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedDateLabel; // review written on
@property (weak, nonatomic) IBOutlet UITextView *completedReviewTextView;

@property (weak, nonatomic) IBOutlet UIButton *starOne;
@property (weak, nonatomic) IBOutlet UIButton *starTwo;
@property (weak, nonatomic) IBOutlet UIButton *starThree;
@property (weak, nonatomic) IBOutlet UIButton *starFour;
@property (weak, nonatomic) IBOutlet UIButton *starFive;

@end

@implementation ViewCompletedEntryViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"Journal Post passed: %@",self.journalPostDetail);
    
    self.completedTitleLabel.text = self.journalPostDetail.title;
    self.completedCreatorLabel.text = self.journalPostDetail.creator;
    self.completedDateLabel.text = [NSString stringWithFormat:@"%@",self.journalPostDetail.dateEntered];
    self.completedReviewTextView.text = self.journalPostDetail.postText;
    
    NSURL *imageURL = [NSURL URLWithString:self.journalPostDetail.imageForMedia];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    self.completedImageView.image = image;
    
    // round corners
    self.completedImageView.clipsToBounds = YES;
    self.completedImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.completedImageView.layer.borderWidth = 2.0;
    self.completedImageView.layer.cornerRadius = 25.0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - delete item

- (IBAction)deleteButtonTapped:(id)sender
{
    // delete item from memory and storyboard
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
