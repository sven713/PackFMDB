//
//  PersonTableViewCell.h
//  packFMDB
//
//  Created by song ximing on 2016/12/14.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef  <#name#>
@class People;
@interface PersonTableViewCell : UITableViewCell
//@property (nonatomic, strong) UIButton *btn;

//@property (nonatomic, copy) void(^btnClickBlock)(People *);
@property (nonatomic, copy) void(^btnClickBlock)();
@end
