//
//  ViewController.m
//  jsonParser
//
//  Created by mac on 6/6/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *mDatasources;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self test1];
    [self test2];
}

- (void)test2 {
    _mDatasources = @[].mutableCopy;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor redColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    for (NSInteger index=0; index <100; index++) {
        [_mDatasources addObject:@(index)];
        [_tableView reloadData];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger index=0; index <100; index++) {
            [_mDatasources addObject:@(index)];
            [_tableView reloadData];
        }
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    if (indexPath.row %2 ==1) {
        cell.backgroundColor = [UIColor yellowColor];
    }
    else {
        cell.backgroundColor = [UIColor greenColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mDatasources.count;
}

- (void)test1 {
    NSString *string0 = @"sdfasfd";
    NSLog(@"gh- kind :%zd, meber of :%zd, subclass :%zd",[string0 isKindOfClass:[NSString class]], [string0 isMemberOfClass:[NSString class]], [string0 isKindOfClass:[NSString class]]);
}

- (void)test0 {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.json" ofType:nil];
    NSLog(@"gh- path:%@",path);
    NSError *error = nil;
    NSString *jsonStrinng = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"erroro :%@",jsonStrinng);
    NSData *jsonData = [jsonStrinng dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDic1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"result dic: %@",resultDic1.description);
    
    
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:resultDic1 options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
    NSLog(@"gh- json string; %@",jsonStr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
