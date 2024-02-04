//
//  AutoToolUITableView.m
//  AutoTool
//
//  Created by daocaoren on 2023/6/27.
//

#import "AutoToolUITableView.h"

@implementation AutoToolUITableView
+ (NSString *)getLazyLoadCodeWithModel:(AutoToolViewModel *)model {
    if (model.name.length == 0) {
        return nil;
    }
    
    NSMutableArray *lines = [NSMutableArray array];
    
    // 创建
    [lines addObject:[NSString stringWithFormat:@"- (%@ *)%@ {\n    if (_%@ == nil) {\n        _%@ = [[UITableView alloc] init];",model.cls,model.name,model.name,model.name]];

    // 基础属性
    [lines addObjectsFromArray:[AutoToolUIView getUIViewBasePropertyLineArray:model]];
    
    // 自有属性
    if (model.hideVerticalScrollIndicator) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.showsVerticalScrollIndicator = NO;",model.name]];
    }
    if (model.hideHorizontalScrollIndicator) {
        [lines addObject:[NSString stringWithFormat:@"        _%@.showsHorizontalScrollIndicator = NO;",model.name]];
    }

    [lines addObject:[NSString stringWithFormat:@"        _%@.dataSource = self;",model.name]];
    [lines addObject:[NSString stringWithFormat:@"        _%@.delegate = self;",model.name]];

    [lines addObject:[NSString stringWithFormat:@"        _%@.estimatedRowHeight = 1;",model.name]];
    [lines addObject:[NSString stringWithFormat:@"        _%@.estimatedSectionFooterHeight = 1;",model.name]];
    [lines addObject:[NSString stringWithFormat:@"        _%@.estimatedSectionHeaderHeight = 1;",model.name]];
    [lines addObject:[NSString stringWithFormat:@"        _%@.separatorStyle = UITableViewCellSeparatorStyleNone;",model.name]];

    [lines addObject:[NSString stringWithFormat:@"        if (@available(iOS 11.0, *)) {\n            _%@.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\n        }",model.name]];
    [lines addObject:[NSString stringWithFormat:@"        if (@available(iOS 15.0, *)) {\n            _%@.sectionHeaderTopPadding = 0;\n        }",model.name]];

    
    // 结束
    [lines addObject:[NSString stringWithFormat:@"    }\n    return _%@;\n}",model.name]];

    
    if (lines.count == 0) {
        return nil;
    }
    return [lines componentsJoinedByString:@"\n"];
}
@end
