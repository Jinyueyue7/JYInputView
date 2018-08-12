//
//  JYInputView.m
//  JYInputView
//
//  Created by 伟运体育 on 2017/9/27.
//  Copyright © 2017年 伟运体育. All rights reserved.
//

#import "JYInputView.h"

#define YY_ScaleWidth(x) x*[UIScreen mainScreen].bounds.size.width/375/2 //页面布局尺寸比例

@interface JYInputView ()<UITextViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UILabel *label;

@property (nonatomic,strong)UIButton *emojiBtn;

@property (nonatomic,strong)UIButton *imageBtn;

@property (nonatomic,assign)CGFloat topH;

@property (nonatomic,assign)CGFloat textViewH;

@property (nonatomic,assign)CGFloat scrollH;

@property (nonatomic,assign)CGFloat keyboadH;

@end

@implementation JYInputView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
        self.topH = [UIScreen mainScreen].bounds.size.height-YY_ScaleWidth(80);
        self.textViewH = YY_ScaleWidth(60);
        
        //监听弹出键盘
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillShow:)
         
                                                     name:UIKeyboardWillShowNotification
         
                                                   object:nil];
        //可以监听收回键盘
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillHide:)
         
                                                     name:UIKeyboardWillHideNotification
         
                                                   object:nil];
    }
    return self;
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    //创建自带来获取穿过来的对象的info配置信息
    NSDictionary *userInfo = [aNotification userInfo];
    
    //创建value来获取 userinfo里的键盘frame大小
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    //创建cgrect 来获取键盘的值
    CGRect keyboardRect = [aValue CGRectValue];
    
    //最后获取高度
    self.keyboadH = keyboardRect.size.height;
}

-(void)keyboardWillHide:(NSNotification *)aNotification
{
    self.keyboadH = 0;
}

-(void)createView
{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(YY_ScaleWidth(35), YY_ScaleWidth(10), self.bounds.size.width-YY_ScaleWidth(215), YY_ScaleWidth(60))];
    self.textView.layer.cornerRadius = 4.0;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = YY_ScaleWidth(2);
    self.textView.font = [UIFont systemFontOfSize:YY_ScaleWidth(24)];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.textView];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(YY_ScaleWidth(15), 0, self.textView.bounds.size.width-2*YY_ScaleWidth(15), YY_ScaleWidth(60)) ];
    self.label.text = @"写评论";
    self.label.font = [UIFont systemFontOfSize:YY_ScaleWidth(24)];
    self.label.textColor = [UIColor grayColor];
    [self.textView addSubview:self.label];
    
    self.emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.emojiBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame)+YY_ScaleWidth(10), self.bounds.size.height-YY_ScaleWidth(80), YY_ScaleWidth(70), YY_ScaleWidth(80));
    [self.emojiBtn setImage:[UIImage imageNamed:@"icon_图片_"] forState:UIControlStateNormal];
    [self.emojiBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.emojiBtn.tag = 11;
    [self addSubview:self.emojiBtn];
    
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageBtn.frame = CGRectMake(CGRectGetMaxX(self.emojiBtn.frame), self.bounds.size.height-YY_ScaleWidth(80), YY_ScaleWidth(70), YY_ScaleWidth(80));
    [self.imageBtn setImage:[UIImage imageNamed:@"icon_发送_"] forState:UIControlStateNormal];
    [self.imageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.imageBtn.tag = 10;
    [self addSubview:self.imageBtn];
}

-(void)btnClick:(UIButton *)btn
{
    [self.textView resignFirstResponder];
    if (self.addImageAndEmojiBlock) {
        [self downContractionInputView];
        self.addImageAndEmojiBlock(btn.tag,self.textView.text);
    }
}

#pragma mark 添加图片
-(void)setPhotos:(NSArray *)array
{
    if (self.scrollH ==0) {
        self.frame = CGRectMake(0, self.topH-YY_ScaleWidth(150), self.bounds.size.width, self.bounds.size.height+YY_ScaleWidth(150));
        self.scrollView.frame = CGRectMake(YY_ScaleWidth(35), YY_ScaleWidth(20), self.bounds.size.width-YY_ScaleWidth(215), YY_ScaleWidth(120));
        self.textView.frame = CGRectMake(YY_ScaleWidth(35), CGRectGetMaxY(self.scrollView.frame)+YY_ScaleWidth(20), self.bounds.size.width-YY_ScaleWidth(215), self.textViewH);
        self.imageBtn.frame = CGRectMake(CGRectGetMaxX(self.emojiBtn.frame), self.bounds.size.height-YY_ScaleWidth(80), YY_ScaleWidth(70), YY_ScaleWidth(80));
        self.emojiBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame)+YY_ScaleWidth(10), self.bounds.size.height-YY_ScaleWidth(80), YY_ScaleWidth(70), YY_ScaleWidth(80));
    }
    self.scrollH = YY_ScaleWidth(120);
    
    for (int i = 0; i<array.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YY_ScaleWidth(120), YY_ScaleWidth(120))];
        imageV.image = array[i];
    }
}

