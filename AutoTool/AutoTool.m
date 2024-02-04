//
//  AutoTool.m
//  AutoTool
//
//  Created by daocaoren on 2022/12/7.
//

#import "AutoTool.h"
#import "AutoToolCreatCodeLine.h"
#import "AutoToolCreatFile.h"
#import "AutoToolCreatViewCode.h"
#import "FCFileManager.h"
#import "AutoToolViewModel.h"
#import "MJExtension.h"

@interface AutoTool()
@property (strong, nonatomic) NSString *jsonPath;
@property (strong, nonatomic) NSArray *jsonModelArray;

@property (strong, nonatomic) NSMutableArray *creatFileArray;
@property (strong, nonatomic) NSMutableArray *propertyArray;
@end


@implementation AutoTool
- (void)creat {
    self.jsonPath = @"/Users/bihairui/Desktop/AutoTool/AutoCodeJson.json";
    NSDictionary *jsonData = [self loadJsonDataPath:self.jsonPath];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSString *key in jsonData.allKeys) {
        NSDictionary *dic = jsonData[key];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [tempDic setValue:key forKey:@"newclass"];
        [modelArray addObject:[AutoToolViewModel mj_objectWithKeyValues:tempDic]];
    }
    
    self.jsonModelArray = [NSArray arrayWithArray:modelArray];
    
    for (AutoToolViewModel *model in self.jsonModelArray) {
        // 根目录下，都创建文件
        [self creatFile:model];
    }
}
/// 加载json数据
- (NSDictionary *)loadJsonDataPath:(NSString *)path {
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *viewDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:viewDic];
    
    for (NSString *keyStr in viewDic.allKeys) {
        if ([keyStr containsString:@"ignore"]) {
            [tempDic removeObjectForKey:keyStr];
        }
    }
    // 处理 creatCells
    [tempDic addEntriesFromDictionary:[self exportCreatCellsInDic:tempDic]];

    return tempDic.copy;
}
- (NSDictionary *)exportCreatCellsInDic:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];

    for (NSString *key in dic.allKeys) {
        NSDictionary *singleView = dic[key];
        NSArray *subView = singleView[@"subView"];
        if (subView.count == 0) {
            continue;
        }
        for (NSDictionary *singleSubViewDic in subView) {
            NSDictionary *creatCells = singleSubViewDic[@"creatCells"];
            if (creatCells.count) {
                [tempDic addEntriesFromDictionary:creatCells];
            }
            [tempDic addEntriesFromDictionary:[self exportCreatCellsInDic:creatCells]];
        }
    }
    return tempDic;
}



/// 创建文件
- (void)creatFile:(AutoToolViewModel *)model {
    [self exportCode:model.getHFileCode fileTpye:@"h" model:model];
    [self exportCode:model.getMFileCode fileTpye:@"m" model:model];
}

///   - type: h or m
- (void)exportCode:(NSString *)codeString fileTpye:(NSString *)type model:(AutoToolViewModel *)model{
    if (model.newclass.length + model.cls.length == 0) {
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-hh-mm"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];

    // 指定要创建的目录的路径
    NSString *directoryPath = @"/Users/YourUserName/Desktop/NewFolder";

    // 创建NSError对象
    NSError *error;

    // 创建新的目录
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];

    // 检查是否有错误
    if (!success) {
        NSLog(@"Error creating directory: %@", error);
    } else {
        NSLog(@"Directory created successfully");
    }

    
    NSString *dirPath = [NSString stringWithFormat:@"%@/exportCode/%@",[self.jsonPath stringByDeletingLastPathComponent],dateString];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@.%@",dirPath,model.getFileName,[type lowercaseString]];
    [codeString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


















- (void)joinPropertyCodeLine {
    NSMutableArray *allPropertyModel = [NSMutableArray array];
    for (NSDictionary *dic in self.propertyArray) {
        ViewCodeModel *model = [AutoToolCreatViewCode getViewCode:dic];
        [model setSuperViewName:@"_backView"];
        [allPropertyModel addObject:model];
    }
    NSMutableArray *viewLine = [NSMutableArray array];
    [viewLine addObject:@"// property ---------"];
    [viewLine addObjectsFromArray:[allPropertyModel valueForKeyPath:@"propertyCode"]];
    [viewLine addObject:@"// addView ---------"];
    [viewLine addObjectsFromArray:[allPropertyModel valueForKeyPath:@"addSubViewCode"]];
    [viewLine addObject:@"// constraint ---------"];
    [viewLine addObjectsFromArray:[allPropertyModel valueForKeyPath:@"constraintsCode"]];
    [viewLine addObject:@"// lazyLoadCode ---------"];
    [viewLine addObjectsFromArray:[allPropertyModel valueForKeyPath:@"lazyLoadCode"]];
    [viewLine addObject:@"// end ---------"];
    NSLog(@"%@",[viewLine componentsJoinedByString:@"\n"]);
    
    
}

#pragma mark - lazyload
- (NSMutableArray *)creatFileArray {
    if (_creatFileArray == nil) {
        _creatFileArray = [NSMutableArray array];
    }
    return _creatFileArray;
}
- (NSMutableArray *)propertyArray {
    if (_propertyArray == nil) {
        _propertyArray = [NSMutableArray array];
    }
    return _propertyArray;
}
@end
