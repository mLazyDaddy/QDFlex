//
//  QDFlexUtils.h
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/20.
//

#ifndef QDFlexUtils_h
#define QDFlexUtils_h

#import <UIKit/UIKit.h>

#define QDFlexSet(propName) \
-(void)setQDFlex##propName:(NSString *)value

#define QDFLEXSETCOLOR(propName)    \
QDFlexSet(propName){    \
self.propName = QDFlexColorFromString(value);  \
}

typedef struct {
    NSString* name;
    int   value;
} QDFlexNameValue;


 int QDFlexNSString2Int(NSString* str,
                 QDFlexNameValue table[],
                        int total);

UIColor* QDFlexColorFromHexString(NSString* colorStr);

NSMutableDictionary<NSString*,UIColor*>* QDGetPredefinedColorMap(void);

UIColor* QDFlexSystemColor(NSString* colorStr);

UIColor* QDFlexColorFromString(NSString* colorStr);

static inline BOOL QDFlexString2BOOL(NSString* str)
{
    return [str compare:@"true" options:NSDiacriticInsensitiveSearch]==NSOrderedSame;
}

#endif /* QDFlexUtils_h */
