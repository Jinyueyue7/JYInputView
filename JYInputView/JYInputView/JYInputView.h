//
//  JYInputView.h
//  JYInputView
//
//  Created by 伟运体育 on 2017/9/27.
//  Copyright © 2017年 伟运体育. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYInputView : UIView
@property (nonatomic,strong)UITextView *textView;

//添加图片和表情的回调

@property (nonatomic,copy)void (^addImageAndEmojiBlock)(NSInteger tag,NSString *commentStr);

//向下收缩
-(void)downContractionInputView;

-(void)setPhotos:(NSArray *)array;

-(void)clearData;
@end
