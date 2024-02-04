//
//  AutoToolSetProperty.h
//  AutoTool
//
//  Created by daocaoren on 2022/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



/// 设置懒加载方法中，生成实例的各种属性，颜色，圆角，背景等等
@interface AutoToolSetProperty : NSObject

+ (NSString *)getBgColorViewName:(NSString *)viewName dic:(NSDictionary *)dic;
+ (NSString *)getCornerViewName:(NSString *)viewName dic:(NSDictionary *)dic;
+ (NSString *)getBorderViewName:(NSString *)viewName dic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
