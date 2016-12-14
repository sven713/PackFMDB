//
//  TwoTableQueryTableViewController.m
//  packFMDB
//
//  Created by song ximing on 2016/12/14.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import "TwoTableQueryTableViewController.h"
#import "TwoTableModel.h"

@interface TwoTableQueryTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TwoTableQueryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI {
    self.title = @"查询结果";
    [self transferArrayToModel];
}

- (void)transferArrayToModel {
    self.dataArray = [NSMutableArray array];
    for (NSDictionary *dict in self.arrayDict) {
        TwoTableModel *model = [[TwoTableModel alloc]init];
        model.car_brand = [dict objectForKey:@"car_brand"];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"TwoTableQueryTableViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    TwoTableModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.car_brand;
    return cell;
}

@end
