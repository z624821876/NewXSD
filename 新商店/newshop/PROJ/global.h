//
//  global.h
//  mlh
//
//  Created by qd on 13-5-8.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define DLog(...)
#define debugLog(...)
#define debugMethod()
#endif

#ifndef global_h
#define global_h

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20
#define UI_SCREEN_WIDTH                 [UIScreen mainScreen].bounds.size.width
#define UI_SCREEN_HEIGHT                [[UIScreen mainScreen] bounds].size.height


#define LOAD_MORE_TEXT_HEIGHT 77
// 显示文字阈值
#define LOAD_MORE_THRESHOLD (UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - LOAD_MORE_TEXT_HEIGHT)
// 刷新阈值
#define LOAD_MORE_MAX       (LOAD_MORE_THRESHOLD + 10.0)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

#define PATH_OF_APPITEMIMAGE [NSString stringWithFormat:@"%@/appitemimage", PATH_OF_DOCUMENT]

#define nilOrJSONObjectForKey(JSON_, KEY_) ([JSON_ valueForKeyPath:KEY_] == [NSNull null] ? nil : [JSON_ valueForKeyPath:KEY_]);

static NSString * const sBaseJsonURLStr = @"http://admin.53xsd.com";
static NSString * const sBaseJsonURLStrWeb = @"http://admin.53xsd.com/";
//static NSString * const sBaseUploadUrlStr = @"http://admin.sunday-mobi.com/";
static NSString * const sBaseUploadUrlStr = @"http://admin.53xsd.com/";

static NSString * const sVersionDownloadURL = @"itms-services://?action=download-manifest&url=https://app.hdtht.com/ios/sunday/xsd.plist";
static NSString * const sVersionURL = @"http://vipstatic.sunday-mobi.com/download/xsd/ios/versions.plist";

// 项目名称
static NSString * const sAppName = @"XSD";

#define dbPath [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"thedb.sqlite"]
#define GBPath [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Machinfo.sqlite"]

#define APP_LOGIN_KEY @"www.XSD.com/loginKey"
#define KEY_USERNAME_PASSWORD @"com.XSD.usernamepassword"
#define KEY_USERNAME @"com.XSD.username"
#define KEY_PASSWORD @"com.XSD.password"

#define infoTypeNone    @"0" //HtmlDetailVC不显示toolbar
#define infoTypeInfo    @"1"
#define infoTypeActivity @"2"
#define infoTypeProduct @"3
#define infoTypeVote    @"4"


#define kUserDefaultsEverLaunch @"kEverLaunch"
#define kUserDefaultsAppHasDownload @"kAppHasDownload"


#define kUserDefaultsLastVersionCheckDate @"kAppVersionCheckDate"

#define partnerGitUrl @"https://raw.githubusercontent.com/github568/ver/master/partner.json"

#define PROJECTID @"11"

#define iOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 ? YES:NO)
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES:NO)
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES:NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
/****************小房  支付*************  */
static NSString * const jsonCreateBooks = @"mobi/cart/dopay?1=1";//购物车生成订单：

static NSString * const confimBooks = @"mobi/cart/doConfirm?1=1";//购物车到确认订单

static NSString * const AddCar = @"mobi/cart/add?1=1";//加入购物车：

static NSString * const SelectCar = @"mobi/cart/list?1=1";//查询接口：

static NSString * const jsonDeleteCar = @"mobi/cart//delete?1=1";//删除接口：

static NSString *const buyNowConfim = @"mobi/cart/buyNow?1=1";//立即购买确认订单

static NSString *const buyNowGoPay = @"mobi/cart/doPayNow?1=1";//立即购买生成订单

static NSString *const addAddress = @"mobi/address/doAdd?1=1";//添加收货地址

static NSString *const deleteAddress = @"mobi/address/delete/1=1";//删除收货地址

static NSString *const seleceAddress = @"mobi/address/list?1=1";//查询地址

#pragma mark   点餐接口

static NSString *const getShopProductCategory = @"mobi/getShopProductCategory?1=1";//点餐店铺下的分类

static NSString *const selectByCategory = @"mobi/selectByCategory?1=1";//分类下的商品


/**************** 以上均为小房  *****************/
static NSString * const jsonAd = @"mobi/getAdv?1=1";  //广告

static NSString * const jsonCate = @"mobi/getCategory?1=1"; //行业分类
static NSString * const jsonCateShop = @"mobi/getShops?1=1"; //分类下的店铺

static NSString * const jsonMarket = @"market/list?1=1"; //市场和商场列表

static NSString * const jsonShopProduct = @"mobi/getProductByShopId?1=1"; //店铺下的商品

static NSString * const jsonProductDetail = @"mobi/getProductDetail?1=1"; //商品详情
static NSString * const jsonRecommended = @"mobi/getRecProduct?1=1"; //同店推荐


static NSString * const jsonBalance = @"mobi/getBalance?1=1"; //我的余额
static NSString * const jsonPay = @"trade/userPay?1=1"; //支付

static NSString * const jsonMarketDetail = @"market/getMarket?1=1"; //市场/商场 详情、分类、广告
static NSString * const jsonMarketShop = @"market/getShopByMarket?1=1"; //市场下所有店
static NSString * const jsonMarketCateShop = @"market/getShopByMarketCat?1=1"; //市场下分类下的店

static NSString * const jsonAreaIdByName = @"mobi/getAreaIds?1=1"; //根据城市名和区县名得到省/市/区的ID

static NSString * const jsonAreaList = @"mobi/getCitys?1=1"; //得到省市区（迭代）

static NSString * const jsonNearby = @"mobi/getNearbyShops?1=1"; //附近

static NSString * const jsonLogin = @"user/log?1=1"; //登陆
static NSString * const jsonSendSms = @"user/sendActiveCode?1=1"; //下发短信
static NSString * const jsonRegister = @"user/reg?1=1"; //注册

static NSString * const jsonRecords = @"mobi/getRecordAsPage?1=1"; //我的交易记录

static NSString * const jsonFoodConfirm = @"/mobi/cart/foodConfirm?1=1"; //点餐确认页面


static NSString * const jsonErrLogSave = @"errlog_save?1=1";
static NSString * const jsonAppStartNumber = @"startnumber?1=1";  //启动数
static NSString * const jsonAppDownload = @"writedownload?1=1";   //下载量
//static NSString * const jsonLogin = @"shandi/expertLogin?1=1";   //登录

static NSString * const apiRegister = @"cheshi/cusReg?1=1"; //注册
static NSString * const apiVerify = @"cheshi/getYzm?1=1"; //验证码下发
static NSString * const apiLogin = @"cheshi/cusLog?1=1"; //登陆
static NSString * const apiOrder = @"cheshi/order?1=1"; //洗车 type=1 现在洗车 ；type=2 预约洗车
static NSString * const apiOrderDetail = @"cheshi/orderDetail?1=1"; //订单详情
static NSString * const apiShopList = @"cheshi/getCarServiceSpots?1=1"; //分店列表
static NSString * const apiInfoCenter = @"cheshi/infoCenter?1=1"; //消息中心 **
static NSString * const apiGetCitys = @"cheshi/getCitys?1=1"; //消息中心 **



typedef enum{   //4种状态, 可用于各种情况，比如异步变同步时作标志位  
    FlagWait,
    FlagNoWait,
    FlagSuccess,
    FlagFailure,
}WaitFlag;

#define HUDShowErrorServerOrNetwork [[tools shared] HUDShowHideText:@"你的网络异常,请稍后再试" delay:2];

#endif
