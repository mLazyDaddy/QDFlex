//
//  ViewController.m
//  QDFlexExample
//
//  Created by lazyDaddy on 2024/8/19.
//

#import "ViewController.h"
#import "QDFlexParser.h"
#import "QDFlexRootView.h"
@interface ViewController ()
@property(nonatomic,strong)QDFlexRootView *rootView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    
    self.rootView = [QDFlexRootView loadWithFileName:@"view1"];
    [self.view addSubview:self.rootView];
    [self.rootView setNeedsLayout];
    [self.rootView layoutIfNeeded];
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    NSLog(@"layout cost %f seconds",(end - begin));
}


@end
