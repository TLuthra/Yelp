//
//  SwitchCell.h
//  Yelp
//
//  Created by Tanooj Luthra on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) id<SwitchCellDelegate> delegate;
@property (nonatomic, assign) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL) animated;
@end
