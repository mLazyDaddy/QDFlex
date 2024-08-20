//
//  QDFlexParser.h
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QDFlexRootView;

@interface QDFlexParser : NSObject
- (UIView *)parseXMLByName:(NSString *)name andRootView:(QDFlexRootView *)rootView;
@end

NS_ASSUME_NONNULL_END
