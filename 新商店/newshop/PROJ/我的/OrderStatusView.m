//
//  OrderStatusView.m
//  newshop
//
//  Created by 于洲 on 15/5/13.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "OrderStatusView.h"
#import "StatusModel.h"

#define CELL_WIDHT 80

@implementation OrderStatusView


- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
    CGRect rect = _tableView.frame;
    rect.size.height = 80 * [_dataArray count];
    self.tableView.frame = rect;
    _statusBtn.frame = CGRectMake(20, _tableView.bottom, UI_SCREEN_WIDTH - 40, 35);
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, _statusBtn.bottom + 50)];
    
    _statusBtn.tag = [_dataArray count];
    switch ([_dataArray count]) {
        case 2:
        {
            [_statusBtn setTitle:@"去付款" forState:UIControlStateNormal];
        }
            break;
        case 3:
        case 4:
        case 5:
        {
            [_statusBtn setTitle:@"等待商家发货" forState:UIControlStateNormal];
        }
            break;
        case 6:
        {
            StatusModel *model = [_dataArray lastObject];
            if ([model.status integerValue] >= 0) {
                [_statusBtn setTitle:@"订单完成" forState:UIControlStateNormal];
            }else {
                [_statusBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                _statusBtn.tag = 10086;

            }
        }
            break;


            
        default:
            break;
    }
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_scrollView];
        
        self.dataArray = [NSMutableArray array];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, _scrollView.width, CELL_WIDHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [UIView new];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
    
        [_scrollView addSubview:_tableView];
        
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.frame = CGRectMake(20, _tableView.bottom, UI_SCREEN_WIDTH - 40, 35);
        _statusBtn.backgroundColor = [UIColor redColor];
        [_statusBtn setTitle:@"请稍候" forState:UIControlStateNormal];
        _statusBtn.layer.cornerRadius = 10;
        _statusBtn.layer.masksToBounds = YES;
        [_scrollView addSubview:_statusBtn];
        [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, _statusBtn.bottom + 50)];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 40, 40)];
        logo.tag = 10;
        [cell.contentView addSubview:logo];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(logo.left + 19, logo.bottom, 2, 40)];
        lineView.backgroundColor = [UIColor redColor];
        lineView.tag = 11;
        [cell.contentView addSubview:lineView];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(logo.right + 15, logo.top + 10, UI_SCREEN_WIDTH - logo.right - 25, 20)];
        lable.tag = 12;
        lable.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lable];
    }
    StatusModel *model = _dataArray[indexPath.row];
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:10];
    [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"xsdOrderStatus%@.png",model.status]]];
    UIView *line = (UIView *)[cell.contentView viewWithTag:11];
    if (indexPath.row == [_dataArray count] - 1) {
        line.hidden = YES;
    }else {
        line.hidden = NO;
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:12];
    label.text = [NSString stringWithFormat:@"%@   %@",model.time,model.content];
    
    
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
