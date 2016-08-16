//
//  LDPickerView.h
//  demo-UIPickerView选择控件
//
//  Created by iOS Tedu on 16/8/10.
//  Copyright © 2016年 huaxu. All rights reserved.
//  单项选择器,需要引入Masonry框架

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSString *title);

@interface LDPickerView : UIView

/** 标题的数组 */
@property (nonatomic, strong) NSArray<NSString *> *selectTitleArray;

/**
 *  初始化方法
 *
 *  @param selectArray 标题的数组
 */
- (instancetype)initWithSelectArray:(NSArray<NSString *> *)selectArray;

/**
 *  显示选择器
 */
- (void)show;

/**
 *  获取选择的标题
 */
- (void)didSelectTitleWithCompleteHandle:(SelectBlock)completeHandle;

@end
