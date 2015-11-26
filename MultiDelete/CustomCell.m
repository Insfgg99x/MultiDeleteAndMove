//
//  CustomCell.m
//  MultiDelete
//
//  Created by 夏桂峰 on 15/11/26.
//  Copyright © 2015年 夏桂峰. All rights reserved.
//

#import "CustomCell.h"
#define kWidth ([UIScreen mainScreen].bounds.size.width)

@implementation CustomCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor=[UIColor blackColor];
        [self createUI];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)createUI
{
    for(UIView *sub in self.contentView.subviews)
        [sub removeFromSuperview];
    
    //选择按钮
    self.selectBtn=[[UIButton alloc]initWithFrame:CGRectMake(-20, 10, 20, 20)];
    [self.selectBtn setImage:[UIImage imageNamed:@"un_select"] forState:UIControlStateNormal];
    [self .selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectBtn];
    //默认隐藏
    self.selectBtn.hidden=YES;
    
    // 标题Lb
    self.titleLb=[[UILabel alloc]initWithFrame:CGRectMake(20, 0,kWidth-40, 40)];
    self.titleLb.textColor=[UIColor whiteColor];
    [self.contentView addSubview:self.titleLb];
}

@end
