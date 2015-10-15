//
//  CreateJournalEntryViewController.m
//  Unit-2-Journal
//
//  Created by Shena Yoshida on 10/10/15.
//  Copyright © 2015 Jamaal Sedayao. All rights reserved.
//

#import "CreateJournalEntryViewController.h"
#import "JournalPost.h"
#import "TabBarViewController.h"
#import "JournalMainCollectionViewController.h"
#import <pop/POP.h>


@interface CreateJournalEntryViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *movieOrAlbumNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *doneEditingButton;

@property (strong, nonatomic) IBOutlet UIButton *starButtonOne;
@property (strong, nonatomic) IBOutlet UIButton *starButtonTwo;
@property (strong, nonatomic) IBOutlet UIButton *starButtonThree;
@property (strong, nonatomic) IBOutlet UIButton *starButtonFour;
@property (strong, nonatomic) IBOutlet UIButton *starButtonFive;

@property (nonatomic) JournalPost *journalPost;
@property (nonatomic) NSMutableArray *journalPostArray;

@end

@implementation CreateJournalEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.journalPostArray = [[NSMutableArray alloc]init];
    
    NSLog(@"Data has been passed: %@",self.postSearchResult);
    
    self.doneEditingButton.hidden = YES;
    
    //manage textview
    self.textView.delegate = self;
    self.textView.text = @"Write your thoughts here...";
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.cornerRadius = 5.0f;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
   
    //populate journal header
    self.movieOrAlbumNameLabel.text = self.postSearchResult.albumOrMovieName;
    self.artistNameLabel.text = self.postSearchResult.artistName;
    NSURL *artworkURL = [NSURL URLWithString:self.postSearchResult.artworkURL];
    NSData *artworkData = [NSData dataWithContentsOfURL:artworkURL];
    UIImage *artworkImage = [UIImage imageWithData:artworkData];
    self.artworkImageView.image = artworkImage;
    
    //round image corners
    self.artworkImageView.clipsToBounds = YES;
    self.artworkImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.artworkImageView.layer.borderWidth = 2.0;
    self.artworkImageView.layer.cornerRadius = 25.0;
    
}
- (void) textViewDidBeginEditing:(UITextView *)textView{
    self.textView.text = @"";
    
    self.doneEditingButton.hidden = NO;
}

- (IBAction)doneEditingTapped:(id)sender {
    
    self.doneEditingButton.hidden = YES;
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - star rating

- (IBAction)oneStarTapped:(id)sender
{
    [self resetStars];
    [self oneStarRating];
    [self startAnimation];
}

- (IBAction)twoStarTapped:(id)sender
{
    [self resetStars];
    [self twoStarRating];
    [self startAnimation];
}

- (IBAction)threeStarTapped:(id)sender
{
    [self resetStars];
    [self threeStarRating];
    [self startAnimation];
}

- (IBAction)fourStarTapped:(id)sender
{
    [self resetStars];
    [self fourStarRating];
    [self startAnimation];
}
- (IBAction)fiveStarTapped:(id)sender
{
    [self resetStars];
    [self fiveStarRating];
    [self startAnimation];
}

- (void)resetStars
{
    [self.starButtonOne setBackgroundImage:[UIImage imageNamed:@"rating_star.png"] forState:UIControlStateNormal];
    [self.starButtonTwo setBackgroundImage:[UIImage imageNamed:@"rating_star.png"] forState:UIControlStateNormal];
    [self.starButtonThree setBackgroundImage:[UIImage imageNamed:@"rating_star.png"] forState:UIControlStateNormal];
    [self.starButtonFour setBackgroundImage:[UIImage imageNamed:@"rating_star.png"] forState:UIControlStateNormal];
    [self.starButtonFive setBackgroundImage:[UIImage imageNamed:@"rating_star.png"] forState:UIControlStateNormal];
}

- (void)oneStarRating {
    [self.starButtonOne setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
}

- (void)twoStarRating {
    [self.starButtonOne setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
    [self.starButtonTwo setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
}

- (void)threeStarRating {
    [self.starButtonOne setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
    [self.starButtonTwo setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
    [self.starButtonThree setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
}

- (void)fourStarRating {
    [self.starButtonOne setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
    [self.starButtonTwo setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
    [self.starButtonThree setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
    [self.starButtonFour setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
}

- (void)fiveStarRating {
    [self.starButtonOne setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
    [self.starButtonTwo setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
    [self.starButtonThree setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
    [self.starButtonFour setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
    [self.starButtonFive setBackgroundImage:[UIImage imageNamed:@"rating_star_filled.png"] forState:UIControlStateNormal];
}

#pragma mark - animate all

- (void)startAnimation {
    
    POPSpringAnimation *spin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    
    spin.fromValue = @(M_PI / 4);
    spin.toValue = @(5);
    spin.springBounciness = 5;
    spin.velocity = @(1);
    
    [self.starButtonOne.layer pop_addAnimation:spin forKey:nil];
    [self.starButtonTwo.layer pop_addAnimation:spin forKey:nil];
    [self.starButtonThree.layer pop_addAnimation:spin forKey:nil];
    [self.starButtonFour.layer pop_addAnimation:spin forKey:nil];
    [self.starButtonFive.layer pop_addAnimation:spin forKey:nil];
}


#pragma mark - save items


- (IBAction)logToJournalButtonTapped:(id)sender {
    
    JournalPost *journalPost = [[JournalPost alloc]init];
    
    journalPost.postText = self.textView.text;
    journalPost.postSubject = self.postSearchResult;
    
    self.journalPost = journalPost;
    
    [self.journalPostArray addObject:self.journalPost];
                               
    NSLog(@"Journal Post: %@",self.journalPost);
    
    [self.navigationController popToRootViewControllerAnimated:YES];

    [self.tabBarController setSelectedIndex:2]; // send to correct tab
    
}

 #pragma mark - Navigation
 
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//     NSLog(@"Segue");
//     
////     if ([[segue identifier]isEqualToString:@"logToJournalSegue"]) {
////      
////         NSLog(@"Segue to Tab");
////         JournalMainCollectionViewController *viewController = [[JournalMainCollectionViewController alloc]init];
//     
//         TabBarViewController *tabVC = segue.destinationViewController; // this creates a new tab bar
//     
//         JournalMainCollectionViewController *viewController = [[tabVC viewControllers] objectAtIndex:2];
//     
//         //[viewController.allJournalPosts addObjectsFromArray:self.journalPostArray];
//     
//        viewController.journalPostToAdd = self. journalPost;
//        [tabVC setSelectedIndex:2];
//     
//    
// //    }
// }

//locationsHome* vc = [[locationsHome alloc] init];
//UITabBarController* tbc = [segue destinationViewController];
//vc = (locationsHome *)[[tbc customizableViewControllers] objectAtIndex:0];

@end
