//
//  AddPersonViewController.m
//  packFMDB
//
//  Created by song ximing on 2016/12/12.
//  Copyright © 2016年 song ximing. All rights reserved.
//  http://www.jianshu.com/p/54e74ce87404#

#import "AddPersonViewController.h"
#import "People.h"
#import "PersonCarDataBaseHelper.h"

@interface AddPersonViewController ()
@property (nonatomic, strong) NSMutableArray<People *> *peopleArray; //!<人数据源
@end

@implementation AddPersonViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = self.editButtonItem; // 系统的编辑按钮
    [self configUI];
}

#pragma mark - UI
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加两个按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加人名" style:UIBarButtonItemStylePlain target:self action:@selector(addPeopleName)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"车库" style:UIBarButtonItemStyleDone target:self action:@selector(carPort)];
}

#pragma mark - 点击事件
- (void)addPeopleName {
    People *people = [[People alloc]init];
    people.age = (NSInteger)[self getRandomNumber:25 to:100];
    
    people.name = [NSString stringWithFormat:@"person_%d号",[self getRandomNumber:1 to:1000]];
    
    [[PersonCarDataBaseHelper shareInstance]addPerson:people]; // 向数据库插入模型数据
    
    // 读取数据库文件,更新数据模型
    self.peopleArray = [[PersonCarDataBaseHelper shareInstance] getPersonArray];
    [self.tableView reloadData];
}

- (void)carPort {
    
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1))); // ??????
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peopleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPersonViewControllerCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddPersonViewControllerCell"];
    }
    People *person = self.peopleArray[indexPath.row];
    cell.textLabel.text = person.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
