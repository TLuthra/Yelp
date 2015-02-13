//
//  RadiusCell.h
//  Yelp
//
//  Created by Tanooj Luthra on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadiusCell;

@protocol RadiusCellDelegate <NSObject>

- (void)radiusCell:(RadiusCell *)cell didUpdateValue:(NSInteger)value;

@end


@interface RadiusCell : UITableViewCell
@property (nonatomic, weak) id<RadiusCellDelegate> delegate;

@end
