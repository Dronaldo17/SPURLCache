//
//  SPHttpRequest.m
//  GTMHTTPFetcher
//
//  Created by doujingxuan on 13-6-17.
//
//

#import "SPHttpRequest.h"
#define TIMEOUT 30.0f
#define CPOSTKey            @"key"
#define CPOSTValue          @"value"

@implementation SPHttpRequest
@synthesize gtmRequest = _gtmRequest,completedBlock,failedBlock,delegate = _delegate,reuqestMethod;
- (void)dealloc
{
    if (_gtmRequest) {
        [_gtmRequest release];
    }
    _gtmRequest = nil;
    
    if (_urlRequest) {
        [_urlRequest release];
    }
    _urlRequest = nil;
    self.completedBlock = nil;
    self.failedBlock = nil;
    self.reuqestMethod = nil;
    [super dealloc];
}
-(id)initWithURL:(NSURL*)url timeOut:(NSTimeInterval)timeOut ByHttpMethod:(NSString *)method
{
    self = [super init];
    if (self) {
        if (nil == url) {
            return nil;
        }
        if (timeOut<0) {
            return nil;
        }
        if (nil == method) {
            return nil;
        }
        _urlRequest = [NSMutableURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                          timeoutInterval:timeOut];
        [_urlRequest setHTTPShouldHandleCookies:YES];
        [_urlRequest setHTTPShouldUsePipelining:YES];
        [_urlRequest retain];
        
        _gtmRequest = [[GTMHTTPFetcher alloc] init];
        self.reuqestMethod = method;
    }
    
    return self;
    
}
-(id)initWithURL:(NSURL*)url timeOut:(NSTimeInterval)timeOut withParameters:(NSMutableDictionary*)parameters ByHttpMethod:(NSString *)method
{
    self = [super init];
    if (self) {
        if (nil == url) {
            return nil;
        }
        if (timeOut<0) {
            return nil;
        }
        if (nil == method) {
            return nil;
        }
        
        if (nil == parameters) {
            return nil;
        }
        
        _urlRequest = [NSMutableURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                          timeoutInterval:timeOut];
        [_urlRequest setHTTPShouldHandleCookies:YES];
        [_urlRequest setHTTPShouldUsePipelining:YES];
        [_urlRequest retain];
        
        if (nil != parameters) {
            NSEnumerator *enumerator = [parameters keyEnumerator];
            id key;
            
            while ((key = [enumerator nextObject])) {
                
                NSString* value = (NSString*)[parameters objectForKey:key];
                // set post data
                [self setPostValue:value forKey:(NSString*)key];
            }
        }
        _gtmRequest = [[GTMHTTPFetcher alloc] init];
        self.reuqestMethod = method;
    }
    return self;
}
-(id)initWithRequest:(NSMutableURLRequest *)request
{
    self = [super init];
    if (self) {
        _urlRequest = request;
        [_urlRequest retain];
        _gtmRequest = [[GTMHTTPFetcher alloc] init];
    }
    return self;
}

- (void)addPostValue:(id <NSObject>)value forKey:(NSString *)key
{
	if (!key || !value) {
		return;
	}
	if (!_parameters) {
		_parameters = [NSMutableArray arrayWithCapacity:0];
	}
	NSMutableDictionary *keyValuePair = [NSMutableDictionary dictionaryWithCapacity:2];
    [keyValuePair setValue:key forKey:CPOSTKey];
	[keyValuePair setValue:[value description]forKey:CPOSTValue];
	[_parameters addObject:keyValuePair];
    [self buildMultipartFormDataPostBody];
}

