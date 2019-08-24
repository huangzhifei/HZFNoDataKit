//
//  HZFSureTableViewController.h
//  HZFNoDataKit
//
//  Created by huangzhifei on 2019/8/24.
//  Copyright © 2019 eric. All rights reserved.
//

#import "HZFSureTableViewController.h"
#import "UITableView+HZFPlaceholder.h"

@interface HZFSureTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HZFSureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self craeteUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)initData {
    _dataArr = [[NSMutableArray alloc] init];
}

- (void)craeteUI {
    self.title = @"UITableViewPlaceholder";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.hzf_firstReload = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TAB"];
    //模拟刷新操作
    __weak typeof(self) weakSelf = self;
    [self.tableView setHzf_reloadBlock:^{
        [weakSelf refresh];
    }];
    [self.view addSubview:self.tableView];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
}

- (void)refresh {
    //模拟刷新 偶数调用有数据 奇数无数据
    [self.refreshControl beginRefreshing];

    NSLog(@"start loading");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        static NSUInteger i = 0;
        if (i % 2 == 0) {
            NSLog(@"开始加载数据");
            for (NSInteger i = 0; i < arc4random() % 10; i++) {
                [_dataArr addObject:[NSString stringWithFormat:@"随机测试数据 --- %ld", i]];
            }
        } else {
            [_dataArr removeAllObjects];
        }
        i++;
        NSLog(@"i = %ld", i);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [_refreshControl endRefreshing];
            NSLog(@"end loading");
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAB"];
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
