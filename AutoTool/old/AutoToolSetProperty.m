//
//  AutoToolSetProperty.m
//  AutoTool
//
//  Created by daocaoren on 2022/12/7.
//

#import "AutoToolSetProperty.h"
#import "AutoToolFactoryMethod.h"

@implementation AutoToolSetProperty
+ (NSString *)getBgColorViewName:(NSString *)viewName dic:(NSDictionary *)dic {
    if ([dic[@"bgColor"] length]) {
        NSString *colorStr = [dic[@"bgColor"] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        return [NSString stringWithFormat:@"%@.backgroundColor = %@",viewName,[AutoToolFactoryMethod getColorCode:colorStr]];
    }
    return nil;
}
+ (NSString *)getCornerViewName:(NSString *)viewName dic:(NSDictionary *)dic {
    NSMutableArray *temp = [NSMutableArray array];
    if ([dic[@"cornerRadius"] length]) {
        NSString *cornerRadius = [NSString stringWithFormat:@"%@.layer.cornerRadius = %@;",viewName,dic[@"cornerRadius"]];
        [temp addObject:cornerRadius];
        
        if ([dic[@"masksToBound"] boolValue]) {
            NSString *masksToBound = [NSString stringWithFormat:@"%@.layer.masksToBound = YES;",viewName];
            [temp addObject:masksToBound];
        }
    }
    if (temp.count) {
        return [temp componentsJoinedByString:@"\n"];
    }
    return nil;
}
+ (NSString *)getBorderViewName:(NSString *)viewName dic:(NSDictionary *)dic {
    NSMutableArray *temp = [NSMutableArray array];
    if ([dic[@"borderWidth"] length]) {
        NSString *borderWidth = [NSString stringWithFormat:@"%@.layer.borderWidth = %@;",viewName,dic[@"borderWidth"]];
        [temp addObject:borderWidth];
        
        if ([dic[@"borderColor"] length]) {
            NSString *colorStr = [dic[@"borderColor"] stringByReplacingOccurrencesOfString:@"#" withString:@""];
            NSString *borderColor = [NSString stringWithFormat:@"%@.layer.borderColor = %@.CGColor;",viewName,[AutoToolFactoryMethod getColorCode:colorStr]];
            [temp addObject:borderColor];
        }
    }
    if (temp.count) {
        return [temp componentsJoinedByString:@"\n"];
    }
    return nil;
}
@end
