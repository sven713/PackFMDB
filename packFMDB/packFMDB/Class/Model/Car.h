//
//  Car.h
//  packFMDB
//
//  Created by song ximing on 2016/12/13.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Car : NSObject
@property (nonatomic, copy) NSString *brand; //!<品牌
@property (nonatomic, assign) NSInteger price; //!<价格
@property (nonatomic, copy) NSString *own_id;
@end
