//
//  ClassApiManager.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/24.
//  Copyright © 2020 huang. All rights reserved.
//

#import "ClassApiManager.h"
#import "NSDictionary+YYAdd.h"
#import "NSObject+YYModel.h"
#import "UserSession.h"
#import "YKAddition.h"
#import <Contacts/Contacts.h>

static NSString *getCourseID = @"/api/course/getCourseId";
static NSString *createClassUrl = @"/api/course/create";
static NSString *joinClassUrl = @"/api/course/addCourse";
static NSString *uploadUrl = @"/api/common/upload";
static NSString *getFriendsUrl = @"/api/contacts/index";
static NSString *getContactListUrl = @"/api/contacts/list";
static NSString *contactIsUpload = @"/api/contacts/isUp";
static NSString *uploadContacts = @"/api/contacts/upload";
static NSString *addFriend = @"/api/contacts/friend";
static NSString *friendDetail = @"/api/contacts/detail";
static NSString *deleteFriend = @"/api/contacts/delete";
static NSString *setNote = @"/api/contacts/setNote";
static NSString *searchContact = @"/api/contacts/search";
static NSString *searchFriend = @"/api/contacts/select";
static NSString *feedbackUrl = @"/api/ucenter/note";
static NSString *textDetailUrl = @"/api/common/detail";

static NSString *debugHost = @"https://test.yiwushuang.cn";
static NSString *releaseHost = @"https://www.yiwushuang.cn";
@interface ClassApiManager()

@end
@implementation ClassApiManager
+ (instancetype)manager {
    static ClassApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ClassApiManager alloc] init];
    });
    return manager;
}
- (NSString *)getHost {
#ifdef DEBUG
    return debugHost;
#endif
    return releaseHost;
}

- (void)getClassIDSuccess:(void (^)(BaseModel *baseModel))success
                  failure:(void (^)(NSError *error))failure {
    [self requestWithApi:getCourseID params:nil success:success failure:failure];
}

- (void)creatClassWithID:(NSString *)classID
      name:(NSString *)className
    number:(NSString *)stuNumber
     ratio:(NSString *)ratio
      type:(int) type
  playType:(int) playType
  start_at:(NSString *)time
  isCamera:(BOOL)isCamera
     isMic:(BOOL)isMic
isSmartMic:(BOOL)isSmartMic
   success:(void (^)(BaseModel *baseModel))success
   failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:classID forKey:@"unique_id"];
    [params yk_setValue:className forKey:@"name"];
    [params yk_setValue:stuNumber forKey:@"user_ids"];
    [params yk_setValue:ratio forKey:@"ratio"];
    [params yk_setValue:@(type) forKey:@"type"];
    [params yk_setValue:@(playType) forKey:@"play_type"];
    if (type == 2) {
        [params yk_setValue:time forKey:@"start_at"];
    }
    [params yk_setValue:@(isCamera) forKey:@"is_camera"];
    [params yk_setValue:@(isMic) forKey:@"is_make"];
    [params yk_setValue:@(isSmartMic) forKey:@"is_zhimai"];
    [self requestWithApi:createClassUrl params:params success:success failure:failure];
}

- (void)joinClassWithID:(NSString *)classID
                success:(void (^)(BaseModel *baseModel))success
                failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:classID forKey:@"unique_id"];
    [self requestWithApi:joinClassUrl params:params success:success failure:failure];
}
#pragma mark - basic
- (void)requestWithApi:(NSString *)api params:(NSDictionary *)params success:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    NSString *host = releaseHost;
#ifdef DEBUG
    host = debugHost;
#endif
    NSString *url = [host stringByAppendingString:api];
    NSMutableDictionary *paramter = @{}.mutableCopy;
    [paramter yk_setValue:[UserSession session].currentUser.token forKey:@"token"];
    [paramter addEntriesFromDictionary:params];
    [httpManager POST:url parameters:paramter headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseModel *model = [[BaseModel alloc] initWithDictionary:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)uploadWithParams:(NSDictionary *)params image:(UIImage *)img name:(NSString *)name fileName:(NSString *)fileName success:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *host = releaseHost;
    #ifdef DEBUG
        host = debugHost;
    #endif
    NSString *url = [host stringByAppendingString:uploadUrl];
    NSMutableDictionary *paramter = @{}.mutableCopy;
    [paramter yk_setValue:[UserSession session].currentUser.token forKey:@"token"];
    [paramter addEntriesFromDictionary:params];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    [httpManager POST:url parameters:paramter headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
        [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@.jpeg",fileName] mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseModel *model = [[BaseModel alloc] initWithDictionary:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getFriendsSuccess:(void (^)(BaseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [self requestWithApi:getFriendsUrl params:nil success:success failure:failure];
}

- (void)checkContactStatusSuccess:(void (^)(BaseModel *baseModel))success
                          failure:(void (^)(NSError *error))failure {
    [self requestWithApi:contactIsUpload params:nil success:success failure:failure];
}
- (void)getContactListSuccess:(void (^)(BaseModel *baseModel))success
                      failure:(void (^)(NSError *error))failure {
    [self requestWithApi:getContactListUrl params:nil success:success failure:failure];
}

- (void)addFriendWithContactID:(NSString *)ID success:(void (^)(BaseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:ID forKey:@"contacts_id"];
    [self requestWithApi:addFriend params:params success:success failure:failure];
}

- (void)getFriendDetailWithID:(NSString *)ID
                      success:(void (^)(BaseModel *baseModel))success
                      failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:ID forKey:@"to_id"];
    [self requestWithApi:friendDetail params:params success:success failure:failure];
}

