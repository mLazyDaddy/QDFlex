//
//  UIView+QDFlex.m
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/20.
//

#import "UIView+QDFlex.h"
#import "QDFlexUtils.h"
#import "UIView+Yoga.h"

@implementation UIView (QDFlex)
- (void)postCreate{}

QDFlexSet(bgColor){
    UIColor *color = QDFlexColorFromString(value);
    if(color != nil){
        self.backgroundColor = color;
    }
}

QDFlexSet(borderWidth){
    CGFloat f = [value floatValue];
    self.layer.borderWidth = f;
}

QDFlexSet(borderColor){
    UIColor *color = QDFlexColorFromString(value);
    self.layer.borderColor = color.CGColor;
}

QDFlexSet(borderRadius){
    CGFloat f = [value floatValue];
    self.layer.cornerRadius = f;
}
@end
