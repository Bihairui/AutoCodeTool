//
//  AutoToolUILabel.h
//  AutoTool
//
//  Created by daocaoren on 2023/6/27.
//

#import <Foundation/Foundation.h>
#import "AutoToolBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface AutoToolUILabel : NSObject
+ (NSString *)getLazyLoadCodeWithModel:(AutoToolViewModel *)model;

@end

NS_ASSUME_NONNULL_END
