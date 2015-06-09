//
//  Util.m
//  mlh
//
//  Created by qd on 13-5-10.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "Util.h"


@implementation Util : NSObject

//验证手机号
+ (BOOL)viableMobileWith:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,177
     22         */
    NSString * CT = @"^1((33|77|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//NSString UTF8转码
+(NSString *)getUTF8Str:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//不转webview打不开啊。。
+(NSString *)getWebViewUrlStr:(NSString *)urlStr{
    return [urlStr stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
}

//去掉空格
+(NSString *) stringByRemoveTrim:(NSString *)str{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//根据文字、字体、文字区域宽度，得到文字区域高度
+ (CGFloat)heightForText:(NSString*)sText Font:(UIFont*)font forWidth:(CGFloat)fWidth{
    CGSize szContent = [sText sizeWithFont:font constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX)
                             lineBreakMode:UILineBreakModeWordWrap];
    return  szContent.height;
}

//根据文字信息和url，得到最终的文字message（总长度不超过140）。 url可以为nil。
-(NSString *)getMessageWithText:(NSString *)text url:(NSString *)url{
    if (text == nil && url == nil) {
        return nil;
    }
    if (text == nil) {
        return url;
    }
    
    //text != nil
    NSMutableString *messageText  = [[NSMutableString alloc] init];
    if (url == nil) {
        int trimlength =  [text length]- 140;
        if (trimlength > 0) {
            [messageText appendFormat:@"%@",[text substringWithRange:NSMakeRange(0, [text length]-trimlength)]];
        }else{
            [messageText appendFormat:@"%@",text];
        }
        NSLog(@"%u%@",[messageText length],messageText);
        return messageText;
    }else{
        int trimlength =  [text length] + [url length] - 140;
        if (trimlength > 0) {
            [messageText appendFormat:@"%@%@",[text substringWithRange:NSMakeRange(0, [text length]-trimlength)],url];
        }else{
            [messageText appendFormat:@"%@%@",text,url];
        }
        NSLog(@"%u%@",[messageText length],messageText);
        return messageText;
    }
    
}

//view根据原来的frame做调整，重新setFrame，fakeRect的4个参数如果<0，则用原来frame的相关参数，否则就用新值。
+ (void) View:(UIView *)view ReplaceFrameWithRect:(CGRect) fakeRect{
    CGRect frame = view.frame;
    CGRect newRect;
    newRect.origin.x = fakeRect.origin.x > 0 ? fakeRect.origin.x : frame.origin.x;
    newRect.origin.y = fakeRect.origin.y > 0 ? fakeRect.origin.y : frame.origin.y;
    newRect.size.width = fakeRect.size.width > 0 ? fakeRect.size.width : frame.size.width;
    newRect.size.height = fakeRect.size.height > 0 ? fakeRect.size.height : frame.size.height;
    [view setFrame:newRect];
}

//view根据原来的bounds做调整，重新setBounds，fakeRect的4个参数如果<0，则用原来bounds的相关参数，否则就用新值。
+ (void) View:(UIView *)view ReplaceBoundsWithRect:(CGRect) fakeRect{
    CGRect bounds = view.bounds;
    CGRect newRect;
    newRect.origin.x = fakeRect.origin.x > 0 ? fakeRect.origin.x : bounds.origin.x;
    newRect.origin.y = fakeRect.origin.y > 0 ? fakeRect.origin.y : bounds.origin.y;
    newRect.size.width = fakeRect.size.width > 0 ? fakeRect.size.width : bounds.size.width;
    newRect.size.height = fakeRect.size.height > 0 ? fakeRect.size.height : bounds.size.height;
    [view setBounds:newRect];
}

//根据@"#eef4f4"得到UIColor
+ (UIColor *) uiColorFromString:(NSString *) clrString
{
	return [Util uiColorFromString:clrString alpha:1.0];
}

//将原始图片draw到指定大小范围，从而得到并返回新图片。能缩小图片尺寸和大小
+ (UIImage*)ScaleImage:(UIImage*)image ToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//将图片保存到document目录下
+ (void)saveDocImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.4);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

+ (UIColor *) uiColorFromString:(NSString *) clrString alpha:(double)alpha
{
	if ([clrString length] == 0) {
		return [UIColor clearColor];
	}
	
	if ( [clrString caseInsensitiveCompare:@"clear"] == NSOrderedSame) {
		return [UIColor clearColor];
	}
	
	if([clrString characterAtIndex:0] == 0x0023 && [clrString length]<8)
	{
		const char * strBuf= [clrString UTF8String];
		
		int iColor = strtol((strBuf+1), NULL, 16);
		typedef struct colorByte
		{
			unsigned char b;
			unsigned char g;
			unsigned char r;
		}CLRBYTE;
		CLRBYTE * pclr = (CLRBYTE *)&iColor;
		return [UIColor colorWithRed:((double)pclr->r/255) green:((double)pclr->g/255) blue:((double)pclr->b/255) alpha:alpha];
	}
	return [UIColor blackColor];
}

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//将浮点数转换为NSString，并设置保留小数点位数
+ (NSString *)getStringFromFloat:(float) f withDecimal:(int) decimalPoint{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:decimalPoint];

    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:f]];
}

//判断字符串为nil或""
+ (BOOL)isNil:(NSString *)str
{
    if (str == nil || [str isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)getValuesFor:(NSDictionary *)dic key:(NSString *)str
{
    id value = nilOrJSONObjectForKey(dic, str);
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return value;
}


+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+(UIImage *)imageClips:(UIImage *)oldImage Rect:(CGRect)rect
{
    CGImageRef newImageRef = CGImageCreateWithImageInRect( oldImage.CGImage, rect );
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease( newImageRef );
    return newImage;
}


@end