//发送成功之后清楚现有输入数据
-(void)clearData
{
    self.scrollH = 0;
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-YY_ScaleWidth(80), [UIScreen mainScreen].bounds.size.width, YY_ScaleWidth(80));
    self.scrollView.frame = CGRectMake(YY_ScaleWidth(35), 0, self.bounds.size.width-YY_ScaleWidth(215), YY_ScaleWidth(0));
    self.textView.frame = CGRectMake(YY_ScaleWidth(35), CGRectGetMaxY(self.scrollView.frame)+YY_ScaleWidth(10), self.bounds.size.width-YY_ScaleWidth(215), self.textViewH);
    self.imageBtn.frame = CGRectMake(CGRectGetMaxX(self.emojiBtn.frame), self.bounds.size.height-YY_ScaleWidth(80), YY_ScaleWidth(70), YY_ScaleWidth(80));
    self.emojiBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame)+YY_ScaleWidth(10), self.bounds.size.height-YY_ScaleWidth(80), YY_ScaleWidth(70), YY_ScaleWidth(80));
    
    self.topH = CGRectGetMinY(self.frame);
    
    self.textView.text = @"";
    self.label.text = @"写评论";
}

#pragma mark textView的return响应
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        [self textViewDidEndEditing:textView];
        
        [self downContractionInputView];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length<=0) {
        self.label.text = @"写评论";
    }else{
        self.label.text = @"";
    }
    
    CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(self.bounds.size.width-YY_ScaleWidth(220), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:YY_ScaleWidth(24)]} context:nil];
    
    CGFloat height = rect.size.height+YY_ScaleWidth(20);
    if (height>YY_ScaleWidth(60)) {
        
        if (self.textViewH != height) {
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-YY_ScaleWidth(30)-height-self.keyboadH, self.bounds.size.width, height+YY_ScaleWidth(30));
            self.textViewH = height;
            
            self.textView.frame = CGRectMake(YY_ScaleWidth(35), YY_ScaleWidth(10), self.bounds.size.width-YY_ScaleWidth(215), height);
            
            self.imageBtn.frame = CGRectMake(CGRectGetMaxX(self.emojiBtn.frame), self.bounds.size.height-YY_ScaleWidth(80), YY_ScaleWidth(70), YY_ScaleWidth(80));
            self.emojiBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame)+YY_ScaleWidth(10), self.bounds.size.height-YY_ScaleWidth(80), YY_ScaleWidth(70), YY_ScaleWidth(80));
            
            self.topH = CGRectGetMinY(self.frame);
        }
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self popInputView];
}

//完成编辑的时候下移回来（只要把offset重新设为0就行了）
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    [self downContractionInputView];
    [textView resignFirstResponder];
}

//向下收缩
-(void)downContractionInputView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        
        self.topH = CGRectGetMinY(self.frame);
    }];
}

//向上弹出
-(void)popInputView
{
    [UIView animateWithDuration:0.4 animations:^{
        
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.keyboadH-self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.keyboadH-self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    }];
    
    self.topH = CGRectGetMinY(self.frame);
}
@end
