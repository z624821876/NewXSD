//
//  OrderStatusView.h
//  newshop
//
//  Created by 于洲 on 15/5/13.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusView : UIView<UITableViewDataSource,UITableViewDelegate>
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) UIButton          *statusBtn;

- (void)setDataArray:(NSMutableArray *)dataArray;


@end
