//
//  AddAddressVC.h
//  newshop
//
//  Created by sunday on 15/2/2.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"
@class AddAddressVC;
@protocol AddressDelegate <NSObject>

- (void)addWithAddressvc:(AddAddressVC *)addVC WithName:(NSString *)userName Number:(NSString *)number Address:(NSString *)address;
@end
@interface AddAddressVC : BaseVC<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userNumber;
@property (nonatomic,strong) NSString *userAddress;


@property (nonatomic,strong) id<AddressDelegate>delegate;

@end
