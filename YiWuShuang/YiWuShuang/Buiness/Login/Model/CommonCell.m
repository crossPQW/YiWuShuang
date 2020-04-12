//
//  CommonCell.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/12.
//  Copyright © 2020 huang. All rights reserved.
//

#import "CommonCell.h"
#import "UIView+DYKIOS.h"
#import "UIColor+Addition.h"
@interface CommonCell()
@property (nonatomic, strong) UIView *lineview;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIButton *rightBtn;
@end
@implementation CommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;;
}

- (void)setModel:(CommonCellModel *)model {
    _model = model;
    [self refreshSubViews];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layout];
}
- (void)refreshSubViews {
    [self.contentView removeAllSubviews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    switch (self.model.style) {
        case CellStyleSpace:
            self.contentView.backgroundColor = self.model.bgColor;
            break;
        case CellStyleLine:
        {
            self.lineview = [[UIView alloc] initWithFrame:CGRectMake(18, 0, self.width - 36, self.model.height)];
            self.lineview.backgroundColor = self.model.bgColor;
            [self.contentView addSubview:self.lineview];
        }
            break;
            
        case CellStyleOriz:{
            [self.contentView addSubview:self.titleLabel];
            self.titleLabel.text = self.model.title;
            self.subtitleLabel.textColor = [UIColor colorWithHexRGB:@"#333333"];
            [self.contentView addSubview:self.subtitleLabel];
            self.subtitleLabel.text = self.model.subtitle;
            [self.contentView addSubview:self.rightBtn];
        }
        break;
        case CellStyleInput:{
            [self.contentView addSubview:self.titleLabel];
            self.titleLabel.text = self.model.title;
            self.inputTextField.tag = self.model.tag;
            if (self.model.tag == 4) {
                self.inputTextField.userInteractionEnabled = NO;
            }else{
                self.inputTextField.userInteractionEnabled = YES;
            }
            [self.contentView addSubview:self.inputTextField];
            self.inputTextField.placeholder = self.model.subtitle;
        }
        break;
            
        case CellStyleSelectView:
            [self.contentView addSubview:self.titleLabel];
            self.titleLabel.text = self.model.title;
            self.subtitleLabel.textColor = [UIColor colorWithHexRGB:@"#333333"];
            [self.contentView addSubview:self.subtitleLabel];
            self.subtitleLabel.text = self.model.subtitle;
            [self.contentView addSubview:self.arrowView];
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
    self.inputTextField.frame = CGRectMake(self.width - rightWidth - x, 0, rightWidth, self.height);
    self.subtitleLabel.frame = CGRectMake(self.width - rightWidth - x, 29, rightWidth , 22);
    self.arrowView.frame = CGRectMake(self.width - 16 - 18, (self.height - 16) * 0.5, 6, 10);
    self.arrowView.centerY = self.subtitleLabel.centerY;
    self.rightBtn.frame = CGRectMake(self.width - 18 - 32, 30, 40, 22);
    switch (self.model.style) {
        case CellStyleSpace:
            
            break;
        case CellStyleLine:{
            
        }
            break;
        case CellStyleInput:{
            
        }
            break;
        case CellStyleSelectView:
            self.subtitleLabel.right = self.arrowView.left - 7;
            break;
        case CellStyleOriz:
            self.subtitleLabel.right = self.rightBtn.left - 12;
            break;
        default:
            break;
    }
}
- (void)copyID {
    UIPasteboard *ps = [UIPasteboard generalPasteboard];
    [ps setString:self.subtitleLabel.text];
}
#pragma mark - getter
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
        _subtitleLabel.textColor = [UIColor colorWithHexRGB:@"#BFC2CC"];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
        _subtitleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _subtitleLabel;;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_oriz_mode"]];
        _arrowView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowView;;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.borderStyle = UITextBorderStyleNone;
        _inputTextField.textAlignment = NSTextAlignmentRight;
        _inputTextField.returnKeyType = UIReturnKeyDone;
    }
    return _inputTextField;;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"复制" forState:UIControlStateNormal];
        _rightBtn.adjustsImageWhenHighlighted = NO;
        [_rightBtn setTitleColor:[UIColor colorWithHexRGB:@"#03C1AD"] forState:UIControlStateNormal];
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_rightBtn addTarget:self action:@selector(copyID) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;;
}
@end
