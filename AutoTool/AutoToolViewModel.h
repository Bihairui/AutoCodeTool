//
//  AutoToolViewModel.h
//  AutoTool
//
//  Created by daocaoren on 2023/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface AutoToolViewModel : NSObject
@property (strong, nonatomic)  NSString *cls;
@property (strong, nonatomic)  NSString *newclass;
@property (strong, nonatomic)  NSString *name;
@property (strong, nonatomic)  NSString *bgColor;
@property (strong, nonatomic)  NSString *textColor;
@property (strong, nonatomic)  NSString *font;
@property (strong, nonatomic)  NSString *text;
@property (strong, nonatomic)  NSString *image;
@property (strong, nonatomic)  NSString *backgroundImage;
@property (assign, nonatomic)  BOOL alignmentCenter;
@property (assign, nonatomic)  BOOL linesNumberZero;
@property (assign, nonatomic)  BOOL hugging;
@property (assign, nonatomic)  BOOL compress;
@property (assign, nonatomic)  BOOL hideVerticalScrollIndicator;
@property (assign, nonatomic)  BOOL hideHorizontalScrollIndicator;
@property (assign, nonatomic)  BOOL SELMethod;


@property (strong, nonatomic)  NSString *cornerRadius;
@property (assign, nonatomic)  BOOL masksToBounds;
@property (strong, nonatomic)  NSString *borderColor;
@property (strong, nonatomic)  NSString *borderWidth;

@property (strong, nonatomic)  NSArray *creatCells;

@property (strong, nonatomic)  NSDictionary *layout;
@property (strong, nonatomic)  NSArray *subView;
@property (strong, nonatomic) NSString *subviewSuperView;



#pragma mark - 工具方法
- (NSString *)getFileName;



#pragma mark - 代码输出

- (NSString *)getHFileCode;
- (NSString *)getMFileCode;

- (NSString *)propertyCode_property;
- (NSString *)propertyCode_addSubView;
- (NSString *)propertyCode_masonry;
- (NSString *)propertyCode_lazyLoad;


- (NSString *)propertyCode_ButtonSELMethod;
- (NSString *)propertyCode_DelegateMethod;


@end








NS_ASSUME_NONNULL_END
