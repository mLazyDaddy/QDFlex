//
//  UILabel+QDFlex.m
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/20.
//

#import "UILabel+QDFlex.h"
#import "QDFlexUtils.h"

@implementation UILabel (QDFlex)
QDFlexSet(text){
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

QDFlexSet(linesNum){
    int n = (int)[value integerValue];
    if(n >= 0){
        self.numberOfLines = 0;
    }
}
@end
