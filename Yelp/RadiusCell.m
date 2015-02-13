//
//  RadiusCell.m
//  Yelp
//
//  Created by Tanooj Luthra on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "RadiusCell.h"


@interface RadiusCell ()

@property (strong, nonatomic) IBOutlet UISlider *radiusSlider;
@property (strong, nonatomic) IBOutlet UILabel *radiusLabel;

- (IBAction)valueDidChange:(UISlider *)sender;

@end


@implementation RadiusCell

- (void)awakeFromNib {
    // Initialization code
    float milesPerMeter = 0.000621371;
    float miles = self.radiusSlider.value * milesPerMeter;
    
    NSNumber *myNumber = [NSNumber numberWithDouble:miles];
    NSInteger myInt = [myNumber intValue];
    
    
    self.radiusLabel.text = [NSString stringWithFormat:@"%ld mi", (long)myInt];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)valueDidChange:(UISlider *)sender {
    float milesPerMeter = 0.000621371;
    float miles = sender.value * milesPerMeter;
    
    NSNumber *myNumber = [NSNumber numberWithDouble:miles];
    NSInteger myInt = [myNumber intValue];

    
    self.radiusLabel.text = [NSString stringWithFormat:@"%ld mi", (long)myInt];
    [self.delegate radiusCell:self didUpdateValue:myInt];
}

@end
