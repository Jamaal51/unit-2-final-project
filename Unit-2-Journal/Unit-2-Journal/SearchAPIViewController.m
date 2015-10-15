//
//  SearchAPIViewController.m
//  Unit-2-Journal
//
//  Created by Shena Yoshida on 10/10/15.
//  Copyright © 2015 Jamaal Sedayao. All rights reserved.
//

#import "SearchAPIViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "APIManager.h"
#import "iTunesSearchResult.h"
#import "CreateJournalEntryViewController.h"
#import "SearchAPITableViewCell.h" // add custom cell
#import "TabBarViewController.h"
#import "WishListTableViewController.h"
//#import <pop/POP.h>


@interface SearchAPIViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *musicButton;
@property (strong, nonatomic) IBOutlet UIButton *moviesButton;
@property (strong, nonatomic) IBOutlet UIButton *booksButton;
@property (strong, nonatomic) IBOutlet UIButton *podcastButton;
@property (strong, nonatomic) IBOutlet UIButton *televisionButton;
@property (nonatomic) NSString *media;
@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) iTunesSearchResult *passSearchResult;

@end

@implementation SearchAPIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchTextField.delegate = self;
    
    // set up custom cell .xib
    UINib *nib = [UINib nibWithNibName:@"SearchAPITableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SearchAPITableViewCellIdentifier"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 35.0;
    
}

#pragma mark - setup buttons

- (IBAction)mediaButtonTypeSelected:(id)sender {
    
    if (self.musicButton.isTouchInside){
        self.media = @"music&entity=album";

    } else if (self.booksButton.isTouchInside){
        self.media = @"ebook";
        
    } else if (self.televisionButton.isTouchInside){
        self.media = @"television";
    } else {
        self.media = [sender currentTitle];
    }
    
    NSLog(@"Media: %@",self.media);
}

#pragma mark - add to list buttons

- (IBAction)createJournalEntryButtonTapped:(id)sender {

}

- (IBAction)addToWishListButtonTapped:(id)sender {
    
    WishListTableViewController *viewController = [[WishListTableViewController alloc]init];
    viewController.searchResult = self.passSearchResult;

    [self.tabBarController setSelectedIndex:0];
    
}

#pragma mark - API request

- (void) makeNewAPIRequestWithSearchTerm:(NSString *)term
                                       inMedia:(NSString *)media{
 
    self.searchResults = [[NSMutableArray alloc]init];
    
//First API Request - iTunes (music, ebooks, podcast)
    
    NSString *urlString = [NSString stringWithFormat:
                           @"https://itunes.apple.com/search?media=%@&term=%@",media,term];
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodedString];
    
    [APIManager GETRequestWithURL:url
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    
                    if (data != nil){
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        //NSLog(@"%@",json);
                        
                        NSArray *results = [json objectForKey:@"results"];
                        
                        NSLog(@"iTunes Results: %@",results);
                        
                        for (NSDictionary *result in results){
                            
                            NSString *artistName = [result objectForKey:@"artistName"];
                            NSString *albumName = [result objectForKey:@"collectionName"];
                            NSString *movieName = [result objectForKey:@"trackName"];
                            NSString *artworkURL =  [result objectForKey:@"artworkUrl100"];
                            
                            iTunesSearchResult *resultsObject = [[iTunesSearchResult alloc]init];
                            
                            if ([self.media isEqualToString:@"podcast"] || [self.media isEqualToString:@"movie"]){
                                resultsObject.artistName = artistName;
                                resultsObject.albumOrMovieName = movieName;
                                resultsObject.artworkURL = artworkURL;
                            } else if ([self.media isEqualToString:@"music&entity=album"]){
                                resultsObject.artistName = artistName;
                                resultsObject.albumOrMovieName = albumName;
                                resultsObject.artworkURL = artworkURL;
                            } else if ([self.media isEqualToString:@"ebook"]){
                                resultsObject.artistName = artistName;
                                resultsObject.albumOrMovieName = movieName;
                                resultsObject.artworkURL = artworkURL;
                            }
                            
                            [self.searchResults addObject:resultsObject];
                        }
                        [self.tableView reloadData];
                    }}];
    
