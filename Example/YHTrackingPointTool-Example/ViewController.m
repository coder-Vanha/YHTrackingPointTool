//
//  ViewController.m
//  YHTrackingPointTool-Example
//
//  Created by Vanha on 2020/7/8.
//  Copyright © 2020 wanwan. All rights reserved.
//

#import "ViewController.h"
#import "YHCellDisPlayHandler.h"

@interface ViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YHCellDisPlayHandler *cellDisplayHandler;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellDisplayHandler = [YHCellDisPlayHandler new];
    self.cellDisplayHandler.m_displayBlock = ^(NSIndexPath * _Nonnull indexPath) {
        // 埋点
        NSLog(@"曝光----%ld",(long)indexPath.row);
        
    };
    
    self.cellDisplayHandler.m_durationBlock = ^(NSIndexPath * _Nonnull indexPath, NSString * _Nonnull durationStr) {
        // 埋点
        NSLog(@"停留----%ld",(long)indexPath.row);
    };
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
     cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.cellDisplayHandler bbcms_scrollViewDidScroll:scrollView];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.cellDisplayHandler bbcms_delegateWillDisplayCell:cell forRowAtIndexPath:indexPath];
}



@end
