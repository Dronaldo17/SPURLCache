//
//  CatPictureVC.h
//  NSURLCacheTest
//
//  Created by doujingxuan on 13-6-21.
//  Copyright (c) 2013年 SpriteApp Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatPictureVC : UIViewController
{
    IBOutlet UIWebView * _catWebView;
}
@property (nonatomic,retain)NSString * urlString;
@end
