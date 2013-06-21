//
//  ViewController.h
//  NSURLCacheTest
//
//  Created by doujingxuan on 13-6-20.
//  Copyright (c) 2013年 SpriteApp Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"

@interface ViewController : UIViewController<UIGestureRecognizerDelegate,UIWebViewDelegate,FGalleryViewControllerDelegate>
{
    IBOutlet UIWebView * webView;
    NSMutableArray * _phototArray;
}
@end
