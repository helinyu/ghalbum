//
//  YDBaseTableViewCell.m
//  SportsBar
//
//  Created by Aka on 2017/10/31.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDBaseTableViewCell.h"

@implementation YDBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    
}

@end
