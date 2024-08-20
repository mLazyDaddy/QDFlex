//
//  QDFlexScrollView.m
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/20.
//

#import "QDFlexScrollView.h"
#import "QDFlexRootView.h"
#import "UIView+Yoga.h"
#import "QDFlexUtils.h"

@interface QDFlexScrollView(){
    QDFlexRootView *_contentView;
}
@end

@implementation QDFlexScrollView
- (instancetype)init{
    self = [super init];
    if(self){
        __weak __typeof(self) weakSelf = self;
        _contentView = [[QDFlexRootView alloc] init];
        [_contentView enableFlexLayout:YES];
        _contentView.onDidLayout = ^{
            [weakSelf onContentViewDidLayout];
        };
        [super addSubview:_contentView];
    }
    return self;
}

-(void)onContentViewDidLayout
{
    self.contentSize = _contentView.frame.size;
}

-(void)postCreate
{
    // let child has chance to process touch event
    self.canCancelContentTouches = YES;
    self.delaysContentTouches = NO;
    if (@available(iOS 11.0, *))
    {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever ;
    }
    
#define COPYYGVALUE(prop)           \
if(from.prop.unit==YGUnitPoint||    \
    from.prop.unit==YGUnitPercent)  \
{                                   \
    to.prop = from.prop;            \
}                                   \

    YGLayout* from = self.yoga ;
    YGLayout* to = _contentView.yoga ;
    
    to.direction = from.direction ;
    to.flexDirection = from.flexDirection;
    to.justifyContent = from.justifyContent;
    to.alignItems = from.alignItems;
    to.alignContent = from.alignContent;
    to.flexWrap = from.flexWrap;
    to.overflow = from.overflow;
    to.display = from.display;
    
    COPYYGVALUE(paddingLeft)
    COPYYGVALUE(paddingTop)
    COPYYGVALUE(paddingRight)
    COPYYGVALUE(paddingBottom)
    COPYYGVALUE(paddingStart)
    COPYYGVALUE(paddingEnd)
    COPYYGVALUE(paddingHorizontal)
    COPYYGVALUE(paddingVertical)
    COPYYGVALUE(padding)
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    CGRect rc = _contentView.frame;
    if(!self.vertical)
        rc.size.height = CGRectGetHeight(frame);
    if(!self.horizontal)
        rc.size.width = CGRectGetWidth(frame);
    if(!CGSizeEqualToSize(rc.size,_contentView.frame.size)){
        _contentView.frame = rc;
    }
}

-(void)addSubview:(UIView *)view
{
    [_contentView addSubview:view];
}
-(void)removeSubView:(UIView*)view
{
    [view removeFromSuperview];
}

QDFlexSet(horzScroll){
    BOOL b = QDFlexString2BOOL(value);
    self.horizontal = b;
    _contentView.flexibleWidth = b;
}

QDFlexSet(vertScroll){
    BOOL b = QDFlexString2BOOL(value);
    self.vertical = b;
    _contentView.flexibleHeight = b;
}
@end
