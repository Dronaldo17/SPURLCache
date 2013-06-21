//
//  SPURLCache.h
//  NSURLCacheTest
//
//  Created by doujingxuan on 13-6-20.
//  Copyright (c) 2013年 SpriteApp Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPHttpRequest.h"

@interface SPURLCache : NSURLCache
{
    int found;
    int missed;
    NSMutableArray * _requestQueue;
}
//-(void)downThisURLToLocal:(NSURL*)url;
@end
