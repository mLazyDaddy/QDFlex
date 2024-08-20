//
//  QDFlexViewManager.m
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/20.
//

#import "QDFlexViewManager.h"

@interface QDFlexViewManager()
@property(nonatomic,strong) NSMutableDictionary *registerDict;
@end

@implementation QDFlexViewManager
+ (QDFlexViewManager *)shareInstance{
    static dispatch_once_t onceToken;
    static QDFlexViewManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDFlexViewManager new];
    });
    return instance;
}

- (id)init{
    self = [super init];
    if(self){
        self.registerDict = [NSMutableDictionary new];
    }
    return self;
}

+ (void)registClass:(NSString *)className forTypeName:(NSString *)typeName{
    NSAssert(className != nil && typeName != nil, @"className & typeName should not be nil");
    NSAssert([[self shareInstance].registerDict objectForKey:typeName] == nil, @"duplicate dynamic type");
    if(className && typeName){
        [[self shareInstance].registerDict setObject:className forKey:typeName];
    }
}

+ (NSString *)classNameByTypeName:(NSString *)typeName{
    NSString *className = [[self shareInstance].registerDict objectForKey:typeName];
    if(className == nil){
        className = typeName;
    }
    return className;
}

@end
