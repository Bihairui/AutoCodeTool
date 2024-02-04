//
//  AutoToolViewModel.m
//  AutoTool
//
//  Created by daocaoren on 2023/6/27.
//

#import "AutoToolViewModel.h"
#import "MJExtension.h"
#import "AutoToolCustomerMethod.h"
#import "AutoToolViewLazyMethod.h"


#pragma mark - 视图模型

@implementation AutoToolViewModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"creatCells":@"AutoToolViewModel",
             @"subView":@"AutoToolViewModel"};
}


#pragma mark - 工具方法

- (NSString *)getFileName {
    NSString *fileName = self.newclass.length ? self.newclass : self.cls;
    fileName = [NSString stringWithFormat:@"%@%@",[[fileName substringToIndex:1] uppercaseString],[fileName substringFromIndex:1]];
    return fileName;
}



#pragma mark - 输出代码

- (NSString *)getHFileCode {
    
    NSMutableArray *lines = [NSMutableArray array];
    [lines addObject:@"\n\n#import <UIKit/UIKit.h>\n"];
    [lines addObject:@"\n\nNS_ASSUME_NONNULL_BEGIN\n"];
    [lines addObject:[NSString stringWithFormat:@"@interface %@ : %@\n",self.getFileName,self.cls]];
    
    NSArray *propertyLines = [self.subView valueForKeyPath:@"propertyCode_property"];
    [lines addObjectsFromArray:propertyLines];
    
    [lines addObject:@"\n"];
    
    if ([self.cls isEqualToString:@"UITableViewCell"]) {
        [lines addObject:@"+ (instancetype)cellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;"];
    }
    if ([self.cls isEqualToString:@"UICollectionViewCell"]) {
        [lines addObject:@"+(instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;"];
    }
    
    [lines addObject:@"\n"];
    
    [lines addObject:@"@end"];
    [lines addObject:@"\n\nNS_ASSUME_NONNULL_END\n"];
    return [lines componentsJoinedByString:@"\n"];
}

