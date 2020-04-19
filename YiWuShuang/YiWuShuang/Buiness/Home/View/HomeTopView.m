//
//  HomeTopView.m
//  YiWuShuang
//
//  Created by 黄 on 2020/4/19.
//  Copyright © 2020 huang. All rights reserved.
//

#import "HomeTopView.h"
#import "UIColor+Addition.h"

@interface HomeTopView()
@property (strong, nonatomic)  UIImageView *avatarImage;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UIButton *managericon;
@property (strong, nonatomic)  UILabel *flowLabel;

@end
@implementation HomeTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
    }
    return self;
}

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc] init];
    }
    return _avatarImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UIButton *)managericon {
    if (!_managericon) {
        _managericon = [[UIButton alloc] init];
        [_managericon setTitle:@"管理员" forState:UIControlStateNormal];
        [_managericon setTitleColor:[UIColor colorNamed:@"#03C1AD"] forState:UIControlStateNormal];
        _managericon.layer.borderColor = [UIColor colorNamed:@"#03C1AD"].CGColor;
        _managericon.layer.borderWidth = 1;
        _managericon.layer.cornerRadius = 10;
    }
    return _managericon;
}

- (UILabel *)flowLabel {
    if (!_flowLabel) {
        _flowLabel = [[UILabel alloc] init];
    }
    return _flowLabel;
}
@end
