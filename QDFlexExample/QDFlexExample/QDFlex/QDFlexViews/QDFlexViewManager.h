//
//  QDFlexViewManager.h
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDFlexViewManager : NSObject
+ (QDFlexViewManager *)shareInstance;
+ (void)registClass:(NSString *)className forTypeName:(NSString *)typeName;
+ (NSString *)classNameByTypeName:(NSString *)typeName;
@end


#define QDRegister(className,typeName) \
[QDFlexViewManager registClass:className forTypeName:typeName]
NS_ASSUME_NONNULL_END
