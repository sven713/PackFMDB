//
//  AddPersonViewController.m
//  packFMDB
//
//  Created by song ximing on 2016/12/12.
//  Copyright © 2016年 song ximing. All rights reserved.
//  http://www.jianshu.com/p/54e74ce87404#
// http://www.jianshu.com/p/54e74ce87404

#import "AddPersonViewController.h"
#import "People.h"
#import "PersonCarDataBaseHelper.h"
#import "CarPortTableViewController.h"
#import "AllCarPortTableViewController.h"
#import "PersonTableViewCell.h"

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"停车场" style:UIBarButtonItemStyleDone target:self action:@selector(carPort)];
    
    self.peopleArray = [[PersonCarDataBaseHelper shareInstance] getPersonArray];
    [self.tableView reloadData];
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
    AllCarPortTableViewController *vc = [AllCarPortTableViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1))); // ??????
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peopleArray.count;
}

//static UIButton *btn;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPersonViewControllerCell"];
    if (!cell) {
        cell = [[PersonTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AddPersonViewControllerCell"];
    }
    
    People *person = self.peopleArray[indexPath.row];
//    [cell.btn addTarget:self action:@selector(editeAlertWithModel:) forControlEvents:UIControlEventTouchUpInside];
//    __weak typeof self(weakSelf) = self;
    __weak typeof(self)weakSelf = self;
//    cell.btnClickBlock = ^(People *people){
//        [weakSelf editeAlertWithModel:people];
//    };
    cell.btnClickBlock = ^(){
        [weakSelf editeAlertWithModel:person];
    };
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"年龄:%td",person.age];
    if (person.updateTime > 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"第%td次更新,年龄:%td",person.updateTime,person.age];
    }
    return cell;
}

- (void)editeAlertWithModel:(People *)person {
    person.age = arc4random_uniform(100);
    [[PersonCarDataBaseHelper shareInstance] updatePerson:person];
    self.peopleArray = [[PersonCarDataBaseHelper shareInstance] getPersonArray];
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CarPortTableViewController *carPort = [[CarPortTableViewController alloc]init];
    carPort.person = self.peopleArray[indexPath.row];
    [self.navigationController pushViewController:carPort animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除操作 从数据库删除一条数据
        People *person = self.peopleArray[indexPath.row];
        [[PersonCarDataBaseHelper shareInstance] deletePerson:person];
        // 获取全部数据赋值给数据源
//        [self.peopleArray removeAllObjects];
        self.peopleArray = [[PersonCarDataBaseHelper shareInstance]getPersonArray];
        // 刷新
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else {
    
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
