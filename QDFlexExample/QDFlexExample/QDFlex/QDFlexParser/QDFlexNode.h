//
//  QDFlexNode.h
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QDFlexAttribute;
NS_ASSUME_NONNULL_BEGIN

@interface QDFlexNode : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *nodeId;
@property(nonatomic,weak) QDFlexNode *superNode;
@property (nonatomic,copy) NSString* onPress;
@property(nonatomic,strong) NSMutableArray<QDFlexNode *> *children;
@property(nonatomic,strong) NSMutableArray<QDFlexAttribute *> *attributes;
@property(nonatomic,strong) NSMutableArray<QDFlexAttribute *> *layouts;

@property(nonatomic,strong) UIView *view;

- (void)configLayout;
- (void)postCreate;
@end

NS_ASSUME_NONNULL_END
