//
//  Model.m
//  MultiDelete
//
//  Created by 夏桂峰 on 15/11/26.
//  Copyright © 2015年 夏桂峰. All rights reserved.
//

#import "Model.h"

@implementation Model

+(instancetype)modelWithDesc:(NSString *)desc
{
    Model *m=[Model new];
    m.desc=desc;
    return m;
}


@end
