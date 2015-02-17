//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"0W_HybYw60lws3Wxz52U9w";
NSString * const kYelpConsumerSecret = @"c1sw-y1BUAVUsZCiDr3ZAqyDvD0";
NSString * const kYelpToken = @"x3pnxJ2T_KpeN0c9ajdgSkmE5TbBl7m7";
NSString * const kYelpTokenSecret = @"LgyYWTEBumu4kDCthJCHeEwLDcw";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;

-(void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"Yelp";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""] || searchText == nil) {
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.0];
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];

    }

    return;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar performSelector: @selector(resignFirstResponder)
                    withObject: nil
                    afterDelay: 0.0];

    [self fetchBusinessesWithQuery:searchBar.text params:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar performSelector: @selector(resignFirstResponder)
                    withObject: nil
                    afterDelay: 0.0];
    
    [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
}

-(void)filtersVewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"filters: %@", filters);
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];

}

- (void) onFilterButton {
    FiltersViewController *fvc = [[FiltersViewController alloc] initWithNibName:@"FiltersViewController" bundle:nil];
    fvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    NSLog(@"params: %@", params);
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *businessesDictionaries = response[@"businesses"];
        
        self.businesses = [Business businessesWithDictionaries:businessesDictionaries];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];

}

@end
