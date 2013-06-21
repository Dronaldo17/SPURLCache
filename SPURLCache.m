//
//  SPURLCache.m
//  NSURLCacheTest
//
//  Created by doujingxuan on 13-6-20.
//  Copyright (c) 2013年 SpriteApp Inc. All rights reserved.
//

#import "SPURLCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "SandboxFile.h"

@implementation SPURLCache
- (void)dealloc
{
    [_requestQueue release];
    [super dealloc];
}
#pragma mark NSURLCache
- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path {
    self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path];
    found = 0;
    missed = 0;
    _requestQueue = [[NSMutableArray alloc] initWithCapacity:3];
    return self;
}
-(NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    //  NSLog( @"request cache for %@", [[request URL] description] );
    NSCachedURLResponse* cacheResponse  = [super cachedResponseForRequest: request];
    if( nil != cacheResponse ) {
        found++;
        NSLog(@"got cache from NSURLCache");
        NSLog(@"found %d missed %d", found, missed);
        return cacheResponse;
    }
    
    if( [self shouldBlockFileCache:request] ) {
         NSLog(@"block from file cache");
        missed++;
         NSLog(@"found %d missed %d", found, missed);
        return nil;
    }
    
    cacheResponse = [self loadCacheFromFile:request];
    if( nil == cacheResponse ) {
        missed++;
    } else {
        found++;
    }
    // NSLog(@"found %d missed %d", found, missed);
    
    return cacheResponse;
    
}
#pragma mark -
#pragma mark disk cache afx

-(NSString*) cacheFilePath:(NSURLRequest*) request {
    
    // parse url
    NSURL* url = request.URL;
    
    // the top path is host name
    NSString* host = url.host;
    // create hash code according to the reletive path
    NSString* relUrl = url.relativePath;
    NSUInteger hash = [relUrl hash];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"PATH S%@", paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* storagePath = [NSString stringWithFormat:@"%@/cache/%@/%08x", documentsDirectory, host, hash];
    // storagePath is auto release
    return storagePath;
}
-(NSCachedURLResponse*) loadCacheFromFile:(NSURLRequest*) request {
    
    NSCachedURLResponse* cacheResponse = nil;
    
    NSString* storagePath = [self cacheFilePath:request];
    if( nil == storagePath ) {
        return cacheResponse;
    }
    
    NSString* dataPath = [storagePath stringByAppendingString:@"/data"];
    NSString* mimePath = [storagePath stringByAppendingString:@"/mime"];
    NSString* encodingPath = [storagePath stringByAppendingFormat:@"/encoding"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        NSLog(@"CACHE FOUND for %@", request.URL.relativePath);
        
        NSData* content = [NSData dataWithContentsOfFile:dataPath];
        NSData* mimeData = [NSData dataWithContentsOfFile:mimePath];
        NSData* encodingData = [NSData dataWithContentsOfFile:encodingPath];
        
        NSString* mime = nil;
        if( nil != mimeData ) {
            mime = [[[NSString alloc] initWithData:mimeData encoding:NSUTF8StringEncoding] autorelease];
        } else {
            mime = @"";
        }
        NSString* encoding = nil;
        if( nil != encodingData ) {
            encoding = [[[NSString alloc] initWithData:encodingData encoding:NSUTF8StringEncoding] autorelease];
        }
        
        NSURLResponse* response = [[[NSURLResponse alloc] initWithURL:request.URL MIMEType:mime expectedContentLength:[content length] textEncodingName:encoding] autorelease];
        
        cacheResponse = [[[NSCachedURLResponse alloc] initWithResponse:response data:content] autorelease];
    } else {
        //trick here : if no cache, populate it asynchronously and return nil
        NSLog(@"download CACHE for %@", request.URL.relativePath);
        // [NSThread detachNewThreadSelector:@selector(populateCacheFor:) toTarget:self withObject:request];
         NSURL *url = request.URL;
        
        // downLoad this URL Picture
        [self downThisURLToLocal:url];
        
        // downLoad this URLRequest 
//        [self downThisURLToLocal:request];

    }
    
    return cacheResponse;
}
-(BOOL) shouldBlockFileCache:(NSURLRequest*) request {
    
    NSURL* url = request.URL;
    
    if( nil == url.host || 0 == url.host.length ) {
        // block the request without host
        return YES;
    }
    if( nil != url.user || nil != url.password ) {
        // block the request with security
        return YES;
    }
    
    // check the file type
    NSString* ressourceName = url.relativePath;
    ressourceName = [ressourceName lowercaseString];

    NSLog(@"ressourceName is%@",ressourceName);
    //we're only caching the following files 后续支持路径
//    if (
//        [ressourceName rangeOfString:@".png"].location!=NSNotFound ||
//        [ressourceName rangeOfString:@".jpg"].location!=NSNotFound ||
//        [ressourceName rangeOfString:@".gif"].location!=NSNotFound 
//        ) {
//        return NO;
//    }
    
    return NO;
//    return YES;
}
-(void)downThisURLToLocal:(NSURL*)url
{
    if ([_requestQueue containsObject:url]) {
        return;
    }
    else{
        [_requestQueue addObject:url];
    }
    GTMHTTPFetcher * fetcher = [GTMHTTPFetcher fetcherWithURL:url];
    [fetcher beginFetchWithDelegate:self didFinishSelector:@selector(myFetcher:finishedWithData:error:)];
}


//-(void)downThisURLToLocal:(NSURLRequest*)request
//{
//    if ([_requestQueue containsObject:request]) {
//        return;
//    }
//    else{
//        [_requestQueue addObject:request];
//    }
//    GTMHTTPFetcher * fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
//    [fetcher beginFetchWithDelegate:self didFinishSelector:@selector(myFetcher:finishedWithData:error:)];
//}
- (void)myFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error {
    if (error != nil) {
        NSLog(@"error is %@",error);
    } else {
        // fetch succeeded
        NSString* storagePath = [self cacheFilePath:fetcher.mutableRequest];
        NSData* content = data;
        NSString* contentType = [[fetcher responseHeaders] objectForKey:@"Content-Type"];
        NSString* mime = nil;
        NSString* encoding = nil;
        // split contentType
        NSRange sepRange = [contentType rangeOfString:@"; "];
        if( sepRange.location != NSNotFound ) {
            // sep the content type
            mime = [contentType substringToIndex: sepRange.location];
            // get text encoding
            encoding = [contentType substringFromIndex: (sepRange.location + sepRange.length)];
        } else {
            mime = contentType;
        }
        
        NSError* fileError = nil;
        //the store is invoked automatically.
        [[NSFileManager defaultManager] createDirectoryAtPath:storagePath withIntermediateDirectories:YES attributes:nil error:&fileError];
        BOOL ok;
        
        NSString* dataPath = [storagePath stringByAppendingString:@"/data"];
        ok = [content writeToFile:dataPath atomically:YES];
        
        if( ok ) {
            //save mime and encoding
            if( nil != mime ) {
                error = nil;
                NSString* mimePath = [storagePath stringByAppendingString:@"/mime"];
                [mime writeToFile:mimePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            }
            if( nil != encoding ) {
                error = nil;
                NSString* encodingPath = [storagePath stringByAppendingFormat:@"/encoding"];
                [encoding writeToFile:encodingPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                }
            [_requestQueue removeObject:fetcher.mutableRequest];
         }
    }
}

@end
