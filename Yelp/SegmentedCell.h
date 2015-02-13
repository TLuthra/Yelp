//
//  SegmentedCell.h
//  Yelp
//
//  Created by Tanooj Luthra on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentedCell;

@protocol SegmentedCellDelegate <NSObject>

- (void)segmentedCell:(SegmentedCell *)cell didUpdateValue:(NSInteger)value;

@end

@interface SegmentedCell : UITableViewCell

@property (nonatomic, weak) id<SegmentedCellDelegate> delegate;

@end