- (NSString *)getMFileCode {

    NSMutableArray *lines = [NSMutableArray array];
    
    // 开头
    [lines addObject:[NSString stringWithFormat:@"\n\n#import \"%@.h\"\n",self.getFileName]];
    [lines addObject:[NSString stringWithFormat:@"@interface %@()%@\n",self.getFileName,[self getAbideDelegate]]];
    [lines addObject:@"@end\n"];
    [lines addObject:[NSString stringWithFormat:@"@implementation %@\n",self.getFileName]];

    /// 构建方法
    NSString *setupUIMethodStr = @"creatUI";
    if ([self.cls isEqualToString:@"UIView"]) {
        [lines addObject:[NSString stringWithFormat:@"- (instancetype)initWithFrame:(CGRect)frame {\n    self = [super initWithFrame:frame];\n    if (self) {\n        [self %@];\n    }\n    return self;\n}\n",setupUIMethodStr]];
    }
    if ([self.cls isEqualToString:@"UIViewController"]) {
        [lines addObject:[NSString stringWithFormat:@"- (void)viewDidLoad {\n    [super viewDidLoad];\n    [self %@];\n}",setupUIMethodStr]];
    }
    if ([self.cls isEqualToString:@"UITableViewCell"]) {
        [lines addObject:[NSString stringWithFormat:@"+ (instancetype)cellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{\n    NSString *identifier = NSStringFromClass(self);\n    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];\n    if (cell == nil) {\n        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];\n        [cell performSelector:@selector(%@)];\n    }\n    cell.selectionStyle = UITableViewCellSelectionStyleNone;\n    return cell;\n}\n",setupUIMethodStr]];
    }
    if ([self.cls isEqualToString:@"UICollectionViewCell"]) {
        [lines addObject:@"+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {\n    NSString *identifier = NSStringFromClass(self);\n    [collectionView registerClass:self forCellWithReuseIdentifier:identifier];\n    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];\n    return cell;\n}\n"];
        [lines addObject:[NSString stringWithFormat:@"- (instancetype)initWithFrame:(CGRect)frame {\n    self = [super initWithFrame:frame];\n    if (self) {\n        [self %@];\n    }\n    return self;\n}\n",setupUIMethodStr]];
    }
    
    
    
    /// 初始化UI
    [lines addObject:[NSString stringWithFormat:@"- (void)%@ {",setupUIMethodStr]];

    for (AutoToolViewModel *subView in self.subView) {
        NSString *superviewStr = @"superview";
        if ([self.cls isEqualToString:@"UIView"]) {
            superviewStr = @"self";
        }else if ([self.cls isEqualToString:@"UIViewController"]) {
            superviewStr = @"self.view";
        }else if ([self.cls isEqualToString:@"UITableViewCell"]) {
            superviewStr = @"self.contentView";
        }else if ([self.cls isEqualToString:@"UICollectionViewCell"]) {
            superviewStr = @"self.contentView";
        }
        subView.subviewSuperView = superviewStr;
        [lines addObject:subView.propertyCode_addSubView];
    }
    [lines addObject:@"\n"];
    
    [lines addObjectsFromArray:[self.subView valueForKeyPath:@"propertyCode_masonry"]];
    
    [lines addObject:@"\n}\n"];
    
    
    /// 懒加载方法
    [lines addObjectsFromArray:[self.subView valueForKeyPath:@"propertyCode_lazyLoad"]];
    
    
    /// 按钮点击方法
    for (AutoToolViewModel *subView in self.subView) {
        if ([subView.cls isEqualToString:@"UIButton"]) {
            [lines addObject:subView.propertyCode_ButtonSELMethod];
        }
    }

    /// 代理方法
    for (AutoToolViewModel *subView in self.subView) {
        if ([subView.cls isEqualToString:@"UITableView"] || [subView.cls isEqualToString:@"UICollectionView"]) {
            [lines addObject:subView.propertyCode_DelegateMethod];
        }
    }


    [lines addObject:@"@end\n"];
    
    return [lines componentsJoinedByString:@"\n"];
}

- (NSString *)getAbideDelegate {
    NSMutableArray *delegateArray = [NSMutableArray array];
    for (AutoToolViewModel *model in self.subView) {
        if ([model.cls isEqualToString:@"UITableView"]) {
            [delegateArray addObject:@"UITableViewDelegate"];
            [delegateArray addObject:@"UITableViewDataSource"];
        }
        if ([model.cls isEqualToString:@"UICollectionView"]) {
            [delegateArray addObject:@"UICollectionViewDelegate"];
            [delegateArray addObject:@"UICollectionViewDataSource"];
        }
    }
    
    if (delegateArray.count) {
        return [NSString stringWithFormat:@"<%@>",[delegateArray componentsJoinedByString:@","]];
    }
    return @"";
}


/// 属性部分
- (NSString *)propertyCode_property {
    if (self.newclass.length) {
        return nil;
    }
    NSString *propertyCode = [NSString stringWithFormat:@"@property (strong, nonatomic) %@ *%@;",self.cls,self.name];
    return propertyCode;
}

/// 添加视图部分
- (NSString *)propertyCode_addSubView {
    if (self.newclass.length) {
        return nil;
    }
    NSString *addSubViewCodead = [NSString stringWithFormat:@"    [%@ addSubview:self.%@];",self.subviewSuperView,self.name];
    return addSubViewCodead;
}

