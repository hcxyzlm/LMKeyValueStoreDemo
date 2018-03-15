//
//  LMKeyValueDemoTabVC.m
//  LMKeyValueStoreDemo
//
//  Created by zhuo on 2018/3/15.
//  Copyright © 2018年 zhuo. All rights reserved.
//

#import "LMKeyValueDemoTabVC.h"
#import "LMKeyValueDemoTabVCModel.h"

@interface LMKeyValueDemoTabVC ()

@property (nonatomic, strong) LMKeyValueDemoTabVCModel *vcModel; //vcmodel

@end

@implementation LMKeyValueDemoTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vcModel = [[LMKeyValueDemoTabVCModel alloc] init];
    [self.vcModel loadDataWithSuccessCacheBlock:^(NSArray *list, id vcModel) {
        [self.tableView reloadData];
    } failure:^(NSError *error, id vcModel) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vcModel.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.vcModel.titles objectAtIndex:indexPath.row];
    
    return cell;
}

@end
