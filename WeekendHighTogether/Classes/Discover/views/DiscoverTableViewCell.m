//
//  DiscoverTableViewCell.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/12.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "DiscoverTableViewCell.h"

@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(DiscoverModel *)model{
    self.titleLabel.text = model.title;
    self.titleLabel.numberOfLines = 0;
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.imageview.layer.cornerRadius = self.imageview.frame.size.width / 2;
    self.imageview.clipsToBounds = YES;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
