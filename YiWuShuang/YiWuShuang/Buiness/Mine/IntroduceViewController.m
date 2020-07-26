//
//  IntroduceViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/7/26.
//  Copyright © 2020 huang. All rights reserved.
//

#import "IntroduceViewController.h"
#import "YKAddition.h"
#import "GradientButton.h"
#import "ClassApiManager.h"

@interface IntroduceViewController ()

@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品介绍";
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = [UIColor colorWithHexRGB:@"#333333"];
    label.text = @"艺无双全景声音视频互动教育平台";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(18);
        make.top.equalTo(self.view).offset(100);
    }];
    
    UITextView *tv = [[UITextView alloc] init];
    tv.text = @"全球首创全景声音视频互动线上教育平台，声音质量的采集传输呈现均可达到48khz，充分满足音乐，舞蹈、戏剧等对音质有较高要求的线上教育需求，实现身临其境的效果，无限接近面对面教学。";
    tv.font = [UIFont systemFontOfSize:15];
    tv.textColor = [UIColor colorWithHexRGB:@"#333333"];
    tv.userInteractionEnabled = NO;
    [self.view addSubview:tv];
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(18);
        make.right.equalTo(self.view).offset(-18);
        make.top.equalTo(label.mas_bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [[ClassApiManager manager] getTextWithType:@"3" success:^(BaseModel * _Nonnull baseModel) {
        if ([baseModel.data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = baseModel.data;
            NSString *title = [data stringForKey:@"title"];
            label.text = title;
            NSString *content = [data stringForKey:@"content"];
            tv.text = content;
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
