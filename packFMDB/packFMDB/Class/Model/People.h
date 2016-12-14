//
//  People.h
//  packFMDB
//
//  Created by song ximing on 2016/12/12.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject
@property (nonatomic, copy) NSString *ID; //!<删除要用到 跟car的 own_id关联
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger updateTime; //!<第几次更新
@end
