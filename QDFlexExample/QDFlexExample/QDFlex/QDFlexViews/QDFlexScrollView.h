//
//  QDFlexScrollView.h
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QDFlexRootView;

@interface QDFlexScrollView : UIScrollView
@property(nonatomic,readonly) QDFlexRootView* contentView;

@property(nonatomic,assign) BOOL horizontal;
@property(nonatomic,assign) BOOL vertical;
@end

NS_ASSUME_NONNULL_END
