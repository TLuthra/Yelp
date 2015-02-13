//
//  SwitchCell.m
//  Yelp
//
//  Created by Tanooj Luthra on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell ()
@property (strong, nonatomic) IBOutlet UISwitch *toggleSwitch;
- (IBAction)switchValueChanged:(UISwitch *)sender;

@end

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.toggleSwitch setOnTintColor:[[[UIApplication sharedApplication] delegate] window].tintColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL) animated {
    _on = on;
    [self.toggleSwitch setOn:on animated:animated];
}


- (IBAction)switchValueChanged:(UISwitch *)sender {
    [self.delegate switchCell:self didUpdateValue:self.toggleSwitch.on];
}

@end
