
//
//  CarPortTableViewController.m
//  packFMDB
//
//  Created by song ximing on 2016/12/13.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import "CarPortTableViewController.h"
#import "People.h"
#import "Car.h"
#import "PersonCarDataBaseHelper.h"

@interface CarPortTableViewController ()
@property (nonatomic, strong) NSMutableArray *carArray;
@end

@implementation CarPortTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI {
    self.title = [NSString stringWithFormat:@"%@的车库",self.person.name];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"买车" style:UIBarButtonItemStylePlain target:self action:@selector(addCar)];
    self.carArray = [[PersonCarDataBaseHelper shareInstance]getCarFromPerson:self.person];
}

- (void)addCar {
    // 创建model
    NSArray *brandNameArr = @[@"大众",@"宝马",@"奔驰",@"奥迪",@"保时捷",@"兰博基尼"];
    Car *car = [[Car alloc]init];
    car.brand = [brandNameArr objectAtIndex:arc4random_uniform((int)brandNameArr.count)];
    car.price = arc4random_uniform(1000000); // 随机
    car.own_id = self.person.ID;
    
    // 数据库插入car
    [[PersonCarDataBaseHelper shareInstance] addCar:car toPerson:self.person];
    
    // 获取现在的数据,刷新Table
    self.carArray = [[PersonCarDataBaseHelper shareInstance]getCarFromPerson:self.person];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.carArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CarPortTableViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    Car *car = self.carArray[indexPath.row];
    cell.textLabel.text = car.brand;
    return cell;
}

@end
