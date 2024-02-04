//
//  AutoToolFactoryMethod.m
//  AutoTool
//
//  Created by daocaoren on 2022/12/7.
//

#import "AutoToolFactoryMethod.h"

@implementation AutoToolFactoryMethod

+ (NSString *)getUIViewCreatCode:(NSDictionary *)dic {
    
    return @"";
}


+ (NSString *)getUILabelCreatCode:(NSDictionary *)dic {
    
    return @"";
}


+ (NSString *)getUIButtonCreatCode:(NSDictionary *)dic {
    
    return @"";
}


+ (NSString *)getUIImageViewCreatCode:(NSDictionary *)dic {
    
    return @"";
}


+ (NSString *)getUITableViewCreatCode:(NSDictionary *)dic {
    
    return @"";
}


+ (NSString *)getUICollectionViewCreatCode:(NSDictionary *)dic {
    
    return @"";
}



+ (NSString *)getColorCode:(NSString *)colorStr {
    return [NSString stringWithFormat:@"[UIColor colorWithHexString:%@]",[colorStr stringByReplacingOccurrencesOfString:@"#" withString:@""]];
}
@end
