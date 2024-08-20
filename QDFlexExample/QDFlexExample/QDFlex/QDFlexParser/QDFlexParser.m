//
//  QDFlexParser.m
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/19.
//

#import "QDFlexParser.h"

#import <libxml/parser.h>

#import "QDFlexRootView.h"
#import "QDFlexNode.h"
#import "QDFlexAttribute.h"
#import "QDFlexViewManager.h"

@interface QDFlexParser(){
    const xmlChar *_eleName;
    NSMutableArray<QDFlexNode*> *_stack;
    QDFlexNode *_rootNode;
    QDFlexNode *_lastElement;
}

@property(nonatomic,weak) QDFlexRootView *rootView;
@end

@implementation QDFlexParser
- (instancetype)init{
    self = [super init];
    if(self){
        _stack = [NSMutableArray new];
    }
    return self;
}

- (UIView *)parseXMLByName:(NSString *)name andRootView:(QDFlexRootView *)rootView{
    _rootView = rootView;
    if(name == nil) return nil;
    NSString *filepath = [[NSBundle mainBundle] pathForResource:name ofType:@"xml"];
    const char *filename = [filepath UTF8String];
    
    xmlSAXHandler saxHandler;
    memset(&saxHandler, 0, sizeof(saxHandler));
    saxHandler.startElement = QDStartElementSAX2Func;
    saxHandler.endElement = QDEndElementSAX2Func;
    saxHandler.initialized = XML_SAX2_MAGIC;
    xmlDocPtr doc = xmlSAXParseFileWithData(&saxHandler, filename, 0, (void *)CFBridgingRetain(self));
    xmlFreeDoc(doc);
    CFBridgingRelease((__bridge CFTypeRef _Nullable)(self));
    return _rootNode.view;
}

static void  QDStartElementSAX2Func(void * ctx,
                                    const xmlChar * name,
                                    const xmlChar ** attributes){
    QDFlexParser *parser = (__bridge QDFlexParser *)(((xmlParserCtxtPtr)ctx)->_private);
    QDFlexNode *node = [[QDFlexNode alloc] init];
    if(parser->_rootNode == NULL) parser->_rootNode = node;
    @try {
        if(name != NULL){
            node.name = [NSString stringWithUTF8String:(const char *)name];
            NSString *className = [QDFlexViewManager classNameByTypeName:node.name];
            if(className != nil){
                UIView *view = [[NSClassFromString(className) alloc] init];
                node.view = view;
            }
            [parser->_stack addObject:node];
        }
    } @catch (NSException *exception) {}
    int i = 0;
    while (attributes!= NULL && attributes[i] != NULL) {
        const xmlChar *attr_name = attributes[i];
        const xmlChar *attr_value = attributes[i + 1];
        if(attr_name != NULL && attr_value != NULL){
            NSString *name = [NSString stringWithUTF8String:(const char *)attr_name];
            NSString *value = [NSString stringWithUTF8String:(const char *)attr_value];
            
            if([name compare:@"layout" options:NSCaseInsensitiveSearch] == NSOrderedSame){
                NSMutableArray *layouts = [QDFlexParser parseStringParams:value];
                if(layouts.count > 0){
                    node.layouts = layouts;
                }
            }else if ([name compare:@"attr" options:NSCaseInsensitiveSearch] == NSOrderedSame){
                NSMutableArray *attrs = [QDFlexParser parseStringParams:value];
                if(attrs.count > 0){
                    node.attributes = attrs;
                }
            }else if ([name compare:@"onPress" options:NSCaseInsensitiveSearch] == NSOrderedSame){
                if(value.length > 0){
                    node.onPress = value;
                }
            }else if ([name compare:@"nodeId" options:NSCaseInsensitiveSearch] == NSOrderedSame){
                if(value.length > 0){
                    node.nodeId = value;
                }
            }
        }
        i += 2;
    }
}

static void  QDEndElementSAX2Func (void * ctx,
                                     const xmlChar * name){
    QDFlexParser *parser = (__bridge QDFlexParser *)(((xmlParserCtxtPtr)ctx)->_private);
    QDFlexNode *node = [parser->_stack lastObject];
    [parser->_stack removeLastObject];
    QDFlexNode *last = [parser->_stack lastObject];
    [last.children addObject:node];
    node.superNode = last;
    [last.view addSubview:node.view];
    if(node.nodeId.length > 0){
        [parser.rootView addSubview:node.view byId:node.nodeId];
    }
    [node.view setQDManagerView:parser.rootView];
    [node configLayout];
    [node postCreate];
}

#pragma mark -
+ (NSMutableArray *)parseStringParams:(NSString *)param{
    if(param.length == 0) return nil;
    
    NSMutableArray *result = [NSMutableArray new];
    NSArray *attrs = [QDFlexParser seperateByComma:param];
    NSCharacterSet *whiteSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    for(NSString * attr in attrs){
        NSRange range = [attr rangeOfString:@":"];
        if(range.length == 0) continue;
        
        NSString *s1 = [attr substringToIndex:range.location];
        NSString *s2 = [attr substringFromIndex:range.location + 1];
        
        QDFlexAttribute *attr = [QDFlexAttribute new];
        attr.name = [s1 stringByTrimmingCharactersInSet:whiteSet];
        attr.value = [s2 stringByTrimmingCharactersInSet:whiteSet];
        
        if(attr.name && attr.value){
            [result addObject:attr];
        }
    }
    return result;
}

+ (NSArray *)seperateByComma:(NSString *)str{
    NSMutableArray *result = [NSMutableArray new];
    
    int m = 0;
    int n;
    while(m < str.length){
        for( n = m; n < str.length; n++){
            unichar c = [str characterAtIndex:n];
            if(c == ',') break;;
            if(c == '\\')
                n++;
        }
        if(n >= str.length){
            [result addObject:[str substringFromIndex:m]];
            break;
        }
        if(n > m ){
            NSRange range = NSMakeRange(m, n - m);
            [result addObject:[str substringWithRange:range]];
        }
        m = n + 1;
    }
    return result;
}
@end
