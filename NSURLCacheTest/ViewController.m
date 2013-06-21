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
#import "CatPictureVC.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)dealloc
{
    [_phototArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    [webView addGestureRecognizer:singleTap];
//    //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
//    singleTap.delegate = self;
//    singleTap.cancelsTouchesInView = NO;
//    [singleTap release];
    
    NSError * error;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    NSString * aboutHuiShow =[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"aboutHuiShow is %@",aboutHuiShow);
    [webView loadHTMLString:aboutHuiShow baseURL:url];
    _phototArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    webView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [_phototArray removeAllObjects];
}
#pragma mark
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    //CAPTURE USER LINK-CLICK.
        NSURL * url= [request URL];
        NSLog(@"[URL scheme] is %@",[url scheme]);
        NSLog(@"[URL HOST] is %@",[url host]);
    
    if ([[url scheme] isEqualToString:@"sppic"]) {
        
         NSString * imageURL = [url.absoluteString stringByReplacingOccurrencesOfString:@"sppic" withString:@"http"];
        NSLog(@"imageURL is %@",imageURL);
        [_phototArray addObject:imageURL];
        
        
        CatPictureVC * cpvc = [[[CatPictureVC alloc] init] autorelease];
        cpvc.urlString = imageURL;
        UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:cpvc] autorelease];
        [self presentViewController:nav animated:YES completion:nil];
        
//        FGalleryViewController * fgallerVC = [[FGalleryViewController alloc] initWithPhotoSource:self] ;
//        // 将导航条设置为黑色透明的样式
//        UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:fgallerVC] autorelease];
//        [nav.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
//        [self presentViewController:nav animated:YES completion:nil];
//       [fgallerVC gotoImageByIndex:0 animated:NO]; // 调用这个方法可以进入照片页面
//        [fgallerVC release];
        
        return NO;
    }
        return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
//
//-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
//    NSLog(@"sender is %@",sender);
////    UIWebView * tmpWebView =(UIWebView*)sender;
//    
//    CGPoint point = [sender locationInView:webView];
//    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
//    
//    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", point.x, point.y];
//    NSLog(@"js is %@",[webView stringByEvaluatingJavaScriptFromString:js]);
//    
////    NSString * tagName = [tmpWebView stringByEvaluatingJavaScriptFromString:js];
//  
//    //sIf IMG tag was tapped, then you just need to get image URL:
//  
//    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", point.x, point.y];
//    
//    NSString *urlToSave = [webView stringByEvaluatingJavaScriptFromString:imgURL];
//    
//    NSLog(@"imageURL is %@",urlToSave);
//
//    }
#pragma mark
#pragma FGlarry
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    return [_phototArray count];
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    return @"";
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [_phototArray objectAtIndex:index];
}

@end
