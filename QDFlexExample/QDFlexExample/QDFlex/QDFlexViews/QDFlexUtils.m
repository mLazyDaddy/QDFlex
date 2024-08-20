//
//  QDFlexUtils.c
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/20.
//

#import "QDFlexUtils.h"

int QDFlexNSString2Int(NSString* str,
                 QDFlexNameValue table[],
                 int total)
{
    if([str characterAtIndex:0] >= '0' && [str characterAtIndex:0] <= '9'){
        return [str intValue];
    }
    for(int i = 0; i < total; i++){
        if([str isEqualToString:table[i].name]){
            return table[i].value;
        }
    }
    return table[0].value;
}


UIColor* QDFlexColorFromHexString(NSString* colorStr)
{
    if([colorStr hasPrefix:@"#"])
    {
        colorStr = [colorStr substringFromIndex:1];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:colorStr];
    unsigned hex;
    [scanner scanHexInt:&hex];
    
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    int a = colorStr.length>6 ? (hex >> 24)& 0xFF : 255 ;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.0f];
}

NSMutableDictionary<NSString*,UIColor*>* QDGetPredefinedColorMap(void)
{
    static NSMutableDictionary* dict = nil;
    
    if(dict==nil)
    {
        dict = [NSMutableDictionary dictionary];
        
        NSString* clrs[]=
        {
            @"black",   @"0",
            @"white",   @"ffffff",
            @"clear",   @"00000000",
            @"darkGray",@"555555",
            @"lightGray",@"aaaaaa",
            @"gray",    @"808080",
            @"red",     @"ff0000",
            @"green",   @"00ff00",
            @"blue",    @"0000ff",
            @"cyan",    @"00ffff",
            @"yellow",  @"ffff00",
            @"magenta", @"ff00ff",
            @"orange",  @"ff8000",
            @"purple",  @"800080",
            @"brown",   @"996633",
        };

        int total = sizeof(clrs)/sizeof(NSString*) ;
        for(int i=0;i<total;i+=2){
            dict[clrs[i]] = QDFlexColorFromHexString(clrs[i+1]);
        }
    }
    return dict;
}

UIColor* QDFlexSystemColor(NSString* colorStr)
{
    NSString* methodDesc = [NSString stringWithFormat:@"%@Color",colorStr];
    
    SEL sel = NSSelectorFromString(methodDesc) ;
    if(sel == nil)
    {
        NSLog(@"QDFlex: UIColor no method %@",methodDesc);
        return nil;
    }
    
    NSMethodSignature* sig = [UIColor methodSignatureForSelector:sel];
    if(sig == nil)
    {
        NSLog(@"QDFlex: UIColor no method %@",methodDesc);
        return nil;
    }
    
    @try{
        
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig] ;
        [inv setTarget:[UIColor class]];
        [inv setSelector:sel];
        [inv invoke];
        
        UIColor* result;
        [inv getReturnValue:&result];
        return result;
    }@catch(NSException* e){
        NSLog(@"QDFlex: %@ called failed.",methodDesc);
    }
    return nil;
}

UIColor* QDFlexColorFromString(NSString* colorStr)
{
    if(![colorStr hasPrefix:@"#"]){
        
        if([colorStr rangeOfString:@"."].length>0){
            UIImage* image = [UIImage imageNamed:colorStr inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
            if(image == nil){
                NSLog(@"QDFlex: image %@ for color load failed",colorStr);
                return nil;
            }
            return [UIColor colorWithPatternImage:image];
            
        }else{
            
            UIColor* color = [QDGetPredefinedColorMap() objectForKey:colorStr];
            
            if(color==nil)
            {
                NSLog(@"QDFlex: unrecognized color %@",colorStr);
            }
            return color;
        }
    }
    
    return QDFlexColorFromHexString(colorStr);
}
