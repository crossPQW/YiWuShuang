//
//  UIViewController+Addition.m
//  Youku
//
//  Created by Peter on 9/21/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import "UIViewController+Addition.h"
#import <objc/runtime.h>
#import <QuartzCore/CAAnimation.h>

static const void *kPropIsAnimating = "IsAnimating";
static const void *kPropPushedController = "PushedController";

@interface UIViewController (AnimatePrivate)

@property (atomic, assign) BOOL isAnimating; //是否正在执行push或pop动画
@property (atomic, assign) UIViewController *pushedController; //正在push的控制器

@end

@implementation UIViewController (AnimatePrivate)

- (BOOL)isAnimating
{
    return [objc_getAssociatedObject(self, kPropIsAnimating) boolValue];
}

- (void)setIsAnimating:(BOOL)isAnimating
{
    objc_setAssociatedObject(self, kPropIsAnimating, @(isAnimating), OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)pushedController
{
    return objc_getAssociatedObject(self, kPropPushedController);
}

- (void)setPushedController:(UIViewController *)pushedController
{
    objc_setAssociatedObject(self, kPropPushedController, pushedController, OBJC_ASSOCIATION_ASSIGN);
}

@end



@implementation UIViewController (Addition)

- (void)pushController:(UIViewController *)controller animated:(BOOL)animated
{
    if (animated) {
        if (self.isAnimating) { //动画过程中，忽略本次操作
            return;
        }
        self.isAnimating = YES;
        
        self.pushedController = controller; //记录子控制器
        
        //动画过程中禁用触控事件
        self.view.userInteractionEnabled = NO;
        controller.view.userInteractionEnabled = NO;
    }
    
    //添加子控制器
    [self.view addSubview:controller.view];
    [self addChildViewController:controller];
    
    if (animated) {
        CGRect targetFrame = controller.view.frame;
        CGRect sourceFrame = targetFrame;
        sourceFrame.origin.y = self.view.bounds.size.height;
        controller.view.frame = sourceFrame;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            controller.view.frame = targetFrame;
        } completion:^(BOOL finished) {
            //动画结束恢复触控事件
            self.view.userInteractionEnabled = YES;
            self.pushedController.view.userInteractionEnabled = YES;
            
            self.isAnimating = NO;
            self.pushedController = nil;
        }];
    }
    
    //切换动画
//    if (animated) {
//        CATransition *animation = [CATransition animation];
//        [animation setDelegate:self];
//        [animation setType:kCATransitionMoveIn];
//        [animation setSubtype:kCATransitionFromTop];
//        [animation setDuration:0.3];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [[controller.view layer] addAnimation:animation forKey:@"TransitionViewAnimation"];
//    }
}

- (void)popController:(BOOL)animated
{
    if (animated) {
        if (self.isAnimating) { //动画过程中，忽略本次操作
            return;
        }
        self.isAnimating = YES;
        
        //动画过程中禁用触控事件
        self.view.userInteractionEnabled = NO;
        self.parentViewController.view.userInteractionEnabled = NO;
    }
    
    //父控制器
    UIViewController *parentViewController = self.parentViewController;
    parentViewController.pushedController = nil; //子控制器销毁前清除引用，防止父控制器结束动画时的野指针调用
    
    //移除子控制器
    
    //切换动画
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = self.parentViewController.view.bounds.size.height;
            self.view.frame = frame;
        } completion:^(BOOL finished) {
            //动画结束恢复触控事件
            self.view.userInteractionEnabled = YES;
            self.parentViewController.view.userInteractionEnabled = YES;
            
            [self.view removeFromSuperview];
            [self removeFromParentViewController]; //iOS8从父控制器中移除要在移除视图之后
            
            self.isAnimating = NO;
        }];
        
//        CATransition *animation = [CATransition animation];
//        [animation setDelegate:parentViewController]; //self可能被提前释放
//        [animation setType:kCATransitionReveal];
//        [animation setSubtype:kCATransitionFromBottom];
//        [animation setDuration:0.3];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [[parentViewController.view layer] addAnimation:animation forKey:@"TransitionViewAnimation"];
    }else{
        [self.view removeFromSuperview];
        [self removeFromParentViewController]; //iOS8从父控制器中移除要在移除视图之后
    }
}



#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CATransition *)anim finished:(BOOL)flag
{
    //动画完成后启用触控事件
    self.view.userInteractionEnabled = YES;
    self.pushedController.view.userInteractionEnabled = YES;
    
    self.isAnimating = NO;
    self.pushedController = nil;
}

@end
