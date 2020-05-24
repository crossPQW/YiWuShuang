//
//  ClassSettingCell.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/23.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ClassSettingCell.h"
#import "YKAddition.h"
#import "ClassNoticeView.h"
#import "ClassJoinView.h"
#import "MBProgressHUD+helper.h"
@interface ClassSettingCell()<UITextFieldDelegate>
@property (nonatomic, strong) ClassNoticeView *noticeView;
@property (nonatomic, strong) ClassJoinView *joinView;
@property (nonatomic, strong) UIView *lineview;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UISwitch *switchBtn;

@end
@implementation ClassSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;;
}

- (void)setModel:(ClassSettingModel *)model {
    _model = model;
    [self refreshSubViews];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layout];
}

- (void)switchClick:(UISwitch *)swi {
    self.model.switchOn = swi.isOn;
    if (self.clickBlock) {
        self.clickBlock(self.model);
    }
}

- (void)clickSubtitle {
    if (self.clickBlock) {
        self.clickBlock(self.model);
    }
}

- (void)rightBtnClick {
    self.model.switchOn = !self.model.switchOn;
    if (self.clickBlock) {
        self.clickBlock(self.model);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    [self handleReturnWithTextField:textField];
    return YES;;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self handleReturnWithTextField:textField];
    return YES;;
}

- (void)handleReturnWithTextField:(UITextField *)textField {
    self.model.subtitle = textField.text;
    if (self.clickBlock) {
        self.clickBlock(self.model);
    }
}

- (void)refreshSubViews {
    [self.contentView removeAllSubviews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = self.model.title;
    self.subtitleLabel.text = self.model.subtitle;
    __weak typeof(self) weakSelf = self;
    switch (self.model.style) {
        case ClassSettingModelStyleNotice:
        {
            self.noticeView = [ClassNoticeView noticeView];
            self.noticeView.block = ^{
                if (weakSelf.clickBlock) {
                    weakSelf.clickBlock(weakSelf.model);
                }
            };
            [self.contentView addSubview:self.noticeView];
        }
            break;
        case ClassSettingModelStyleSpace:
            self.contentView.backgroundColor = [UIColor colorWithHexRGB:@"#F5F7FA"];
            break;
        case ClassSettingModelStyleLine:
            self.lineview = [[UIView alloc] initWithFrame:CGRectMake(18, 0, self.width - 36, self.model.height)];
            self.lineview.backgroundColor = [UIColor colorWithHexRGB:@"#EDEFF2"];
            [self.contentView addSubview:self.lineview];
        break;
        case ClassSettingModelTitle:
        {
            [self.contentView addSubview:self.titleLabel];
            [self.contentView addSubview:self.inputTextField];
            self.inputTextField.delegate = self;
            self.inputTextField.placeholder = @"请输入课程名称";
        }
        break;
        case ClassSettingModelSelect:
        {
            [self.contentView addSubview:self.titleLabel];
            [self.contentView addSubview:self.subtitleLabel];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSubtitle)];
            self.subtitleLabel.userInteractionEnabled = YES;
            [self.subtitleLabel addGestureRecognizer:tap];
            [self.contentView addSubview:self.arrowView];
        }
        break;
        case ClassSettingModelSwitch:
        {
            [self.contentView addSubview:self.titleLabel];
            [self.contentView addSubview:self.switchBtn];
            [self.switchBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
            [self.switchBtn setOn:self.model.switchOn];
        }
        break;
        case ClassSettingModelButton:
        {
            [self.contentView addSubview:self.titleLabel];
            [self.contentView addSubview:self.rightBtn];
            [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.rightBtn setImage:[UIImage imageNamed:self.model.btnImg] forState:UIControlStateNormal];
        }
        break;
        case ClassSettingModelCopy:
        {
            [self.contentView addSubview:self.titleLabel];
            [self.contentView addSubview:self.subtitleLabel];
            [self.contentView addSubview:self.rightBtn];
            [self.rightBtn setTitle:@"复制" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:[UIColor colorWithHexRGB:@"#15C3D6"] forState:UIControlStateNormal];
            [self.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [self.rightBtn addTarget:self action:@selector(copy:) forControlEvents:UIControlEventTouchUpInside];
        }
        break;
        case ClassSettingModelJoin:
            self.joinView = [ClassJoinView joinView];
            [self.contentView addSubview:self.joinView];
        break;
        default:
            break;
    }
}

- (void)layout {
    CGFloat x = 18;
    self.lineview.frame = CGRectMake(x, 0, self.width - x * 2, self.height);
    self.titleLabel.frame = CGRectMake(x, 29, 120, 22);
    CGFloat rightWidth = 150;
    self.inputTextField.frame = CGRectMake(x, 36, self.width - x*2, 63);
    self.subtitleLabel.frame = CGRectMake(self.width - rightWidth - x, 29, rightWidth , 22);
    self.arrowView.frame = CGRectMake(self.width - 16 - 18, (self.height - 16) * 0.5, 6, 10);
    self.arrowView.centerY = self.subtitleLabel.centerY;
    self.rightBtn.frame = CGRectMake(self.width - 18 - 26, 0, 26, 26);
    self.rightBtn.centerY = self.titleLabel.centerY;
    self.switchBtn.centerY = self.titleLabel.centerY;
    self.switchBtn.right = self.width - 18;
    
    switch (self.model.style) {
        case ClassSettingModelTitle:
            self.titleLabel.top = 14;
            break;
        case ClassSettingModelSelect:
            self.subtitleLabel.frame = CGRectMake(self.arrowView.left - rightWidth - 5, 0, rightWidth, 22);
            self.subtitleLabel.centerY = self.titleLabel.centerY;
            break;
        case ClassSettingModelCopy:
            self.rightBtn.frame = CGRectMake(self.width - 18 - 44, 0, 44, 26);
            self.rightBtn.centerY = self.titleLabel.centerY;
            self.subtitleLabel.frame = CGRectMake(self.titleLabel.right + 5, 0, self.rightBtn.left - self.titleLabel.right - 5 - 5, 22);
            self.subtitleLabel.centerY = self.titleLabel.centerY;
            break;
        default:
            break;
    }
}

- (void)copy:(id)sender {
    UIPasteboard *ps = [UIPasteboard generalPasteboard];
    [ps setString:self.subtitleLabel.text];
    [MBProgressHUD showText:@"已将课程ID复制到剪切板" inView:[UIApplication sharedApplication].delegate.window];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexRGB:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = [UIColor colorWithHexRGB:@"#333333"];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
        _subtitleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _subtitleLabel;;
}


- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _inputTextField;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_oriz_mode"]];
        _arrowView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowView;;
}

- (UISwitch *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] init];
        _switchBtn.tintColor = [UIColor colorWithHexRGB:@"#28EFA2"];
    }
    return _switchBtn;;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.adjustsImageWhenHighlighted = NO;
    }
    return _rightBtn;
}
@end
