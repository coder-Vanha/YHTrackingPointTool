//
//  YHCellDisPlayHandler.m
//  YHTrackingPointTool-Example
//
//  Created by Vanha on 2020/7/8.
//  Copyright © 2020 wanwan. All rights reserved.
//

#import "YHCellDisPlayHandler.h"

typedef NS_ENUM(NSInteger, BBCMSCellDisplayState)
{
    BBCMSCellDisplayStateNone,
    BBCMSCellDisplayStateWillDispalay,
    BBCMSCellDisplayStateInDispalay,
};


@interface BBCMSCellDisplayControlModel : NSObject

@property (nonatomic, strong)   NSIndexPath   * s_indexPath;
@property (nonatomic, weak)     UIView        * s_displayCell;

@property (nonatomic, assign)   NSInteger       s_cellDisplayState;
@property (nonatomic, assign)   NSTimeInterval  s_startDisplayTime;

@end


@implementation BBCMSCellDisplayControlModel
@end


@interface YHCellDisPlayHandler ()

@property (nonatomic, strong)   NSMutableArray    * s_displayControlItems;

@end

@implementation YHCellDisPlayHandler

- (instancetype)init
{
    if (self = [super init])
    {
        _s_displayControlItems = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}



- (void)bbcms_delegateWillDisplayCell:(UIView *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBCMSCellDisplayControlModel *cellItem;
    for (NSInteger i=0; i < self.s_displayControlItems.count; i++)
    {
        BBCMSCellDisplayControlModel * tempCellItem = [self.s_displayControlItems objectAtIndex:i];
        if (tempCellItem.s_indexPath.section == indexPath.section &&
            tempCellItem.s_indexPath.row == indexPath.row &&
            [NSStringFromClass(cell.class) isEqualToString:NSStringFromClass(tempCellItem.s_displayCell.class)])
        {
            cellItem = tempCellItem;
            
            break;
        }
    }
    if (!cellItem)
    {
        cellItem = [[BBCMSCellDisplayControlModel alloc]init];
        cellItem.s_indexPath = indexPath;
    }
    
    
    if  ( [self.s_displayControlItems containsObject:cellItem] && cellItem.s_cellDisplayState != BBCMSCellDisplayStateNone)
    {
        // do nothing,continue.
    }
    else
    {
        if (self.m_displayBlock)
        {
            self.m_displayBlock(cellItem.s_indexPath);
        }
        
        cellItem.s_cellDisplayState = BBCMSCellDisplayStateWillDispalay;
        cellItem.s_displayCell = cell;
        if (cellItem) {
             [self.s_displayControlItems addObject:cellItem];
        }
    }
    
    [self resetCellItemState4BeginExposing:cellItem];
}

- (void)resetCellItemState4BeginExposing:(BBCMSCellDisplayControlModel *)cellItem {
    
    if ([YHCellDisPlayHandler bbcms_isDisplayedInScreen:cellItem.s_displayCell]) {
        cellItem.s_cellDisplayState = BBCMSCellDisplayStateInDispalay;
        cellItem.s_startDisplayTime =  [[NSDate date] timeIntervalSince1970] * 1000 ;
    }
}

- (void)bbcms_scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self s_handleDurationBIData];
}

- (void)bbcms_uploadAllVisableItems
{
    [self s_uploadAllVisableBIData];
}


- (void)noti_applicationEnterBackground
{
    [self s_uploadAllVisableBIData];
}


