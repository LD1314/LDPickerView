//
//  LDPickerView.m
//  demo-UIPickerView选择控件
//
//  Created by iOS Tedu on 16/8/10.
//  Copyright © 2016年 huaxu. All rights reserved.
//

#import "LDPickerView.h"
#import <Masonry.h>

#define MyColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface LDPickerView()<UIPickerViewDelegate> {
    SelectBlock _selectBlock;
}

@property (nonatomic, weak) UIView *toolBarView;
@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIButton *doneButton;
@property (nonatomic, assign) NSInteger rowCount;

@end

@implementation LDPickerView

#pragma mark - 初始化相关方法
/**
 *  初始化方法
 *
 *  @param selectArray 标题的数组
 */
- (instancetype)initWithSelectArray:(NSArray<NSString *> *)selectArray {
    self = [super init];
    if (self) {
        self.selectTitleArray = selectArray;
        self.rowCount = 0;
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        
        //创建选择器视图
        [self setuPickerView];
        //创建工具条
        [self setuToolBarView];
    }
    
    return self;
}

/**
 *  创建选择器视图
 */
- (void)setuPickerView {
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
}

/**
 *  创建工具条
 */
- (void)setuToolBarView {
    UIView *toolBarView = [UIView new];
    toolBarView.backgroundColor = MyColor(238, 238, 238);
    [self addSubview:toolBarView];
    self.toolBarView = toolBarView;
    [toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(self.pickerView.mas_top).mas_equalTo(0);
    }];
    
    //添加取消按钮
    UIButton *cancelBtn = [self setupButtonWithTitle:@"取消"];
    CGSize size = cancelBtn.frame.size;
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加完成按钮
    UIButton *doneBtn = [self setupButtonWithTitle:@"完成"];
    size = doneBtn.frame.size;
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
    }];
    [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  创建按钮
 *
 *  @param title 标题
 */
- (UIButton *)setupButtonWithTitle:(NSString *)title {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn sizeToFit];
    
    [self.toolBarView addSubview:btn];
    return btn;
}

/**
 *  取消被点击
 */
- (void)cancelClick {
    [self viewSholdHide];
}

/**
 *  完成被点击
 */
- (void)doneClick {
    NSString *title = self.selectTitleArray[self.rowCount];
    !_selectBlock?:_selectBlock(title);
    [self viewSholdHide];
}

#pragma mark - UIPickerViewDelegate
//返回有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

/**
 *  返回指定列的行数
 *  @param component  第几列
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.selectTitleArray.count;
}

//返回显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.selectTitleArray[row];
}

/**
 *  选择结束后调用
 *  @param row        被选中的行
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.rowCount = row;
}

#pragma mark - 其他方法
/**
 *  显示选择器
 */
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.pickerView.layer.transform = CATransform3DMakeTranslation(0, 244, 0);
    self.toolBarView.layer.transform = CATransform3DMakeTranslation(0, 244, 0);
    [UIView animateWithDuration:0.4 animations:^{
        self.pickerView.layer.transform = CATransform3DIdentity;
        self.toolBarView.layer.transform = CATransform3DIdentity;
    }];
}

/**
 *  移除选择器
 */
- (void)viewSholdHide {
    [UIView animateWithDuration:0.4 animations:^{
        self.pickerView.layer.transform = CATransform3DMakeTranslation(0, 240, 0);
        self.toolBarView.layer.transform = CATransform3DMakeTranslation(0, 240, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/**
 *  获取选择的标题
 */
- (void)didSelectTitleWithCompleteHandle:(SelectBlock)completeHandle {
    _selectBlock = [completeHandle copy];
}

/**
 *  触摸屏幕其它地方，隐藏选择器
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if([touch.view isEqual:self])
    {
        [self viewSholdHide];
    }
}

@end
