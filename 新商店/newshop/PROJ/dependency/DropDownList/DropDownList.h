#import <UIKit/UIKit.h>

/*
 1、修复iOS 6会显示软键盘问题
 2、修复空数据时无法隐藏的问题
 */

@class DropDownList;

@protocol DropDownListDelegate
@optional
-(void)ddlValueChangedCallBack:(DropDownList *)sender;
@end

@interface DropDownList : UIView <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tv;        // 下拉列表
    NSArray *tableArray;    // 下拉列表数据
    UITextField *textField; // 文本输入框
    BOOL showList;          // 是否已经弹出下拉列表
    CGFloat tabHeight;      // table下拉列表的高度
    CGFloat frameHeight;    // frame的高度
}

@property (nonatomic,assign) id<DropDownListDelegate> delegate;

@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,retain) UITextField *textField;

@end
