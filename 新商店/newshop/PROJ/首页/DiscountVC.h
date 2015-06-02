//
//  DiscountVC.h
//  newshop
//
//  Created by 于洲 on 15/3/5.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"

@interface DiscountVC : BaseVC<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collection;

@end
