//
//  FinishPayVC.h
//  newshop
//
//  Created by sunday on 15/1/22.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"

@interface FinishPayVC : BaseVC
@property (nonatomic,strong) NSString *bookNumber;
@property (nonatomic,strong) NSString *bookDate;
@property (nonatomic,strong) NSString *payState;//支付状态（即支付成功或失败）

@end
