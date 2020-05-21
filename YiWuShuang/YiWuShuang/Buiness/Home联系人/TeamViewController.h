//
//  PartViewcontroller.h
//  YiWuShuang
//
//  Created by 黄 on 2020/4/25.
//  Copyright © 2020 huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeamViewController : UIViewController
@property (nonatomic, strong) TeamModel *model;
@property (nonatomic, strong) NSString *currentTeamName;
@property (nonatomic, strong) NSString *currentTeamID;
@end
NS_ASSUME_NONNULL_END
