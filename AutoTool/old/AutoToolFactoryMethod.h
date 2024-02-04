//
//  AutoToolFactoryMethod.h
//  AutoTool
//
//  Created by daocaoren on 2022/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutoToolFactoryMethod : NSObject
+ (NSString *)getUIViewCreatCode:(NSDictionary *)dic;
+ (NSString *)getUILabelCreatCode:(NSDictionary *)dic;
+ (NSString *)getUIButtonCreatCode:(NSDictionary *)dic;
+ (NSString *)getUIImageViewCreatCode:(NSDictionary *)dic;
+ (NSString *)getUITableViewCreatCode:(NSDictionary *)dic;
+ (NSString *)getUICollectionViewCreatCode:(NSDictionary *)dic;


+ (NSString *)getColorCode:(NSString *)colorStr;
@end

NS_ASSUME_NONNULL_END
