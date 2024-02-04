//
//  AutoToolUIImageView.m
//  AutoTool
//
//  Created by daocaoren on 2023/6/27.
//

#import "AutoToolUIImageView.h"

@implementation AutoToolUIImageView
+ (NSString *)getLazyLoadCodeWithModel:(AutoToolViewModel *)model {
    if (model.name.length == 0) {
        return nil;
    }
    
    NSMutableArray *lines = [NSMutableArray array];
    
    // 创建
    [lines addObject:[NSString stringWithFormat:@"- (%@ *)%@ {\n    if (_%@ == nil) {\n        _%@ = [[UIImageView alloc] init];",model.cls,model.name,model.name,model.name]];

    // 基础属性
    [lines addObjectsFromArray:[AutoToolUIView getUIViewBasePropertyLineArray:model]];
    
    // 自有属性
    if (model.image.length) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.image = [UIImage imageNamed:@\"%@\"];",model.name,model.image]];
    }    
    // 结束
    [lines addObject:[NSString stringWithFormat:@"    }\n    return _%@;\n}",model.name]];

    
    if (lines.count == 0) {
        return nil;
    }
    return [lines componentsJoinedByString:@"\n"];
}

@end
