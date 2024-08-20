//
//  UITextField+QDFlex.m
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/20.
//

#import "UITextField+QDFlex.h"
#import "UIView+QDFlex.h"
#import "QDFlexUtils.h"

@implementation UITextField (QDFlex)
QDFlexSet(text){
    self.text = value;
}

QDFlexSet(value){
    self.text = value;
}

QDFlexSet(fontSize){
    float f = [value floatValue];
    if(f > 0){
        UIFont* font = [UIFont systemFontOfSize:f];
        self.font = font;
    }
}

QDFlexSet(color)
{
    UIColor* color = QDFlexColorFromString(value);
    if(color != nil){
        self.textColor = color ;
    }
}
@end
