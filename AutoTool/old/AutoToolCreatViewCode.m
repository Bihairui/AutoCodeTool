//
//  AutoToolCreatViewCode.m
//  AutoTool
//
//  Created by daocaoren on 2022/12/7.
//

#import "AutoToolCreatViewCode.h"
#import "AutoToolSetProperty.h"

@implementation ViewCodeModel
- (void)setSuperViewName:(NSString *)superViewName {
    self.addSubViewCode = [self.addSubViewCode stringByReplacingOccurrencesOfString:@"superView" withString:superViewName];
}
@end




@implementation AutoToolCreatViewCode
+ (ViewCodeModel *)getViewCode:(NSDictionary *)dic {
    NSString *class = dic[@"class"];
    if ([class isEqualToString:@"UIView"]) {
        return [self creatCode_UIView:dic];
    }
    
    return nil;
}


+ (ViewCodeModel *)creatCode_UIView:(NSDictionary *)dic {

    ViewCodeModel *model = [ViewCodeModel new];
    
    // property
    NSString *class = dic[@"class"];
    
    NSString *defName = [class substringFromIndex:2];
    defName = [NSString stringWithFormat:@"%@%@",[defName substringToIndex:1].lowercaseString,[defName substringFromIndex:1]];
    NSString *name = [dic[@"propertyName"] length] ? [dic[@"propertyName"] stringByReplacingOccurrencesOfString:@"=" withString:@"view"] : defName;
    NSString *propertyCode = [NSString stringWithFormat:@"@property (strong, nonatomic) %@ *%@;",class,name];
    model.propertyCode = propertyCode;
    
    
    
    // addSubView
    NSString *addSubViewCodead = [NSString stringWithFormat:@"[superView addSubview:self.%@];",name];
    model.addSubViewCode = addSubViewCodead;
    
    
    
    
    // layout Constraint
    NSDictionary *layout = dic[@"layout"];
    NSMutableArray *chosenKeyCode = [NSMutableArray array];
    for (NSString *key in layout.allKeys) {
        if ([layout[key] boolValue]) {
            NSString *left = @"<#";
            NSString *right = @"#>";
            [chosenKeyCode addObject:[NSString stringWithFormat:@"make.%@.mas_equalTo(%@self.%@)%@.offset(%@;",key,left,right,left,right]];
        }
    }
    NSString *makeCodeString = [chosenKeyCode componentsJoinedByString:@"\n"];
    NSString *constraintsCode = [NSString stringWithFormat:@"[self.%@  mas_makeConstraints:^(MASConstraintMaker *make) {\n%@\n}];",name,makeCodeString];
    model.constraintsCode = constraintsCode;
    
    
    
    
    // lazyload
    NSMutableArray *viewPropertyCode = [NSMutableArray array];
    
    
    
    [viewPropertyCode addObject:[AutoToolSetProperty getBgColorViewName:[NSString stringWithFormat:@"_%@",name] dic:dic] ?: @""];
    [viewPropertyCode addObject:[AutoToolSetProperty getCornerViewName:[NSString stringWithFormat:@"_%@",name] dic:dic] ?: @""];
    [viewPropertyCode addObject:[AutoToolSetProperty getBorderViewName:[NSString stringWithFormat:@"_%@",name] dic:dic] ?: @""];
    
    NSString *viewPropertyCodeStr = [viewPropertyCode componentsJoinedByString:@"\n"];
    NSString *lazyLoadCode = [NSString stringWithFormat:@"- (%@ *)%@ {\nif (_%@ == nil) {\n%@\n}\nreturn _%@",class,name,name,viewPropertyCodeStr,name];
    model.lazyLoadCode = lazyLoadCode;
    
    return model;
}
@end
