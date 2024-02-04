//
//  AutoToolColor.m
//  AutoTool
//
//  Created by daocaoren on 2023/6/27.
//

#import "AutoToolColor.h"

@implementation AutoToolColor
+ (NSString *)getColorCode:(NSString *)colorStr {
    return [NSString stringWithFormat:@"[UIColor colorWithHexString:@\"%@\"]",[colorStr stringByReplacingOccurrencesOfString:@"#" withString:@""]];
}
@end
