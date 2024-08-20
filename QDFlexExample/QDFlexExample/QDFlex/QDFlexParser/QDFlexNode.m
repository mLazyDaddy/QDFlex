//
//  QDFlexNode.m
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/19.
//

#import "QDFlexNode.h"
#import "UIView+Yoga.h"
#import "YGValue.h"
#import "QDFlexUtils.h"
#import "QDFlexAttribute.h"
#import "UIView+QDFlex.h"

#pragma mark - macro

static QDFlexNameValue _direction[] =
{{@"inherit", YGDirectionInherit},
 {@"ltr", YGDirectionLTR},
 {@"rtl", YGDirectionRTL},
};
static QDFlexNameValue _flexDirection[] =
{   {@"col", YGFlexDirectionColumn},
    {@"col-reverse", YGFlexDirectionColumnReverse},
    {@"row", YGFlexDirectionRow},
    {@"row-reverse", YGFlexDirectionRowReverse},
};
static QDFlexNameValue _justify[] =
{   {@"flex-start", YGJustifyFlexStart},
    {@"center", YGJustifyCenter},
    {@"flex-end", YGJustifyFlexEnd},
    {@"space-between", YGJustifySpaceBetween},
    {@"space-around", YGJustifySpaceAround},
    {@"space-evenly", YGJustifySpaceEvenly},
};
static QDFlexNameValue _align[] =
{   {@"auto", YGAlignAuto},
    {@"flex-start", YGAlignFlexStart},
    {@"center", YGAlignCenter},
    {@"flex-end", YGAlignFlexEnd},
    {@"stretch", YGAlignStretch},
    {@"baseline", YGAlignBaseline},
    {@"space-between", YGAlignSpaceBetween},
    {@"space-around", YGAlignSpaceAround},
};
static QDFlexNameValue _positionType[] =
{{@"relative", YGPositionTypeRelative},
    {@"absolute", YGPositionTypeAbsolute},
};

static QDFlexNameValue _wrap[] =
{{@"no-wrap", YGWrapNoWrap},
    {@"wrap", YGWrapWrap},
    {@"wrap-reverse", YGWrapWrapReverse},
};
static QDFlexNameValue _overflow[] =
{{@"visible", YGOverflowVisible},
    {@"hidden", YGOverflowHidden},
    {@"scroll", YGOverflowScroll},
};
static QDFlexNameValue _display[] =
{{@"flex", YGDisplayFlex},
    {@"none", YGDisplayNone},
};

@implementation QDFlexNode
- (id)init{
    self = [super init];
    if(self){
        self.children = [NSMutableArray new];
        self.attributes = [NSMutableArray new];
    }
    return self;
}

