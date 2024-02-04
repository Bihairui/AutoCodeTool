//
//  AutoToolCreatViewCode.h
//  AutoTool
//
//  Created by daocaoren on 2022/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ViewCodeModel : NSObject
@property (strong, nonatomic) NSString *superViewName;

@property (strong, nonatomic) NSString *propertyCode;
@property (strong, nonatomic) NSString *addSubViewCode;
@property (strong, nonatomic) NSString *constraintsCode;
@property (strong, nonatomic) NSString *lazyLoadCode;
@end





@interface AutoToolCreatViewCode : NSObject
+ (ViewCodeModel *)getViewCode:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