#pragma mark - 停留 BIData
- (void)s_handleDurationBIData
{
    NSMutableArray *removeIndexs;
    
    for (NSInteger i = 0; i < self.s_displayControlItems.count; i++)
    {
        BBCMSCellDisplayControlModel *cellItem = [self.s_displayControlItems objectAtIndex:i];
        
        switch (cellItem.s_cellDisplayState)
        {
            case BBCMSCellDisplayStateNone:
            {
                if (!removeIndexs)
                {
                    removeIndexs = [NSMutableArray array];
                }
                [removeIndexs addObject:@(i)];
            }
                break;
                
                
            case BBCMSCellDisplayStateWillDispalay:
            {
                if (!cellItem.s_displayCell)
                {
                    if (!removeIndexs)
                    {
                        removeIndexs = [NSMutableArray array];
                    }
                    [removeIndexs addObject:@(i)];
                }
                else
                {
                    if ([YHCellDisPlayHandler bbcms_isDisplayedInScreen: cellItem.s_displayCell])
                    {
                        cellItem.s_cellDisplayState = BBCMSCellDisplayStateInDispalay;
                        cellItem.s_startDisplayTime =  [[NSDate date] timeIntervalSince1970] * 1000 ;
                    }
                    else
                    {
                        // not showed, do nothing
                    }
                }
            }
                break;
                
            case BBCMSCellDisplayStateInDispalay:
            {
                if (!cellItem.s_displayCell)
                {
                    //曝光结束
                    
                    if (!removeIndexs)
                    {
                        removeIndexs = [NSMutableArray array];
                    }
                    [removeIndexs addObject:@(i)];
                    
                    if (self.m_durationBlock)
                    {
                        NSString * duration = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000 - cellItem.s_startDisplayTime];
                        
                        self.m_durationBlock(cellItem.s_indexPath, duration);
                        
                        cellItem.s_startDisplayTime = 0;
                        cellItem.s_cellDisplayState = BBCMSCellDisplayStateNone;
                        cellItem.s_indexPath = nil;
                        cellItem.s_displayCell = nil;
                    }
                }
                else
                {
                    if ([YHCellDisPlayHandler bbcms_isDisplayedInScreen:cellItem.s_displayCell])
                    {
                        // 曝光中 continue
                    }
                    else
                    {
                        // 曝光结束
                        
                        if (!removeIndexs)
                        {
                            removeIndexs = [NSMutableArray array];
                        }
                        [removeIndexs addObject:@(i)];
                        
                        
                        if (self.m_durationBlock)
                        {
                            NSString * duration = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000 - cellItem.s_startDisplayTime];
                            
                            self.m_durationBlock(cellItem.s_indexPath, duration);
                            
                            cellItem.s_startDisplayTime = 0;
                            cellItem.s_cellDisplayState = BBCMSCellDisplayStateNone;
                            cellItem.s_indexPath = nil;
                            cellItem.s_displayCell = nil;
                        }
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    if (removeIndexs.count > 0)
    {
        for (NSInteger i = removeIndexs.count-1; i >= 0 ; i--)
        {
            BBCMSCellDisplayControlModel *cellItem = [self.s_displayControlItems objectAtIndex: [[removeIndexs objectAtIndex:i] integerValue]];
            
            cellItem.s_startDisplayTime = 0;
            cellItem.s_cellDisplayState = BBCMSCellDisplayStateNone;
            cellItem.s_indexPath = nil;
            cellItem.s_displayCell = nil;
            [self.s_displayControlItems removeObjectAtIndex:[[removeIndexs objectAtIndex:i] integerValue]];
        }
    }
}


- (void)s_uploadAllVisableBIData
{
    for (NSInteger i = 0; i < self.s_displayControlItems.count; i++)
    {
        BBCMSCellDisplayControlModel *cellItem = [self.s_displayControlItems objectAtIndex:i];
        if (cellItem.s_cellDisplayState == BBCMSCellDisplayStateInDispalay)
        {
            if (cellItem.s_startDisplayTime > 0)
            {
                if (self.m_durationBlock)
                {
                    NSString * duration = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000 - cellItem.s_startDisplayTime];
                    
                    self.m_durationBlock(cellItem.s_indexPath, duration);
                }
            }
        }
    }
    
    [self.s_displayControlItems removeAllObjects];
}




#pragma Utils methods


+ (BOOL)bbcms_isDisplayedInScreen:(UIView *)view
{
    if (view == nil)
    {
        return NO;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:view.bounds fromView:view];
    
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect))
    {
        return NO;
    }
    
    
    if (view.hidden)
    {
        return NO;
    }
    
    
    if (view.superview == nil)
    {
        return NO;
    }
    
    if (CGSizeEqualToSize(rect.size, CGSizeZero))
    {
        return  NO;
    }
    
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect))
    {
        return NO;
    }
    
    return YES;
}


@end
