//
//  YHCellDisPlayHandler.h
//  YHTrackingPointTool-Example
//
//  Created by Vanha on 2020/7/8.
//  Copyright © 2020 wanwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BBCMSCellDisplayBlock)(NSIndexPath *indexPath);
typedef void(^BBCMSCellDurationBlock)(NSIndexPath *indexPath, NSString *durationStr);


/*
    控制Cell曝光、停留的工具类， 避免TableView CollectionView reloadData引起的重复曝光 
 
    使用方法：
    1、TableView CollectionView 的DataSource 通常是VC， 持有属性  @property (nonatomic, strong) BBCMSCellDisplayManager    * s_CellDisplayManager;
    2、在ViewDidLoad初始化
            self.s_CellDisplayManager = [BBCMSCellDisplayManager new];
 
            self.s_CellDisplayManager.m_displayBlock = ^(NSIndexPath * _Nonnull indexPath) {
                    //TODO:Cell曝光的埋点
            };
 
            self.s_CellDisplayManager.m_durationBlock = ^(NSIndexPath * _Nonnull indexPath, NSString * _Nonnull durationStr) {
                    //TODO:Cell停留时时长的埋点
            };
 
    3、在willDisplayCell 写入       [self.s_CellDisplayManager bbcms_delegateWillDisplayCell:cell forRowAtIndexPath:indexPath];
    4、在scrollViewDidScroll 写入   [self.s_CellDisplayManager bbcms_scrollViewDidScroll:scrollView];
    5、在 页面退出消失 \ 容器View释放  \ 第一页数据加载之前（下拉刷新） 的地方增加  [self.s_CellDisplayManager bbcms_uploadAllVisableItems];
 
    PS、manager内部已监听App进入后台的通知，不需要外部处理
 */

@interface YHCellDisPlayHandler : NSObject

@property (nonatomic, copy) BBCMSCellDisplayBlock   m_displayBlock;
@property (nonatomic, copy) BBCMSCellDurationBlock  m_durationBlock;


- (void)bbcms_delegateWillDisplayCell:(UIView *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)bbcms_scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)bbcms_uploadAllVisableItems;

@end

NS_ASSUME_NONNULL_END
