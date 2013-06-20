//
//  SPHttpRequest.h
//  GTMHTTPFetcher
//
//  Created by doujingxuan on 13-6-17.
//
//

#import <Foundation/Foundation.h>
#import "GTMHTTPFetcher.h"

@protocol SPHttpRequestDelegate
-(void)spRequestSuccessWithFinishData:(NSData*)data;
-(void)spRequestFailed:(NSError*)error;
@end

typedef void (^SPHTTPSuccessBlock)(NSData *data);
typedef void (^SPHTTPFailedBlock)(NSError*error);

@interface SPHttpRequest : NSObject
{
    GTMHTTPFetcher * _gtmRequest;
    NSMutableArray * _parameters;
    NSMutableURLRequest * _urlRequest;
}
@property (nonatomic,retain)GTMHTTPFetcher * gtmRequest;
@property (nonatomic,assign)id delegate;
@property (nonatomic,retain)NSString * reuqestMethod;
@property (assign) SEL didFinishSelector;
@property (assign) SEL didFailSelector;
@property (copy) SPHTTPSuccessBlock  completedBlock;
@property (copy) SPHTTPFailedBlock failedBlock;


-(id)initWithURL:(NSURL*)url timeOut:(NSTimeInterval)timeOut ByHttpMethod:(NSString*)method;
-(id)initWithURL:(NSURL*)url timeOut:(NSTimeInterval)timeOut withParameters:(NSMutableDictionary*)parameters ByHttpMethod:(NSString*)method;
-(id)initWithRequest:(NSMutableURLRequest *)request;

- (void)setPostValue:(id <NSObject>)value forKey:(NSString *)key;
-(void)startAsyncSPHttpRequest;

-(void)clearDelegatesAndCancelRequest;
@end
