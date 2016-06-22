//
//  PlayerTextScrollerView.h
//  ICAHomePhoneInternational
//
//  Created by yan on 16/6/21.
//  Copyright © 2016年 ICA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayerTextScrollerView;
@protocol PlayerTextScrollerViewDelegate <NSObject>

- (void)playerTextScrollerView:(PlayerTextScrollerView *)playerTextView showInfo:(NSString *)info;

@end
@interface PlayerTextScrollerView : UIView

@property (assign, nonatomic, getter=isScrollDirectionPortrait) BOOL scrollDirectionPortrait;
@property(nonatomic,strong)NSArray *contentArr;
@property(nonatomic,weak)id<PlayerTextScrollerViewDelegate> delegate_;
@end