/// 添加布局部分
- (NSString *)propertyCode_masonry {
    if (self.newclass.length) {
        return nil;
    }

    
    NSDictionary *layout = self.layout;
    NSMutableArray *chosenKeyCode = [NSMutableArray array];
    NSArray *keyArray = @[@"top",@"left",@"bottom",@"right",@"centerY",@"centerX",@"width",@"height",@"edges",@"size"];
    for (NSString *key in keyArray) {
        if ([layout[key] boolValue]) {
            NSString *left = @"<#";
            NSString *right = @"#>";
            [chosenKeyCode addObject:[NSString stringWithFormat:@"        make.%@.mas_equalTo(%@self.%@)%@.offset(%@;",key,left,right,left,right]];
        }
    }
    NSString *makeCodeString = [chosenKeyCode componentsJoinedByString:@"\n"];
    NSString *masonry = [NSString stringWithFormat:@"    [self.%@ mas_makeConstraints:^(MASConstraintMaker *make) {\n%@\n    }];",self.name,makeCodeString];
    return masonry;
}

/// 懒加载部分
- (NSString *)propertyCode_lazyLoad {
    if (self.newclass.length) {
        return nil;
    }
    
    if ([self.cls isEqualToString:@"UIView"]) {
        return [AutoToolUIView getLazyLoadCodeWithModel:self];
    }
    else if ([self.cls isEqualToString:@"UILabel"]) {
        return [AutoToolUILabel getLazyLoadCodeWithModel:self];
    }
    else if ([self.cls isEqualToString:@"UIButton"]) {
        return [AutoToolUIButton getLazyLoadCodeWithModel:self];
    }
    else if ([self.cls isEqualToString:@"UIImageView"]) {
        return [AutoToolUIImageView getLazyLoadCodeWithModel:self];
    }
    else if ([self.cls isEqualToString:@"UITableView"]) {
        return [AutoToolUITableView getLazyLoadCodeWithModel:self];
    }
    else if ([self.cls isEqualToString:@"UICollectionView"]) {
        return [AutoToolUICollectionView getLazyLoadCodeWithModel:self];
    }

    return nil;
}

- (NSString *)propertyCode_ButtonSELMethod {
    if (self.newclass.length) {
        return @"";
    }
    if ((![self.cls isEqualToString:@"UIButton"]) || !self.SELMethod) {
        return @"";
    }
    
    NSMutableArray *lines = [NSMutableArray array];
    
    // 创建
    [lines addObject:[NSString stringWithFormat:@"- (void)%@Click:(UIButton *)button {\n    NSLog(@\"%@\", NSStringFromSelector(_cmd));\n",self.name,@"%@"]];

    // 结束
    [lines addObject:[NSString stringWithFormat:@"}\n"]];

    
    if (lines.count == 0) {
        return nil;
    }
    return [lines componentsJoinedByString:@"\n"];
    return nil;
}


/// 代理方法部分
- (NSString *)propertyCode_DelegateMethod {
    if (self.newclass.length) {
        return nil;
    }
    
    
    if ([self.cls isEqualToString:@"UITableView"]) {
        return @"\n# pragma mark - UITableView.dataSource & UITbaleViewDelegate\n- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{\n    return 0;\n}\n- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{\n    return 0;\n}\n- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{\n    return [UITableViewCell new];\n}\n- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {\n    return UITableViewAutomaticDimension;\n}\n- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {\n    return [UIView new];\n}\n- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {\n    return 0.11;\n}\n- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {\n    return [UIView new];\n}\n- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {\n    return 0.11;\n}\n- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {\n    \n}\n";
    }
    else if ([self.cls isEqualToString:@"UICollectionView"]) {
        return @"\n#pragma mark ---- UICollectionViewDataSource\n- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {\n    return 0;\n}\n- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {\n    return 0;\n}\n- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {\n    return nil;\n}\n- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {\n}\n#pragma mark ---- UICollectionViewDelegateFlowLayout\n- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {\n    return CGSizeMake(0, 0);\n}\n//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{\n//    return 0;\n//}\n//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{\n//    return 0;\n//}\n//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{\n//    return UIEdgeInsetsMake(0,5,0,5);;\n//}\n";
    }
    return nil;
}




@end


