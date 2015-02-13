//
//  SegmentedCell.m
//  Yelp
//
//  Created by Tanooj Luthra on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SegmentedCell.h"

@interface SegmentedCell ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentDidChange:(UISegmentedControl *)sender;

@end

@implementation SegmentedCell
- (IBAction)segmentDidChange:(UISegmentedControl *)sender {
    NSLog(@"segment id dchange");
    [self.delegate segmentedCell:self didUpdateValue:sender.selectedSegmentIndex];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
