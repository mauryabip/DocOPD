//
//  Server.h
//  docOPD
//
//  Created by Ashutosh Kumar on 6/29/15.
//  Copyright (c) 2015 docOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ServerRequestFinishedProtocol <NSObject>

- (void) requestFinished:(NSDictionary * )responseData;
- (void) requestError;

@end



@interface server : NSObject
{
    NSMutableArray		    *daataArray;
    ServerRequestType		currentRequestType;
    //NSMutableURLRequest *request;
    NSMutableData           *receivedData;
    //NSData *responseData;
}
@property (nonatomic) NSURLConnection *connection;
@property (nonatomic, retain) id <ServerRequestFinishedProtocol> delegate;
- (void) sendRequestToServer:(NSDictionary*)userInfo withDataDic:(NSDictionary*)datadic;
- (NSMutableArray*)getResults;

@end
