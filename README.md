# LDPickerView
时间选择器View

#界面展示
![image](https://github.com/LD1314/LDPickerView/raw/master/images/1.png)

#方法介绍
/** 初始化方法  @param selectArray 标题的数组 */
 
\- (instancetype)initWithSelectArray:(NSArray<NSString \*>*)selectArray;

/** 显示选择器 */
 
\- (void)show;

/** 获取选择的标题 */
 
\- (void)didSelectTitleWithCompleteHandle:(SelectBlock)completeHandle;

#注意事项
使用该控件需要 pod 'Masonry' 框架