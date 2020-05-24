//
//  RealAuthViewController.m
//  YiWuShuang
//
//  Created by 黄 on 2020/5/24.
//  Copyright © 2020 huang. All rights reserved.
//

#import "RealAuthViewController.h"
#import "ClassApiManager.h"
#import "YKAddition.h"
#import "ApiManager.h"
@interface RealAuthViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *IDTextField;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) NSString *imageUrl;
@end

@implementation RealAuthViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *layer = [self gLayer];
    layer.frame = self.commitBtn.bounds;
    [self.commitBtn.layer insertSublayer:layer atIndex:0];
    self.commitBtn.layer.cornerRadius = 21;
    self.commitBtn.layer.masksToBounds = YES;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)commitAuth:(id)sender {
    NSString *name = self.nameTextField.text;
    NSString *ID = self.IDTextField.text;
    [[ApiManager manager] realAuthWithRealName:name ID:ID img:self.imageUrl success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            
        }else{
            [MBProgressHUD showText:@"认证失败" inView:self.view];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showText:@"网络异常，请稍后再试" inView:self.view];
    }];
}
- (IBAction)uploadImg:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.imageBtn setImage:image forState:UIControlStateNormal];
    
    [self uploadImage:image];
}

- (void)uploadImage:(UIImage *)img {
    [[ClassApiManager manager] uploadWithParams:nil image:img name:@"file" fileName:@"file" success:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.code == 1) {
            NSDictionary *data = baseModel.data;
            NSString *url = [data stringForKey:@"url"];
            self.imageUrl = url;
            
            [MBProgressHUD showText:@"上传成功" inView:self.view];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (CAGradientLayer *)gLayer {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:40/255.0 green:239/255.0 blue:162/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:20/255.0 green:193/255.0 blue:215/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    return gl;
}

@end
