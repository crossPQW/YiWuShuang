//
//  UIAlertView+Addition.m
//  Youku
//
//  Created by quan dong on 7/7/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import "UIAlertView+Addition.h"

#import <objc/runtime.h>

static char DISMISS_IDENTIFER;
static char CANCEL_IDENTIFER;
@interface AdditionAlertView:UIAlertView
@end
@implementation AdditionAlertView

- (void)alertView:(UIAlertView*) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    
    if(buttonIndex == [alertView cancelButtonIndex])
    {
        if (alertView.cancelBlock) {
            alertView.cancelBlock();
        }
    }
    else
    {
        if (alertView.dismissBlock) {
            alertView.dismissBlock(buttonIndex - 1); // cancel button is button 0
        }
    }
}
@end

@implementation UIAlertView (Block)

@dynamic cancelBlock;
@dynamic dismissBlock;

- (void)setDismissBlock:(DismissBlock)dismissBlock
{
    objc_setAssociatedObject(self, &DISMISS_IDENTIFER, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DismissBlock)dismissBlock
{
    return objc_getAssociatedObject(self, &DISMISS_IDENTIFER);
}

- (void)setCancelBlock:(CancelBlock)cancelBlock
{
    objc_setAssociatedObject(self, &CANCEL_IDENTIFER, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CancelBlock)cancelBlock
{
    return objc_getAssociatedObject(self, &CANCEL_IDENTIFER);
}

+ (UIAlertView*) alertViewWithTitle:(NSString*) title                    
                            message:(NSString*) message 
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(DismissBlock) dismissed                   
                           onCancel:(CancelBlock) cancelled {
    
    AdditionAlertView *alert = [[AdditionAlertView alloc] initWithTitle:title?:@"提示"
                                                    message:message
                                                   delegate:[self class]
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    alert.delegate = alert;
    [alert setDismissBlock:dismissed];
    [alert setCancelBlock:cancelled];
    
    for(NSString *buttonTitle in otherButtons)
        [alert addButtonWithTitle:buttonTitle];
    
    return alert;
}



@end
