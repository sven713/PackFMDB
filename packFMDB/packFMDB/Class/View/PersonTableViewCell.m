
//
//  PersonTableViewCell.m
//  packFMDB
//
//  Created by song ximing on 2016/12/14.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(125, 5, 80, 30);
    [self.contentView addSubview:btn];
    [btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"更新年龄" forState:UIControlStateNormal];
    
}

- (void)clickAction {
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}

@end
