//
//  ViewController.m
//  JYInputView
//
//  Created by 伟运体育 on 2017/9/27.
//  Copyright © 2017年 伟运体育. All rights reserved.
//

#import "ViewController.h"
#import "JYInputView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    JYInputView *inputView = [[JYInputView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.addImageAndEmojiBlock = ^(NSInteger tag,NSString *commentStr) {

    };
    
    [self.view addSubview:inputView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
