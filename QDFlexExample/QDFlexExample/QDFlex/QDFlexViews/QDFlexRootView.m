//
//  QDFlexRootView.m
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/19.
//

#import "QDFlexRootView.h"
#import "QDFlexNode.h"
#import "QDFlexParser.h"
#import "UIView+Yoga.h"
#import <objc/runtime.h>

@interface QDFlexRootView(){
    BOOL _isChildDirty;
    bool _isLayouting;
    CGRect _lastConfigFrame;
    CGRect _thisConfigFrame;
    NSMapTable *_allSubviews;
}
@end

@implementation QDFlexRootView
- (instancetype)init{
    self = [super init];
    if(self){
        _safeArea = UIEdgeInsetsMake(0, 0, 0, 0);
        _lastConfigFrame = CGRectZero;
        _isChildDirty = NO;
        _useFrame = NO;
        _allSubviews = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:10];
        [self enableFlexLayout:NO];
    }
    return self;
}

-(BOOL)loadWithFileName:(NSString *)fileName Owner:(NSObject *)owner{
    if(fileName == nil){
        fileName = NSStringFromClass([owner class]);
    }
    
    return false;
}

+ (QDFlexRootView *)loadWithFileName:(NSString *)fileName{
    QDFlexParser *parser = [QDFlexParser new];
    QDFlexRootView *rootView = [QDFlexRootView new];
    [rootView enableFlexLayout:YES];
    UIView *subView = [parser parseXMLByName:fileName andRootView:rootView];
    [rootView addSubview:subView];
    return rootView;
}

- (void)qdApplyLayout{
    if(_isLayouting) return;
    
    enum YGDimensionFlexibility option = 0 ;
    if(self.flexibleWidth)
        option |= YGDimensionFlexibilityFlexibleWidth ;
    if(self.flexibleHeight)
        option |= YGDimensionFlexibilityFlexibleHeight ;
    
    _lastConfigFrame = _thisConfigFrame;
    
    [self configureLayout:[self getSafeArea]];
    BOOL configSame = [self isConfigSame];
    if(!_isChildDirty && configSame){
        return;
    }
    
    _isLayouting = YES;
    
    if(self.beginLayout != nil){
        self.beginLayout();
    }
    
    if(self.onWillLayout != nil){
        self.onWillLayout();
    }
    
    [self enableFlexLayout:YES];
    [self.yoga applyLayoutPreservingOrigin:NO dimensionFlexibility:option];
    [self enableFlexLayout:NO];
    
    if(self.endLayout != nil){
        self.endLayout();
    }
    
    if(self.onDidLayout != nil){
        self.onDidLayout();
    }
    
    self.beginLayout = nil;
    self.endLayout = nil;
    
    _isLayouting = NO;
    _isChildDirty = NO;
}

-(BOOL)isConfigSame
{
    return memcmp(&_thisConfigFrame, &_lastConfigFrame, sizeof(CGRect))==0;
}

- (void)layoutSubviews{
    [self qdApplyLayout];
}

- (void)safeAreaInsetsDidChange{
    
}

-(void)configureLayout:(CGRect)safeArea
{
    [self configureLayoutWithBlock:^(YGLayout* layout){
        
        layout.left = YGPointValue(safeArea.origin.x) ;
        layout.top = YGPointValue(safeArea.origin.y);
        
        if(self.flexibleWidth)
            layout.width = YGPointValue(NAN);
        else
            layout.width = YGPointValue(safeArea.size.width) ;
        
        if(self.flexibleHeight)
            layout.height = YGPointValue(NAN);
        else
            layout.height = YGPointValue(safeArea.size.height) ;
        
        self->_thisConfigFrame = CGRectMake(layout.left.value, layout.top.value, layout.width.value, layout.height.value);
    }];
}

-(CGRect)getSafeArea
{
    CGRect rcSafeArea ;
    
    if (self.useFrame) {
        rcSafeArea = self.frame;
    } else {
        rcSafeArea = self.superview.frame ;
        rcSafeArea.origin = CGPointZero;
        if(self.calcSafeArea!=nil)
        {
            rcSafeArea = UIEdgeInsetsInsetRect(rcSafeArea,self.calcSafeArea());
        }else{
            rcSafeArea = UIEdgeInsetsInsetRect(rcSafeArea,self.safeArea);
        }
    }
    return rcSafeArea;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)markChildDirty:(UIView*)child
{
    [child.yoga markDirty];
    _isChildDirty = YES;
    [self setNeedsLayout];
}

- (void)addSubview:(UIView *)view byId:(NSString *)elementId{
    [_allSubviews setObject:view forKey:elementId];
    [view setElementId:elementId];
}

- (UIView *)subviewById:(NSString *)elementId{
    return [_allSubviews objectForKey:elementId];
}
@end

static const void *kQDFlexNodeIdAssociatedKey = &kQDFlexNodeIdAssociatedKey;
static const void *kQDFlexManagerViewAssociatedKey = &kQDFlexManagerViewAssociatedKey;

@implementation UIView (QDFlexPublic)
- (void)setNodeId:(NSString *)nodeId{
    objc_setAssociatedObject(self, kQDFlexNodeIdAssociatedKey, nodeId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)nodeId{
    return objc_getAssociatedObject(self,kQDFlexNodeIdAssociatedKey);
}


- (void)setQDManagerView:(QDFlexRootView *)managerView{
    objc_setAssociatedObject(self, kQDFlexManagerViewAssociatedKey, managerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QDFlexRootView *)QDManagerView{
    return objc_getAssociatedObject(self,kQDFlexManagerViewAssociatedKey);
}

-(QDFlexRootView*)rootView
{
    UIView* parent = self;
    while(parent!=nil){
        if([parent isKindOfClass:[QDFlexRootView class]]){
            return (QDFlexRootView*)parent;
        }
        parent = parent.superview;
    }
    return nil;
}

-(void)markDirty
{
    QDFlexRootView* rootView = self.rootView;
    if(rootView != nil){
        UIView* leaf = [self findLeaf];
        if(leaf != nil){
            [rootView markChildDirty:leaf];
        }
    }
}

-(UIView*)findLeaf
{
    if(self.yoga.isLeaf)
        return self;
    
    for (UIView* subview in self.subviews) {
        UIView* leaf = [subview findLeaf];
        if(leaf != nil)
            return leaf;
    }
    return nil;
}

-(void)enableFlexLayout:(BOOL)enable
{
    [self configureLayoutWithBlock:^(YGLayout* layout){
    
        layout.isIncludedInLayout = enable;
        layout.isEnabled = enable;
        
    }];
}
@end
