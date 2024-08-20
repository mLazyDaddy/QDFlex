//
//  UIButton+QDFlex.m
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/20.
//

#import "UIButton+QDFlex.h"
#import "QDFlexUtils.h"

@implementation UIButton (QDFlex)
QDFlexSet(text)
{
    [self setTitle:value forState:UIControlStateNormal];
}
QDFlexSet(title)
{
    [self setTitle:value forState:UIControlStateNormal];
}
QDFlexSet(color)
{
    UIColor* clr = QDFlexColorFromString(value);
    if(clr!=nil){
        [self setTitleColor:clr forState:UIControlStateNormal];
    }
}
@end