static void ApplyLayoutParam(YGLayout *layout,NSString *key,NSString *value){
#define SETENUMVALUE(item,table,type)      \
if([key isEqualToString:(@#item)])                \
{                                        \
layout.item=(type)QDFlexNSString2Int(value,table,sizeof(table)/sizeof(QDFlexNameValue));                  \
return;                                  \
}                                        \

#define SETYGVALUE(item)       \
if([key isEqualToString:(@#item)])       \
{                               \
layout.item= QDString2YGValue(value);\
return;                         \
}                               \

#define SETNUMVALUE(item)       \
if([key isEqualToString:(@#item)])          \
{                               \
layout.item = [value floatValue];     \
return;                         \
}
    
    SETENUMVALUE(direction,_direction,YGDirection);
    SETENUMVALUE(flexDirection,_flexDirection,YGFlexDirection);
    SETENUMVALUE(justifyContent,_justify,YGJustify);
    SETENUMVALUE(alignContent,_align,YGAlign);
    SETENUMVALUE(alignItems,_align,YGAlign);
    SETENUMVALUE(alignSelf,_align,YGAlign);
    SETENUMVALUE(position,_positionType,YGPositionType);
    SETENUMVALUE(flexWrap,_wrap,YGWrap);
    SETENUMVALUE(overflow,_overflow,YGOverflow);
    SETENUMVALUE(display,_display,YGDisplay);

        SETNUMVALUE(flex);
        SETNUMVALUE(flexGrow);
        SETNUMVALUE(flexShrink);

        SETYGVALUE(flexBasis);
        SETYGVALUE(left);
        SETYGVALUE(top);
        SETYGVALUE(right);
        SETYGVALUE(bottom);
        SETYGVALUE(start);
        SETYGVALUE(end);

        SETYGVALUE(marginLeft);
        SETYGVALUE(marginTop);
        SETYGVALUE(marginRight);
        SETYGVALUE(marginBottom);
        SETYGVALUE(marginStart);
        SETYGVALUE(marginEnd);
        SETYGVALUE(marginHorizontal);
        SETYGVALUE(marginVertical);
        SETYGVALUE(margin);
        SETYGVALUE(paddingLeft);
        SETYGVALUE(paddingTop);
        SETYGVALUE(paddingRight);
        SETYGVALUE(paddingBottom);
        SETYGVALUE(paddingStart);
        SETYGVALUE(paddingEnd);
        SETYGVALUE(paddingHorizontal);
        SETYGVALUE(paddingVertical);
        SETYGVALUE(padding);

        SETYGVALUE(width);
        SETYGVALUE(height);
        SETYGVALUE(minWidth);
        SETYGVALUE(minHeight);
        SETYGVALUE(maxWidth);
        SETYGVALUE(maxHeight);

        SETNUMVALUE(aspectRatio);
}
- (void)configLayout{
    NSArray<QDFlexAttribute *> *layouts = self.layouts;
    NSArray<QDFlexAttribute *> *attrs = self.attributes;
    if([self.name isEqualToString:@"UITextField"]){
        int i = 0;
    }
    [self.view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.isIncludedInLayout = YES;
        [layouts enumerateObjectsUsingBlock:^(QDFlexAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ApplyLayoutParam(layout, obj.name, obj.value);
        }];
    }];
    __weak __typeof(self) weakSelf = self;
    [attrs enumerateObjectsUsingBlock:^(QDFlexAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.name isEqualToString:@"borderWidth"]){
            int i = 0;
        }
        QDFlexSetViewAttr(weakSelf.view, obj.name, obj.value);
    }];
    if(self.onPress){
        SEL sel = NSSelectorFromString([@"QD_" stringByAppendingString:self.onPress]);
        if(sel!=nil){
            if([self.view respondsToSelector:sel]){
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self.view action:sel];
                tap.cancelsTouchesInView = NO;
                tap.delaysTouchesBegan = NO;
                [self.view addGestureRecognizer:tap];
            }
        }
    }
}

- (void)postCreate{
    [self.view postCreate];
}

#pragma mark utils

static YGValue QDString2YGValue(NSString *s)
{
    if([s isEqualToString:@"none"])
    {
        return (YGValue) { .value = NAN, .unit = YGUnitUndefined };
        
    }else if([s isEqualToString:@"auto"]){
        return (YGValue) { .value = NAN, .unit = YGUnitAuto };
        
    }
    
    int len = (int) (s.length) ;
    if(len == 0 || len > 100){
        NSLog(@"QDFlex: wrong number or pecentage value:%@",s);
        return YGPointValue(0);
    }
    if( [s characterAtIndex:(len-1)] == '%' ){
        NSString *dest = [s substringToIndex:len - 1];
        return YGPercentValue([dest floatValue]);
    }
    return YGPointValue([s floatValue]);
}

void QDFlexSetViewAttr(UIView* view,
                     NSString* attrName,
                     NSString* attrValue)
{
    NSString* methodDesc = [NSString stringWithFormat:@"setQDFlex%@:",attrName];
    
    SEL sel = NSSelectorFromString(methodDesc) ;
    if(sel == nil)
    {
        NSLog(@"QDFlex: %@ no method %@",[view class],methodDesc);
        return ;
    }
    
    // avoid performSelector, because maybe blocked by Apple.
    
    NSMethodSignature* sig = [[view class] instanceMethodSignatureForSelector:sel];
    if(sig == nil)
    {
        NSLog(@"QDFlex: %@ no method %@",[view class],methodDesc);
        return ;
    }
            
    @try{
        
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig] ;
        [inv setTarget:view];
        [inv setSelector:sel];
        [inv setArgument:&attrValue atIndex:2];
        
        [inv invoke];
    }@catch(NSException* e){
        NSLog(@"QDFlex: **** exception occur in %@::%@ property *** \r\nReason - %@.\r\n",[view class],attrName,[e reason]);
    }
}
@end
