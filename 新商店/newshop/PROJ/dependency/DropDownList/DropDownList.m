#import "DropDownList.h"

@implementation DropDownList

@synthesize delegate,tableArray,tv,textField;

- (void)dealloc
{
    [tv release];
    [tableArray release];
    [textField release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
    if (frame.size.height<200)
    {
        frameHeight = 200;
    }
    else
    {
        frameHeight = frame.size.height;
    }
    
    tabHeight = frameHeight-30;
    
    frame.size.height = 30.0f;
    
    self = [super initWithFrame:frame];
    
    if(self)
    {
        showList = NO; //默认不显示下拉框
        
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 0)];
        tv.delegate = self;
        tv.dataSource = self;
        tv.backgroundColor = [UIColor grayColor];
        tv.separatorColor = [UIColor lightGrayColor];
        tv.hidden = YES;
        [self addSubview:tv];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;//设置文本框的边框风格
        [textField addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllTouchEvents];
        [self addSubview:textField];
        
    }
    return self;
}

-(void)dropdown
{
    [textField resignFirstResponder]; // iOS 6 下存在问题,会显示键盘
    textField.enabled = false; // 解决iOS 6 的问题
    
    if (showList)
    {
        return; // 如果下拉框已显示，什么都不做
    }
    else
    {
        // 如果下拉框尚未显示，则进行显示
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        
        // 把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        tv.hidden = NO;
        showList = YES;//显示下拉框
        
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        frame.size.height = tabHeight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = sf;
        tv.frame = frame;
        [UIView commitAnimations];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableArray.count == 0)
        return 1;
    else
        return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(tableArray.count <= [indexPath row])
        cell.textLabel.text = @"";
    else
        cell.textLabel.text = [tableArray objectAtIndex:[indexPath row]];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

// 选中某项
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 恢复可用
    textField.enabled = true;
    
    textField.text = [tableArray objectAtIndex:[indexPath row]];
    showList = NO;
    tv.hidden = YES;
    
    // 委托回调
    if(delegate != nil)
    {
        [delegate ddlValueChangedCallBack:self];
    }
    
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
