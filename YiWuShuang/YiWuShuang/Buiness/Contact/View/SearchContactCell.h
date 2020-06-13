//
//  SearchContactCell.h
//  YiWuShuang
//
//  Created by 黄 on 2020/6/13.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchContactCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy) dispatch_block_t block;
@end

NS_ASSUME_NONNULL_END
