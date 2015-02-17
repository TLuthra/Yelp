//
//  FiltersViewController.m
//  Yelp
//
//  Created by Tanooj Luthra on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "SegmentedCell.h"
#import "RadiusCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, SegmentedCellDelegate, RadiusCellDelegate>

@property (nonatomic, readonly) NSDictionary *filters;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *deals;
@property (nonatomic, assign) NSNumber *selectedRadius;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, assign) BOOL selectedDeals;
@property (nonatomic, assign) NSNumber *selectedSort;
@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [[NSMutableSet alloc] init];
        self.selectedDeals = NO;
        [self initCategories];
        [self initDeals];
        [self initSort];
        [self initRadius];
        self.sections = [[NSArray alloc] initWithObjects:self.categories, self.deals, self.selectedSort, self.selectedRadius, nil];
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onApplyButton)];
    // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonIte target:self action:@selector(onApplyButton)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SegmentedCell" bundle:nil] forCellReuseIdentifier:@"SegmentedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RadiusCell" bundle:nil] forCellReuseIdentifier:@"RadiusCell"];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Categories";
            break;
        case 1:
            sectionName = @"Deal";
            break;
        case 2:
            sectionName = @"Sort Order";
            break;
        case 3:
            sectionName = @"Radius";
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 || section == 0) {
        return ((NSArray *)self.sections[section]).count;
    } else {
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.titleLabel.text = self.sections[indexPath.section][indexPath.row][@"name"];
        cell.on = [self.selectedCategories containsObject:self.sections[indexPath.section][indexPath.row]];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 2) {
        SegmentedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentedCell"];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 3) {
        RadiusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadiusCell"];
        cell.delegate = self;
        return cell;
    } else {
        return nil;
    }
}

-(void)radiusCell:(RadiusCell *)cell didUpdateValue:(NSInteger)value {
    self.selectedRadius = [NSNumber numberWithInteger:value];
}

-(void)segmentedCell:(SegmentedCell *)cell didUpdateValue:(NSInteger)value {
    self.selectedSort = [NSNumber numberWithInteger:value];
}

-(void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        if (value) {
            [self.selectedCategories addObject:self.sections[indexPath.section][indexPath.row]];
        } else {
            [self.selectedCategories removeObject:self.sections[indexPath.section][indexPath.row]];
        }
    } else if (indexPath.section == 1) {
        self.selectedDeals = value;
    }
}

- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    [filters setObject:self.selectedSort forKey:@"sort"];
    
    if (self.selectedDeals) {
        [filters setObject:@1 forKey:@"deals_filter"];
    }
    
    if (self.selectedRadius) {
        [filters setObject:[NSNumber numberWithDouble:([self.selectedRadius doubleValue] / 0.000621371)] forKey:@"radius_filter"];
    }

    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    return filters;
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
    [self.delegate filtersVewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) initCategories {
    self.categories =
    @[
      @{@"name" : @"Barbeque", @"code": @"bbq" },
      @{@"name" : @"Indian", @"code": @"indpak" },
      @{@"name" : @"Italian", @"code": @"italian" },
      @{@"name" : @"Mexican", @"code": @"mexican" },
      @{@"name" : @"Pizza", @"code": @"pizza" },
      @{@"name" : @"Thai", @"code": @"thai" },
      ];
};

- (void) initDeals {
    self.deals = @[@{@"name":@"Offering a deal", @"code":@"true"}];
}

- (void) initSort {
    self.selectedSort = @0;
}

- (void) initRadius {
    self.selectedRadius = @10;
}

@end
