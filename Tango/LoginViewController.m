//
//  ViewController.m
//  Test6
//
//  Created by Devaraj NS on 12/02/13.
//  Copyright (c) 2013 Devaraj NS. All rights reserved.
//

#import "LoginViewController.h"
#import "CSLinearLayoutView.h"
#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 6
#define STAccountNumberKey		@"accountNumber"
#define STPinNumberKey			@"AccessTokenKey"
@interface LoginViewController (){
}
@end
@implementation LoginViewController

@synthesize linearLayoutView;
@synthesize useridTxt;
@synthesize pwdTxt;
@synthesize appDelegate;
@synthesize largeButton,powerimg;
@synthesize bgimg,logo,usrfield,pwdfield;

- (IBAction) ButtonReleased:(id)sender {
    if(useridTxt.text.length>5 && pwdTxt.text.length>3){
        NSString *pusername = useridTxt.text ;
        NSString *ppassword = pwdTxt.text;
        [appDelegate.rest login :pusername :ppassword];
        
        if(appDelegate.rest.authorization.length >2 ){
            [[NSUserDefaults standardUserDefaults] setObject:appDelegate.rest.authorization forKey:STPinNumberKey];
            [[NSUserDefaults standardUserDefaults] setObject:appDelegate.rest.currentuserid forKey:STAccountNumberKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
            [self loginSuccess];
        }else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Social Tango" message:@"Please Check the Credentials"   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }else
	{
		UIAlertView *alertsView = [[UIAlertView alloc] initWithTitle:@"Social Tango" message:@"Please Enter the Credentials"   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertsView show];
    }
	[useridTxt resignFirstResponder];
	[pwdTxt resignFirstResponder];
}

- (void)loginSuccess
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:STPinNumberKey]) {
        appDelegate.rest.authorization = [defaults objectForKey:STPinNumberKey];
        appDelegate.rest.currentuserid = [defaults objectForKey:STAccountNumberKey];
        appDelegate.rest.currentperson = [appDelegate.rest getUserProfile :appDelegate.rest.currentuserid];
        [self performSegueWithIdentifier:@"loggedin" sender:self];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;{
    
    if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation))
    {
        //portrait
        [self setPortrait :true];
    }
    else
    {
        [self setPortrait :false];
    }
}

-(void)setPortrait:(BOOL)isPortrait{
 /*   if(isPortrait){
        bgimg.image = [UIImage imageNamed:@"login_portrait"];
        bgimg.frame = self.view.bounds;
        powerimg.frame =  CGRectMake(self.view.bounds.size.width-251,self.view.bounds.size.height-121,251,121);
    }else{
        bgimg.image = [UIImage imageNamed:@"login_landscape"];
        bgimg.frame = CGRectMake(self.view.bounds.origin.x,self.view.bounds.origin.y,self.view.bounds.size.width,self.view.bounds.size.height);
        powerimg.frame =  CGRectMake(self.view.bounds.size.width-251,self.view.bounds.size.height-121,251,121);
    }*/
}

- (CSLinearLayoutItem *)newItem :(id)view{
    CSLinearLayoutItem *item = [CSLinearLayoutItem layoutItemForView:view];
    item.padding = CSLinearLayoutMakePadding(10.0, 20.0, 10.0, 20.0);
    item.horizontalAlignment = CSLinearLayoutItemHorizontalAlignmentCenter;
    return item;
}
 

- (void)viewDidAppear:(BOOL)animated
{
    NSString *storedToken = [[NSUserDefaults standardUserDefaults] objectForKey:STPinNumberKey];
    if(storedToken.length>2){
        [useridTxt setText:[[NSUserDefaults standardUserDefaults]  objectForKey:STAccountNumberKey]];
        [pwdTxt setText:@"dummy data only for password"];
        [self loginSuccess];
    }
}

- (void)viewDidLoad
{ 
    self.view.backgroundColor =[UIColor colorWithRed:30.0f/255.0f green:20.0f/255.0f blue:22.0f/255.0f alpha:1];
    self.linearLayoutView = [[CSLinearLayoutView alloc] initWithFrame:CGRectMake(0, 0, 500,500)];
    linearLayoutView.orientation = CSLinearLayoutViewOrientationVertical;
    linearLayoutView.scrollEnabled = YES;
    linearLayoutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    linearLayoutView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:linearLayoutView];
    
    CGRect frame =CGRectMake(0, 0, 50, 35);
    useridTxt = [[UITextField alloc] initWithFrame:frame];
    [useridTxt setPlaceholder:@"User Id"];
    [useridTxt setReturnKeyType:UIReturnKeyDone];
    useridTxt.keyboardType = UIKeyboardTypeNumberPad;
    useridTxt.borderStyle =UITextBorderStyleRoundedRect;
    useridTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    useridTxt.delegate = self;
    
    pwdTxt = [[UITextField alloc] initWithFrame:frame];
    pwdTxt.secureTextEntry = YES;
    [pwdTxt setPlaceholder:@"Password"];
    [pwdTxt setReturnKeyType:UIReturnKeyDone];
    pwdTxt.borderStyle =UITextBorderStyleRoundedRect;
    pwdTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTxt.delegate = self;
    
    largeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect cframe =CGRectMake(0, 0, 70, 73);
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
    [self.view addSubview:usrfield];
    
    useridTxt.leftView = usrfield;
    useridTxt.leftViewMode = UITextFieldViewModeAlways;
    
    pwdfield = [[UIImageView alloc] init];
    pwdfield.image =  [UIImage imageNamed:@"login_Pg_PasswordField01"];
    pwdfield.frame = CGRectMake(0, 0, 35, 35);
    [self.view addSubview:pwdfield];
    
    pwdTxt.leftView = pwdfield;
    pwdTxt.leftViewMode = UITextFieldViewModeAlways;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end