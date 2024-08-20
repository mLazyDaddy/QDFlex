//
//  QDFlexRootView.h
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDFlexRootView : UIView
+(QDFlexRootView *)loadWithFileName:(NSString *)fileName;

- (void)addSubview:(UIView *)view byId:(NSString *)elementId;
- (UIView *)subviewById:(NSString *)elementId;
@property(nonatomic,assign) BOOL useFrame;
@property(nonatomic,assign) UIEdgeInsets safeArea;
@property(nonatomic,copy) UIEdgeInsets (^calcSafeArea)(void);
@property(nonatomic,assign) BOOL flexibleWidth;
@property(nonatomic,assign) BOOL flexibleHeight;

-(void)enableFlexLayout:(BOOL)enable;

@property(nonatomic,copy) void (^beginLayout)(void);
@property(nonatomic,copy) void (^endLayout)(void);

@property(nonatomic,copy) void (^onWillLayout)(void);
@property(nonatomic,copy) void (^onDidLayout)(void);
@end

@interface UIView(QDFlexPublic)
@property(readonly) QDFlexRootView* rootView;
-(void)markDirty;
-(void)enableFlexLayout:(BOOL)enable;
- (void)setElementId:(NSString *)elementId;
- (NSString *)elementId;

- (void)setQDManagerView:(QDFlexRootView *)managerView;
- (QDFlexRootView *)QDManagerView;
@end
NS_ASSUME_NONNULL_END
