//
//  LoginView.m
//  Tango
//
//  Created by Devaraj NS on 12/03/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import "LoginView.h"
#import "CSLinearLayoutView.h"
#define STAccountNumberKey		@"accountNumber"
#define STPinNumberKey			@"AccessTokenKey"
@implementation LoginView

@synthesize linearLayoutView;
@synthesize useridTxt;
@synthesize pwdTxt;
@synthesize appDelegate;
@synthesize largeButton,powerimg;
@synthesize bgimg,logo,usrfield,pwdfield;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        // Initialization code
        self.frame = CGRectMake(0,0,400,200);
        self.backgroundColor = [UIColor clearColor];
        [self viewLoad];
    }
    return self;
}

- (void)viewLoad
{
    self.linearLayoutView = [[CSLinearLayoutView alloc] initWithFrame:CGRectMake(0, 0, 400,200)];
    linearLayoutView.orientation = CSLinearLayoutViewOrientationVertical;
    linearLayoutView.scrollEnabled = YES;
    linearLayoutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    linearLayoutView.backgroundColor = [UIColor clearColor];
    [self addSubview:linearLayoutView];
    
    CGRect frame =CGRectMake(0, 0, 250, 35);
    useridTxt = [[UITextField alloc] initWithFrame:frame];
    [useridTxt setPlaceholder:@"User Id"];
    [useridTxt setReturnKeyType:UIReturnKeyDone];
    useridTxt.keyboardType = UIKeyboardTypeNumberPad;
    useridTxt.borderStyle =UITextBorderStyleRoundedRect;
    useridTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    useridTxt.delegate = self;
    
    CGRect pframe =CGRectMake(100, 0, 250, 35);
    pwdTxt = [[UITextField alloc] initWithFrame:pframe];
    pwdTxt.secureTextEntry = YES;
    [pwdTxt setPlaceholder:@"Password"];
    [pwdTxt setReturnKeyType:UIReturnKeyDone];
    pwdTxt.borderStyle =UITextBorderStyleRoundedRect;
    pwdTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTxt.delegate = self;
    
    largeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect cframe =CGRectMake(200, 0, 270, 73);
    [largeButton setFrame:cframe];
    [largeButton setImage:[UIImage imageNamed:@"LoginButton_Nor"] forState:UIControlStateNormal];
    [largeButton setImage:[UIImage imageNamed:@"LoginButton_Hov"] forState:UIControlStateSelected];
    [largeButton addTarget:self action:@selector(ButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    
    CSLinearLayoutItem *item1 = [self newItem:useridTxt];
    [linearLayoutView addItem:item1];
    
    CSLinearLayoutItem *item2 = [self newItem:pwdTxt];
    [linearLayoutView addItem:item2];
    
    CSLinearLayoutItem *item3 = [self newItem:largeButton];
    [linearLayoutView addItem:item3];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    usrfield = [[UIImageView alloc] init];
    usrfield.image =  [UIImage imageNamed:@"login_Pg_usenameField01"];
    usrfield.frame = CGRectMake(0, 0, 35, 35);
    [self addSubview:usrfield];
    
    useridTxt.leftView = usrfield;
    useridTxt.leftViewMode = UITextFieldViewModeAlways;
    
    pwdfield = [[UIImageView alloc] init];
    pwdfield.image =  [UIImage imageNamed:@"login_Pg_PasswordField01"];
    pwdfield.frame = CGRectMake(0, 0, 35, 35);
    [self addSubview:pwdfield];
    
    pwdTxt.leftView = pwdfield;
    pwdTxt.leftViewMode = UITextFieldViewModeAlways;
}

- (CSLinearLayoutItem *)newItem :(id)view{
    CSLinearLayoutItem *item = [CSLinearLayoutItem layoutItemForView:view];
    item.padding = CSLinearLayoutMakePadding(10.0, 20.0, 10.0, 20.0);
    item.horizontalAlignment = CSLinearLayoutItemHorizontalAlignmentCenter;
    return item;
}

- (void)loginSuccess
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:STPinNumberKey]) {
        appDelegate.rest.authorization = [defaults objectForKey:STPinNumberKey];
        appDelegate.rest.currentuserid = [defaults objectForKey:STAccountNumberKey];
        appDelegate.rest.currentperson = [appDelegate.rest getUserProfile :appDelegate.rest.currentuserid]; 
    }
}

- (IBAction) ButtonReleased:(id)sender {
    if(useridTxt.text.length>5 && pwdTxt.text.length>3){
        NSString *pusername = useridTxt.text;
        NSString *ppassword = pwdTxt.text;
        [appDelegate.rest login :pusername :ppassword]; 
        if(appDelegate.rest.authorization.length >2 && ![appDelegate.rest.authorization isEqual: @"no network"] ){
            [[NSUserDefaults standardUserDefaults] setObject:appDelegate.rest.authorization forKey:STPinNumberKey];
            [[NSUserDefaults standardUserDefaults] setObject:appDelegate.rest.currentuserid forKey:STAccountNumberKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
            [self loginSuccess];
        }else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Social Tango" message:@"Please Check the Credentials" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }else
	{
		UIAlertView *alertsView = [[UIAlertView alloc] initWithTitle:@"Social Tango" message:@"Please Enter the Credentials" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertsView show];
    }
	[useridTxt resignFirstResponder];
	[pwdTxt resignFirstResponder];
}
@end