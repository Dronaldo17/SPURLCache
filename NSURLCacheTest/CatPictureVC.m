//
//  CatPictureVC.m
//  NSURLCacheTest
//
//  Created by doujingxuan on 13-6-21.
//  Copyright (c) 2013年 SpriteApp Inc. All rights reserved.
//

#import "CatPictureVC.h"

#define HTML_FOR_GIF_SHOW @"<html><head></head><body leftmargin=0 topmargin=0 padding=0><img width=%.2fpx height=%.2fpx src=\"%@\"></body></html>"

@interface CatPictureVC ()

@end

@implementation CatPictureVC
@synthesize urlString;
- (void)dealloc
{
    self.urlString = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UIButton * button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)] autorelease];
//    [button setTitle:@"取消" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissCatPictureVC:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * backBarButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
//    self.navigationController.navigationItem.leftBarButtonItem = backBarButton;
    UIBarButtonItem * barButton = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissCatPictureVC:)] autorelease];
    self.navigationItem.leftBarButtonItem = barButton;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [_catWebView loadRequest:request];
    
//    NSString *strHtml = [NSString stringWithFormat:HTML_FOR_GIF_SHOW, rc.size.width, rc.size.height, strFile];
//    
//    [m_webview loadHTMLString:strHtml baseURL:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissCatPictureVC:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.urlString = nil;
}
@end