//Second API Request - for television
   
    NSString *urlStringTwo = [NSString stringWithFormat:@"http://api.tvmaze.com/search/shows?q=%@",term];
    NSString *encodedStringTwo = [urlStringTwo stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *urlTwo = [NSURL URLWithString:encodedStringTwo];
    
    [APIManager GETRequestWithURL:urlTwo
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    if (data != nil){
                        NSArray *jsonTwo = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        NSLog(@"TV results: %@",jsonTwo);
                        
                        NSDictionary *shows = [jsonTwo valueForKey:@"show"];
                        
                        for (NSDictionary *show in shows){
                            
                            NSString *name = [show valueForKey:@"name"];
                            NSArray *image = [show valueForKey:@"image"];
                            NSString *imageURL = [image valueForKey:@"medium"];
                            NSArray *network = [show valueForKey:@"network"];
                            NSString *channel = [network valueForKey:@"name"];
                            
                            if ([self.media isEqualToString:@"television"]){
                                
                                iTunesSearchResult *searchResult = [[iTunesSearchResult alloc]init];
                                searchResult.artistName = channel;
                                searchResult.albumOrMovieName = name;
                                searchResult.artworkURL = imageURL;
                                
                                [self.searchResults addObject:searchResult];
                                
                            }
                        }
                    }
                    [self.tableView reloadData];
                }];
    
//Third API Request - for movies, including in-theatre

// https://api.themoviedb.org/3/search/movie?api_key=a958839150c7c7c6333fd335128ea066&query=django

    
    NSString *urlStringThree = [NSString stringWithFormat:@"https://api.themoviedb.org/3/search/%@?api_key=a958839150c7c7c6333fd335128ea066&query=%@",media,term];
    
    NSString *encodedStringThree = [urlStringThree stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"Movie String: %@",encodedStringThree);
    
    NSURL *urlThree = [NSURL URLWithString:encodedStringThree];

    [APIManager GETRequestWithURL:urlThree
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    if (data != nil){
                        NSArray *jsonThree = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        NSDictionary *results = [jsonThree valueForKey:@"results"];
                        
                        NSLog(@"Movie Results: %@",results);
                        
                        for (NSDictionary *result in results){
                            
                            NSString *name = [result valueForKey:@"title"];
                            NSString *releaseDate = [result valueForKey:@"release_date"];
                            NSString *posterPath = [result valueForKey:@"poster_path"];
                            
                            //http://image.tmdb.org/t/p/w500
                            
                            if ([self.media isEqualToString:@"movie"]){

                               iTunesSearchResult *movieResult = [[iTunesSearchResult alloc]init];
                                
                                movieResult.albumOrMovieName = name;
                                movieResult.artistName = releaseDate;
                                movieResult.artworkURL = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@",posterPath];
                                
                                [self.searchResults addObject:movieResult];
                                
                            }
                            
                            [self.tableView reloadData];
                            
                        }
                        
                    }
                   
                }];
    }

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    [self makeNewAPIRequestWithSearchTerm:textField.text
                                        inMedia:self.media];

        
    return YES;
}

#pragma mark - set up table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchAPITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchAPITableViewCellIdentifier" forIndexPath:indexPath];
   
    iTunesSearchResult *searchResult = self.searchResults[indexPath.row];
    
    cell.titleLabel.text = searchResult.albumOrMovieName;
    cell.authorArtistDirectorLabel.text = searchResult.artistName;
    
    NSString *artworkString = searchResult.artworkURL;
    NSURL *artworkURL = [NSURL URLWithString:artworkString];
    NSData *artworkData = [NSData dataWithContentsOfURL:artworkURL];
    UIImage *artworkImage = [UIImage imageWithData:artworkData];
    
//    NSLog(@"Image String: %@", searchResult.artworkURL);
//    NSLog(@"Image URL: %@", artworkURL);
//    NSLog(@"Image Data: %@", artworkData);
//    NSLog(@"Image: %@", artworkImage);
    
    cell.artworkImage.image = artworkImage;
    
    // round corners
    cell.imageView.layer.borderWidth = 2.0;
    cell.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    cell.imageView.layer.cornerRadius = 3.0;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    iTunesSearchResult *searchResult = self.searchResults[indexPath.row];
    
    self.passSearchResult = searchResult;

    NSLog(@"%@", self.passSearchResult);
    
    // push view controller 
    
}

 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
     if ([[segue identifier]isEqualToString:@"pushToCreateJournalEntry"]) {
     
         NSLog(@"segue");

     CreateJournalEntryViewController *viewController = segue.destinationViewController;
     viewController.postSearchResult = self.passSearchResult;
         
     }
     
 }



@end