- (void)deleteFriendWithID:(NSString *)ID
                   success:(void (^)(BaseModel *baseModel))success
                   failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:ID forKey:@"to_id"];
    [self requestWithApi:deleteFriend params:params success:success failure:failure];
}

- (void)setNoteWithFriendID:(NSString *)ID
                       note:(NSString *)note
                    success:(void (^)(BaseModel *baseModel))success
                    failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:ID forKey:@"to_id"];
    [params yk_setValue:note forKey:@"note"];
    [self requestWithApi:setNote params:params success:success failure:failure];
}

- (void) searchContactWithMobile:(NSString *)mobile
                         success:(void (^)(BaseModel *baseModel))success
                         failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:mobile forKey:@"keyword"];
    [self requestWithApi:searchContact params:params success:success failure:failure];
}

- (void) searchFriendsWithkeyword:(NSString *)keyword
                          success:(void (^)(BaseModel *baseModel))success
                          failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:keyword forKey:@"keyword"];
    [self requestWithApi:searchFriend params:params success:success failure:failure];
}

- (void) feedbackWithText:(NSString *)text
                  success:(void (^)(BaseModel *baseModel))success
                  failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:text forKey:@"note"];
    [self requestWithApi:feedbackUrl params:params success:success failure:failure];
}

- (void)getTextWithType:(NSString *)type
                success:(void (^)(BaseModel *baseModel))success
                failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:type forKey:@"type"];
    [self requestWithApi:textDetailUrl params:params success:success failure:failure];
}
//上传通讯录
- (void)uploadContact {
    [self checkContactStatusSuccess:^(BaseModel * _Nonnull baseModel) {
        if ([baseModel.data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = baseModel.data;
            NSInteger flag = [data integerForKey:@"isUp"];
            if (flag == 0) {
                [self handleUpload];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)handleUpload {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                
            }else {
                [self openContact];
            }
        }];
    }else if (status == CNAuthorizationStatusRestricted) {
        [self showContactAlert];
    }else if (status == CNAuthorizationStatusDenied) {
        [self showContactAlert];
    }else if (status == CNAuthorizationStatusAuthorized){
        [self openContact];
    }
}

- (void)showContactAlert {
    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:@"请授权通讯录权限"
        message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许花解解访问你的通讯录"
        preferredStyle: UIAlertControllerStyleAlert];

    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)openContact {
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    NSMutableArray *contacts = @[].mutableCopy;
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        //拼接姓名
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        CNLabeledValue  * labelValue = contact.phoneNumbers[0];
        
        NSString * phoneNumber = [labelValue.value stringValue];
        
        NSMutableDictionary *dict = @{}.mutableCopy;
        [dict yk_setValue:nameStr forKey:@"name"];
        [dict yk_setValue:phoneNumber forKey:@"mobile"];
        [contacts addObject:dict];
    }];
    
    NSMutableArray *sortArray = @[].mutableCopy;
    int eachCount = 500;
    int count = (int)contacts.count / eachCount + 1;
    if (count > 20) {
        count = 20;
    }
    for (int i = 0; i<count; i++) {
        int length = eachCount;
        if (i == (count - 1)) {//最后一组
            length = (int)contacts.count - (length * (count - 1));
        }
        if (length > 500) {
            length = 500;
        }
        NSArray *tempArray = [contacts subarrayWithRange:NSMakeRange(i * eachCount, length)];
        [sortArray addObject:tempArray];
    }
    
    for (NSArray *contacts in sortArray) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contacts options:NSJSONWritingPrettyPrinted error:nil];
        NSString *contactStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self uploadContactWithMobiles:contactStr success:^(BaseModel *baseModel) {
            if (baseModel.code == 1) {
                //上传成功
            }
        } failure:^(NSError *error) {
            
        }];
    }
}


- (void)uploadContactWithMobiles:(NSString *)mobiles success:(void (^)(BaseModel *baseModel))success failure:(void (^)(NSError *error))failure  {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params yk_setValue:mobiles forKey:@"mobiles"];
    [self requestWithApi:uploadContacts params:params success:success failure:failure];
}
@end

