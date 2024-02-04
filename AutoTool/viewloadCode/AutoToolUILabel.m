//
//  AutoToolUILabel.m
//  AutoTool
//
//  Created by daocaoren on 2023/6/27.
//

#import "AutoToolUILabel.h"

@implementation AutoToolUILabel
+ (NSString *)getLazyLoadCodeWithModel:(AutoToolViewModel *)model {
    if (model.name.length == 0) {
        return nil;
    }
    
    NSMutableArray *lines = [NSMutableArray array];
    
    // 创建
    [lines addObject:[NSString stringWithFormat:@"- (%@ *)%@ {\n    if (_%@ == nil) {\n        _%@ = [[UILabel alloc] init];",model.cls,model.name,model.name,model.name]];

    // 基础属性
    [lines addObjectsFromArray:[AutoToolUIView getUIViewBasePropertyLineArray:model]];
    
    // 自有属性
    if (model.text.length) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.text = @\"%@\";",model.name,model.text]];
    }
    if (model.font.length) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.font = %@;",model.name,[AutoToolFont getFontCode:model.font]]];
    }
    if (model.textColor.length) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.textColor = %@;",model.name,[AutoToolColor getColorCode:model.textColor]]];
    }
    if (model.alignmentCenter) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.textAlignment = NSTextAlignmentCenter;",model.name]];
    }
    if (model.linesNumberZero) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.numberOfLines = 0;",model.name]];
    }
    
    // 结束
    [lines addObject:[NSString stringWithFormat:@"    }\n    return _%@;\n}",model.name]];

    
    if (lines.count == 0) {
        return nil;
    }
    return [lines componentsJoinedByString:@"\n"];
}

@end
