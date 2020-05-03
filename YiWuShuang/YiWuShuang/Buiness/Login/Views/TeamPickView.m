//
//  TeamPickView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/22.
//  Copyright © 2020 huang. All rights reserved.
//

#import "TeamPickView.h"
#import "YKAddition.h"
#import "PersonModel.h"
@interface TeamPickView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) NSArray *list;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) NSInteger index;
@end
@implementation TeamPickView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.index = 0;
        self.list = @[];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.cancelBtn = [[UIButton alloc] init];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelBtn];
        
        self.doneBtn = [[UIButton alloc] init];
        [self.doneBtn setTitle:@"确认" forState:UIControlStateNormal];
        [self.doneBtn setTitleColor:[UIColor colorWithHexRGB:@"#03C1AD"] forState:UIControlStateNormal];
        [self.doneBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.doneBtn addTarget:self action:@selector(didClickDonelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneBtn];
        
        self.pickView = [[UIPickerView alloc] init];
        self.pickView.delegate = self;
        [self addSubview:self.pickView];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(52, 47));
        }];
        
        [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(52, 47));
        }];
        
        [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(frame.size.height - 47);
            make.left.bottom.right.mas_equalTo(0);
        }];
    }
    return self;;
}

- (void)setData:(NSArray *)list {
    self.list = list;
    [self.pickView reloadAllComponents];
}

- (void)didClickCancelBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didDismiss)]) {
        [self.delegate didDismiss];
    }
}

- (void)didClickDonelBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedTeamWithIndex:)]) {
        [self.delegate didSelectedTeamWithIndex:self.index];
    }
}

#pragma mark - pickerview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.list.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id data = self.list[row];
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)data;
        NSString *name = [dict stringForKey:@"name"];
        return name;
    }else if ([data isKindOfClass:[PersonModel class]]){
        PersonModel *model = (PersonModel *)data;
        return model.nickname;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.index = row;
}

@end
