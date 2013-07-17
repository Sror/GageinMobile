//
//  OACall.m
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 04/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import "OALnConsumer.h"
#import "OALnToken.h"
#import "OAProblem.h"
#import "OALnDataFetcher.h"
#import "OALnServiceTicket.h"
#import "OALnMutableURLRequest.h"
#import "OACall.h"

@interface OACall (Private)

- (void)callFinished:(OALnServiceTicket *)ticket withData:(NSData *)data;
- (void)callFailed:(OALnServiceTicket *)ticket withError:(NSError *)error;

@end

@implementation OACall

@synthesize url, method, parameters, files, ticket;

- (id)init {
	return [self initWithURL:nil
					  method:nil
				  parameters:nil
					   files:nil];
}

- (id)initWithURL:(NSURL *)aURL {
	return [self initWithURL:aURL
					  method:nil
				  parameters:nil
					   files:nil];
}

- (id)initWithURL:(NSURL *)aURL method:(NSString *)aMethod {
	return [self initWithURL:aURL
					  method:aMethod
				  parameters:nil
					   files:nil];
}

- (id)initWithURL:(NSURL *)aURL parameters:(NSArray *)theParameters {
	return [self initWithURL:aURL
					  method:nil
				  parameters:theParameters];
}

- (id)initWithURL:(NSURL *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters {
	return [self initWithURL:aURL
					  method:aMethod
				  parameters:theParameters
					   files:nil];
}

- (id)initWithURL:(NSURL *)aURL parameters:(NSArray *)theParameters files:(NSDictionary*)theFiles {
	return [self initWithURL:aURL
					  method:@"POST"
				  parameters:theParameters
					   files:theFiles];
}

- (id)initWithURL:(NSURL *)aURL
		   method:(NSString *)aMethod
	   parameters:(NSArray *)theParameters
			files:(NSDictionary*)theFiles {
	url = [aURL retain];
	method = [aMethod retain];
	parameters = [theParameters retain];
	files = [theFiles retain];
	fetcher = nil;
	request = nil;
	
	return self;
}

- (void)dealloc {
	[url release];
	[method release];
	[parameters release];
	[files release];
	[fetcher release];
	[request release];
	[ticket release];
	[super dealloc];
}

- (void)callFailed:(OALnServiceTicket *)aTicket withError:(NSError *)error {
	DLog(@"error body: %@", aTicket.body);
	self.ticket = aTicket;
	[aTicket release];
	OAProblem *problem = [OAProblem problemWithResponseBody:ticket.body];
	if (problem) {
		[delegate call:self failedWithProblem:problem];
	} else {
		[delegate call:self failedWithError:error];
	}
}

- (void)callFinished:(OALnServiceTicket *)aTicket withData:(NSData *)data {
	self.ticket = aTicket;
	[aTicket release];
	if (ticket.didSucceed) {
//		DLog(@"Call body: %@", ticket.body);
		[delegate performSelector:finishedSelector withObject:self withObject:ticket.body];
	} else {
//		DLog(@"Failed call body: %@", ticket.body);
		[self callFailed:[ticket retain] withError:nil];
	}
}

- (void)perform:(OALnConsumer *)consumer
		  token:(OALnToken *)token
		  realm:(NSString *)realm
	   delegate:(NSObject <OACallDelegate> *)aDelegate
	didFinish:(SEL)finished

{
	delegate = aDelegate;
	finishedSelector = finished;

	request = [[OALnMutableURLRequest alloc] initWithURL:url
											  consumer:consumer
												token:token
                                              callback:nil
									 signatureProvider:nil];
	if(method) {
		[request setHTTPMethod:method];
	}

	if (self.parameters) {
		[request setParameters:self.parameters];
	}
	if (self.files) {
		for (NSString *key in self.files) {

/* Commented out because I have no idea why Photo.jpg needs to be here			
 
            [request attachFileWithName:@"file" filename:NSLocalizedString(@"Photo.jpg", @"") data:[self.files objectForKey:key]];
*/
		}
	}
	fetcher = [[OALnDataFetcher alloc] init];
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(callFinished:withData:)
				  didFailSelector:@selector(callFailed:withError:)];
}

/*- (BOOL)isEqual:(id)object {
	if ([object isKindOfClass:[self class]]) {
		return [self isEqualToCall:(OACall *)object];
	}
	return NO;
}

- (BOOL)isEqualToCall:(OACall *)aCall {
	return (delegate == aCall->delegate
			&& finishedSelector == aCall->finishedSelector 
			&& [url isEqualTo:aCall.url]
			&& [method isEqualToString:aCall.method]
			&& [parameters isEqualToArray:aCall.parameters]
			&& [files isEqualToDictionary:aCall.files]);
}*/

@end
