//
//  AllCarPortTableViewController.m
//  packFMDB
//
//  Created by song ximing on 2016/12/13.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import "AllCarPortTableViewController.h"
#import "PersonCarDataBaseHelper.h"
#import "People.h"
#import "Car.h"

@interface AllCarPortTableViewController ()
@property (nonatomic, strong) NSMutableArray *peopleArray; //!<人数组
@property (nonatomic, strong) NSMutableArray *carArray; //!<车数组
@end

@implementation AllCarPortTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI {
    self.title = @"停车场";
    [self getAllData];
}

- (void)getAllData {
    self.peopleArray = [[PersonCarDataBaseHelper shareInstance]getPersonArray];
    self.carArray = [NSMutableArray array];
    for (People *person in self.peopleArray) {
        NSArray *arr = [[PersonCarDataBaseHelper shareInstance]getCarFromPerson:person];
        [self.carArray addObject:arr];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.peopleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *carArr = self.carArray[section];
    return carArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"AllCarPortTableViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    NSArray *carArr = self.carArray[indexPath.section];
    Car *car = carArr[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"牌子:%@",car.brand];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"价格: %td",car.price];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    People *person = self.peopleArray[section];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    label.text = [NSString stringWithFormat:@"%@ 所有的的车",person.name];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]; // 242  直接写个数不行,是小于1的数
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除
        NSArray *carArr = self.carArray[indexPath.section];
        Car *car = carArr[indexPath.row];
        People *person = self.peopleArray[indexPath.section];
        [[PersonCarDataBaseHelper shareInstance]deletCar:car owner:person];
        
        // 获取数据,刷新数据源
        [self getAllData];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
