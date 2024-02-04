//
//  AutoToolUIButton.m
//  AutoTool
//
//  Created by daocaoren on 2023/6/27.
//

#import "AutoToolUIButton.h"

@implementation AutoToolUIButton
+ (NSString *)getLazyLoadCodeWithModel:(AutoToolViewModel *)model {
    if (model.name.length == 0) {
        return nil;
    }
    
    NSMutableArray *lines = [NSMutableArray array];
    
    // 创建
    [lines addObject:[NSString stringWithFormat:@"- (%@ *)%@ {\n    if (_%@ == nil) {\n        _%@ = [UIButton buttonWithType:UIButtonTypeCustom];",model.cls,model.name,model.name,model.name]];

    // 基础属性
    [lines addObjectsFromArray:[AutoToolUIView getUIViewBasePropertyLineArray:model]];
    
    // 自有属性
    if (model.text.length) {
        [lines addObject:[NSString stringWithFormat:@"        [_%@ setTitle:@\"%@\" forState:UIControlStateNormal];",model.name,model.text]];
    }
    if (model.image.length) {
        [lines addObject:[NSString stringWithFormat:@"        [_%@ setImage:[UIImage imageNamed:@\"%@\"] forState:UIControlStateNormal];",model.name,model.image]];
    }
    if (model.backgroundImage.length) {
        [lines addObject:[NSString stringWithFormat:@"        [_%@ setBackgroundImage:[UIImage imageNamed:@\"%@\"]];",model.name,model.backgroundImage]];
    }
    if (model.font.length) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.titleLabel.font = %@;",model.name,[AutoToolFont getFontCode:model.font]]];
    }
    if (model.textColor.length) {
        [lines addObject:[NSString stringWithFormat:@"        [_%@ setTitleColor:%@ forState:UIControlStateNormal];",model.name,[AutoToolColor getColorCode:model.textColor]]];
    }
    if (model.SELMethod) {
        [lines addObject:[NSString stringWithFormat:@"        [_%@ addTarget:self action:@selector(%@:) forControlEvents:UIControlEventTouchUpInside];",model.name,[NSString stringWithFormat:@"%@Click",model.name]]];
    }
    
    // 结束
    [lines addObject:[NSString stringWithFormat:@"    }\n    return _%@;\n}",model.name]];

    
    if (lines.count == 0) {
        return nil;
    }
    return [lines componentsJoinedByString:@"\n"];
}

@end
