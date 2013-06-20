//
//  ViewController.m
//  NSURLCacheTest
//
//  Created by doujingxuan on 13-6-20.
//  Copyright (c) 2013年 SpriteApp Inc. All rights reserved.
//

#import "ViewController.h"
#import "SandboxFile.h"
#import "SPURLCache.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString * htmlString = @"http://forgifs.com/gallery/d/209909-1/Elevator-casket-prank.gif";
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlString]];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