- (void)setPostValue:(id <NSObject>)value forKey:(NSString *)key
{
    if (nil == _parameters) {
        _parameters = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else{
        // Remove any existing value
        NSUInteger i;
        for (i=0; i<[_parameters count]; i++) {
            NSDictionary *val = [_parameters objectAtIndex:i];
            
            if ([[val objectForKey:CPOSTKey] isEqualToString:key]) {
                [_parameters removeObject:val];
                i--;
            }
        }
    }
	[self addPostValue:value forKey:key];
}
-(void)buildMultipartFormDataPostHeader
{
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    // Set your own boundary string only if really obsessive. We don't bother to check if post data contains the boundary, since it's pretty unlikely that it does.
    NSString *stringBoundary = @"0xKhTmLbOuNdArY";
    [_urlRequest addValue:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, stringBoundary] forHTTPHeaderField:@"Content-Type"];
    
}
-(void)buildMultipartFormDataPostBody
{
    
    if (nil == _urlRequest) {
        _urlRequest = [[NSMutableURLRequest alloc] init];
    }
    self.reuqestMethod = @"POST";
    NSString *stringBoundary = @"0xKhTmLbOuNdArY";
    
    NSString *boundry   = [NSString stringWithFormat:@"--%@\r\n", stringBoundary];
    NSMutableData *data = [NSMutableData dataWithCapacity:1];
    
    // iterate over the postData thing and spit out our post data!
    for (NSDictionary * dict in _parameters)
    {
        NSString * key = [dict objectForKey:CPOSTKey];
        id value = [dict objectForKey:CPOSTValue];
        
        [data appendData:[boundry dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([value isKindOfClass:[NSString class]])
        {
            [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[[NSString stringWithFormat:@"%@", value] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else if(([value isKindOfClass:[NSNumber class]]))
        {
            [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[[NSString stringWithFormat:@"%@", value] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    [data appendData:[[NSString stringWithFormat:@"--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [_urlRequest setHTTPBody:data];
}
-(void)startAsyncSPHttpRequest;
{
    if (nil == _urlRequest) {
        return;
    }
    NSLog(@"self.reuqestMethod is %@",self.reuqestMethod);
    if (self.reuqestMethod) {
        [_urlRequest setHTTPMethod:self.reuqestMethod];
    }
    
    if (nil == _gtmRequest) {
        _gtmRequest = [[GTMHTTPFetcher alloc] initWithRequest:_urlRequest];
    }
    [self buildMultipartFormDataPostHeader];
    _gtmRequest.mutableRequest = _urlRequest;
    [_gtmRequest  beginFetchWithDelegate:self didFinishSelector:@selector(myFetcher:finishedWithData:error:)];
}
- (void)myFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error
{
    if (nil == error) {
        [self requestSuccessWithFinishData:retrievedData];
    }
    else{
        [self requestFailed:error];
    }
    
}
-(void)requestSuccessWithFinishData:(NSData*)retrievedData
{
    if (self.completedBlock) {
        self.completedBlock(retrievedData);
    }
    if ([_delegate respondsToSelector:@selector(spRequestSuccessWithFinishData:)]) {
        [_delegate spRequestSuccessWithFinishData:retrievedData];
    }
    
    if (_delegate && _didFinishSelector){
        NSMethodSignature *sig = [_delegate methodSignatureForSelector:_didFinishSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setSelector:_didFinishSelector];
        [invocation setTarget:_delegate];
        [invocation setArgument:&retrievedData atIndex:2];
        [invocation invoke];
    }
}
-(void)requestFailed:(NSError*)error
{
    if (self.failedBlock) {
        self.failedBlock(error);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(spRequestFailed:)]) {
        [_delegate spRequestFailed:error];
    }
    if (_delegate && _didFailSelector){
        NSMethodSignature *sig = [_delegate methodSignatureForSelector:_didFailSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setSelector:_didFailSelector];
        [invocation setTarget:_delegate];
        [invocation setArgument:&error atIndex:2];
        [invocation invoke];
    }
}
-(void)clearDelegatesAndCancelRequest
{
    if(_gtmRequest){
        [_gtmRequest stopFetching];
    }
    _gtmRequest = nil;
    _gtmRequest.delegate = nil;
    _delegate = nil;
    
    self.completedBlock = nil;
    self.failedBlock = nil;
    self.didFailSelector = nil;
    self.didFailSelector = nil;
    self.reuqestMethod = nil;
}
@end
