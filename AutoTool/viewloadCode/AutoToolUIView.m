//
//  AutoToolUIView.m
//  AutoTool
//
//  Created by daocaoren on 2023/6/27.
//

#import "AutoToolUIView.h"

@implementation AutoToolUIView

+ (NSString *)getLazyLoadCodeWithModel:(AutoToolViewModel *)model {
    if (model.name.length == 0) {
        return nil;
    }
    
    NSMutableArray *lines = [NSMutableArray array];
    
    // 创建
    [lines addObject:[NSString stringWithFormat:@"- (%@ *)%@ {\n    if (_%@ == nil) {\n        _%@ = [[UIView alloc] init];",model.cls,model.name,model.name,model.name]];

    // 基础属性
    [lines addObjectsFromArray:[self getUIViewBasePropertyLineArray:model]];
    
    // 结束
    [lines addObject:[NSString stringWithFormat:@"    }\n    return _%@;\n}",model.name]];

    
    if (lines.count == 0) {
        return nil;
    }
    return [lines componentsJoinedByString:@"\n"];
}



















+ (NSArray *)getUIViewBasePropertyLineArray:(AutoToolViewModel *)model {
    
    NSMutableArray *lines = [NSMutableArray array];
    
    // 背景
    if (model.bgColor.length) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.backgroundColor = %@;",model.name,[AutoToolColor getColorCode:model.bgColor]]];
    }
    
    
    // 圆角
    if (model.cornerRadius.length) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.layer.cornerRadius = %@;",model.name,model.cornerRadius]];
        if (model.masksToBounds) {
            [lines addObject:[NSString stringWithFormat:@"        _%@.layer.masksToBounds = YES;",model.name]];
        }
    }

    // 边框
    if (model.borderWidth.length) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.layer.borderWidth = %@;",model.name,model.borderWidth]];
        if (model.borderColor.length) {
            [lines addObject:[NSString stringWithFormat:@"        _%@.layer.borderColor = %@.CGColor;",model.name,[AutoToolColor getColorCode:model.borderColor]]];
        }
    }
    
    // 拉伸
    if (model.hugging) {
        [lines addObject:[NSString stringWithFormat:@"        [_%@ setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];",model.name]];
        [lines addObject:[NSString stringWithFormat:@"        [_%@ setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];",model.name]];
    }
    
    // 压缩
    if (model.compress) {
        [lines addObject:[NSString stringWithFormat:@"        [_%@ setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];",model.name]];
        [lines addObject:[NSString stringWithFormat:@"        [_%@ setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];",model.name]];
    }


    return lines.copy;
}
@end
