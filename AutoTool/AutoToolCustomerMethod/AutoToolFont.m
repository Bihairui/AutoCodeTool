//
//  AutoToolFont.m
//  AutoTool
//
//  Created by daocaoren on 2023/6/27.
//

#import "AutoToolFont.h"

@implementation AutoToolFont
+ (NSString *)getFontCode:(NSString *)fontStr {
    if ([fontStr hasSuffix:@"b"] || [fontStr hasSuffix:@"B"]) {
        NSString *size = [fontStr substringToIndex:fontStr.length - 1];
        return [NSString stringWithFormat:@"[UIFont systemFontOfSize:%@ weight:UIFontWeightBold]",size];
    }
    if ([fontStr hasSuffix:@"s"] || [fontStr hasSuffix:@"S"]) {
        NSString *size = [fontStr substringToIndex:fontStr.length - 1];
        return [NSString stringWithFormat:@"[UIFont systemFontOfSize:%@ weight:UIFontWeightSemibold]",size];
    }
    if ([fontStr hasSuffix:@"m"] || [fontStr hasSuffix:@"M"]) {
        NSString *size = [fontStr substringToIndex:fontStr.length - 1];
        return [NSString stringWithFormat:@"[UIFont systemFontOfSize:%@ weight:UIFontWeightMedium]",size];
    }
    return [NSString stringWithFormat:@"[UIFont systemFontOfSize:%@]",fontStr];
    
    return @"[UIFont systemFontSize]";
}
@end
