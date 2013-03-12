//
//  LoginView.h
//  Tango
//
//  Created by Devaraj NS on 12/03/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class CSLinearLayoutView;
@interface LoginView : UIView<UITextFieldDelegate>{
    
}

@property (nonatomic, strong) UITextField *useridTxt;
@property (nonatomic, strong) UITextField *pwdTxt;
@property (nonatomic, strong) UIButton *largeButton;
@property (nonatomic, strong) UIImageView *bgimg;
@property (nonatomic, strong) UIImageView *powerimg;
@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UIImageView *usrfield;
@property (nonatomic, strong) UIImageView *pwdfield;
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, retain) CSLinearLayoutView *linearLayoutView;
@end
