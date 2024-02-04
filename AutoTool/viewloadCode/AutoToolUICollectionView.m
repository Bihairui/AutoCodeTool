//
//  AutoToolUICollectionView.m
//  AutoTool
//
//  Created by daocaoren on 2023/6/27.
//

#import "AutoToolUICollectionView.h"

@implementation AutoToolUICollectionView


+ (NSString *)getLazyLoadCodeWithModel:(AutoToolViewModel *)model {
    if (model.name.length == 0) {
        return nil;
    }
    
    NSMutableArray *lines = [NSMutableArray array];
    
    // 方法开头
    [lines addObject:[NSString stringWithFormat:@"- (%@ *)%@ {\n    if (_%@ == nil) {",model.cls,model.name,model.name]];

    // 创建布局
    [lines addObject:@"        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];"];
    [lines addObject:@"        CGFloat itemWidth;"];
    [lines addObject:@"        layout.itemSize = CGSizeMake(100,100);"];
    [lines addObject:@"        layout.minimumLineSpacing = 0;"];
    [lines addObject:@"        layout.minimumInteritemSpacing = 0;"];
    [lines addObject:@"        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;\n"];
    
    // 创建
    [lines addObject:[NSString stringWithFormat:@"        _%@ = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];",model.name]];

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

    // 结束
    [lines addObject:[NSString stringWithFormat:@"    }\n    return _%@;\n}",model.name]];

    
    if (lines.count == 0) {
        return nil;
    }
    return [lines componentsJoinedByString:@"\n"];
}

@end




