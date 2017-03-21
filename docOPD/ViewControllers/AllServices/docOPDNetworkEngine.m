//
//  docOPDNetworkEngine.m
//  docOPD
//
//  Created by Virinchi Software on 22/09/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "docOPDNetworkEngine.h"

@implementation docOPDNetworkEngine
@synthesize callbackBlock;
- (id)init
{
    self = [super init];
    if (self) {
        responseData = [[NSMutableData alloc] init];
    }
    return self;
}

+ (docOPDNetworkEngine *)sharedInstance {
    static docOPDNetworkEngine *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[docOPDNetworkEngine alloc] init];
    });
    return __instance;
}
//withCallback: (void(^) (NSString* response)) callback;



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [responseData  setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData  appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Some error in your Connection. Please try again.");
    
    //    self.alertView = [[UIAlertView alloc] initWithTitle:NoInternetConnection message:TryAgainLater delegate:self cancelButtonTitle:OK otherButtonTitles:nil];
    //    [self.alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //        UIApplication *app = [UIApplication sharedApplication];
        //        [app performSelector:@selector(suspend)];
        // [NSThread sleepForTimeInterval:2.0];
        // exit(0);
    }
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //    NSLog(@"Received %lu Bytes", (unsigned long)[responseData length]);
    //    NSString *json = [[NSString alloc] initWithBytes:
    //                      [responseData mutableBytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    //callback(nil,nil);
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    // NSLog(@"jsonObject is %@",jsonObject);
    
    // NSLog(@"%@",json);
    callbackBlock(jsonObject);
}
-(void) SetAlbumSharingAPI:(NSString *) UserId AlbumId:(NSString*)AlbumId MobileNumber:(NSString*)MobileNumber  EmailId:(NSString*)EmailId withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetAlbumSharing xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                             "<AlbumId>%@</AlbumId>"
                             "<MobileNumber>%@</MobileNumber>"
                             "<EmailId>%@</EmailId>"
                             "</SetAlbumSharing>"
                             "</soap:Body>"
                             "</soap:Envelope>", UserId,AlbumId,MobileNumber,EmailId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetAlbumSharing" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) SetMultipalImageSharingAPI:(NSString *) UserId ImageId:(NSString*)ImageId MobileNumber:(NSString*)MobileNumber  EmailId:(NSString*)EmailId withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetMultipalImageSharing xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                             "<ImageId>%@</ImageId>"
                             "<MobileNumber>%@</MobileNumber>"
                             "<EmailId>%@</EmailId>"
                             "</SetMultipalImageSharing>"
                             "</soap:Body>"
                             "</soap:Envelope>", UserId,ImageId,MobileNumber,EmailId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetMultipalImageSharing" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
//DeleteMultipleAlbum

-(void) DeleteMultipleAlbumAPI:(NSString *) AlbumId  withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<DeleteMultipleAlbum xmlns=\"http://www.virinchisoftware.com/\">"
                             "<AlbumId>%@</AlbumId>"
                             "</DeleteMultipleAlbum>"
                             "</soap:Body>"
                             "</soap:Envelope>", AlbumId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/DeleteMultipleAlbum" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) DeleteMultipleImageAPI:(NSString *) AlbumId  withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<DeleteMultipleImage xmlns=\"http://www.virinchisoftware.com/\">"
                             "<ImageId>%@</ImageId>"
                             "</DeleteMultipleImage>"
                             "</soap:Body>"
                             "</soap:Envelope>", AlbumId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/DeleteMultipleImage" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
//RemoveAlbumSharing
-(void) RemoveAlbumSharingAPI:(NSString *) MobileNumber  AlbumId:(NSString *)AlbumId withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<RemoveAlbumSharing xmlns=\"http://www.virinchisoftware.com/\">"
                             "<MobileNumber>%@</MobileNumber>"
                             "<AlbumId>%@</AlbumId>"
                             "</RemoveAlbumSharing>"
                             "</soap:Body>"
                             "</soap:Envelope>", MobileNumber,AlbumId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/RemoveAlbumSharing" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
//GetMedicalRecordsByDate
-(void) GetMedicalRecordsByDateAPI:(NSString *)UserId  date:(NSString *)date withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetMedicalRecordsByDate xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                             "<date>%@</date>"
                             "</GetMedicalRecordsByDate>"
                             "</soap:Body>"
                             "</soap:Envelope>", UserId,date];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetMedicalRecordsByDate" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
//GetMedicalImageType
-(void) GetMedicalImageTypeAPI: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetMedicalImageType xmlns=\"http://www.virinchisoftware.com/\">"
                             "</GetMedicalImageType>"
                             "</soap:Body>"
                             "</soap:Envelope>"];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetMedicalImageType" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

//UpdateImageType
-(void) UpdateImageTypeAPI:(NSString *)Id withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UpdateImageType xmlns=\"http://www.virinchisoftware.com/\">"
                             "<Id>%@</Id>"
                             "</UpdateImageType>"
                             "</soap:Body>"
                             "</soap:Envelope>",Id];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UpdateImageType" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
//GetSpecialistList
-(void) GetSpecialistListAPI:(NSString *)Authkey withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetSpecialistList xmlns=\"http://www.virinchisoftware.com/\">"
                             "<Authkey>%@</Authkey>"
                             "</GetSpecialistList>"
                             "</soap:Body>"
                             "</soap:Envelope>",Authkey];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetSpecialistList" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
//SetUserRelation
-(void) SetUserRelationAPI:(NSString *)FirstName  LastName:(NSString *)LastName EmailId:(NSString *)EmailId MobileNumber:(NSString *)MobileNumber Relation:(NSString *)Relation UserId:(NSString *)UserId Lat:(NSString *)Lat Lon:(NSString *)Lon DeviceId:(NSString *)DeviceId gender:(NSString*)gender DOB:(NSString*)DOB   withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetUserRelation xmlns=\"http://www.virinchisoftware.com/\">"
                             "<FirstName>%@</FirstName>"
                             "<LastName>%@</LastName>"
                             "<EmailId>%@</EmailId>"
                             "<MobileNumber>%@</MobileNumber>"
                             "<Relation>%@</Relation>"
                             "<UserId>%@</UserId>"
                             "<Lat>%@</Lat>"
                             "<Lon>%@</Lon>"
                             "<DeviceId>%@</DeviceId>"
                             "<Gender>%@</Gender>"
                             "<DOB>%@</DOB>"
                             "</SetUserRelation>"
                             "</soap:Body>"
                             "</soap:Envelope>", FirstName,LastName,EmailId,MobileNumber,Relation,UserId,Lat,Lon,DeviceId,gender,DOB];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetUserRelation" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
//UpdateUserRelation
-(void) UpdateUserRelationAPI:(NSString *)FirstName  LastName:(NSString *)LastName EmailId:(NSString *)EmailId MobileNumber:(NSString *)MobileNumber Relation:(NSString *)Relation UserId:(NSString *)UserId Lat:(NSString *)Lat Lon:(NSString *)Lon DeviceId:(NSString *)DeviceId gender:(NSString*)gender DOB:(NSString*)DOB RelationId:(NSString*)RelationId  withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UpdateUserRelation xmlns=\"http://www.virinchisoftware.com/\">"
                             "<FirstName>%@</FirstName>"
                             "<LastName>%@</LastName>"
                             "<EmailId>%@</EmailId>"
                             "<MobileNumber>%@</MobileNumber>"
                             "<Relation>%@</Relation>"
                             "<UserId>%@</UserId>"
                             "<Lat>%@</Lat>"
                             "<Lon>%@</Lon>"
                             "<DeviceId>%@</DeviceId>"
                             "<Gender>%@</Gender>"
                             "<DOB>%@</DOB>"
                             "<RelationId>%@</RelationId>"
                             "</UpdateUserRelation>"
                             "</soap:Body>"
                             "</soap:Envelope>", FirstName,LastName,EmailId,MobileNumber,Relation,UserId,Lat,Lon,DeviceId,gender,DOB,RelationId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UpdateUserRelation" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

//GetRelation
-(void) GetRelationAPI:(NSString *)UserId withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetRelation xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                             "</GetRelation>"
                             "</soap:Body>"
                             "</soap:Envelope>",UserId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetRelation" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
//UploadUserImage
-(void) UploadUserImageByMobileNumberAPI:(NSString *)MobileNumber   UploadImage:(NSString *)UploadImage withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UploadUserImageByMobileNumber xmlns=\"http://www.virinchisoftware.com/\">"
                             "<MobileNumber>%@</MobileNumber>"
                             "<UploadImage>%@</UploadImage>"
                             "</UploadUserImageByMobileNumber>"
                             "</soap:Body>"
                             "</soap:Envelope>",MobileNumber,UploadImage];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UploadUserImageByMobileNumber" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
//RemoveRelation
-(void) RemoveRelationAPI:(NSString *)RelationId  UserId:(NSString *)UserId   withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<RemoveRelation xmlns=\"http://www.virinchisoftware.com/\">"
                             "<RelationId>%@</RelationId>"
                             "<UserId>%@</UserId>"
                             "</RemoveRelation>"
                             "</soap:Body>"
                             "</soap:Envelope>",RelationId,UserId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/RemoveRelation" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}
//SetUserReference
-(void) SetUserReferenceAPI:(NSString *)UserId  referenceCode:(NSString *)referenceCode   withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetUserReference xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                             "<ReferenceCode>%@</ReferenceCode>"
                             "</SetUserReference>"
                             "</soap:Body>"
                             "</soap:Envelope>",UserId,referenceCode];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetUserReference" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}


//FreeHealthTitleWithFreeStatus
-(void) FreeHealthTitleWithFreeStatusAPI:(NSString *)UserId    withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<FreeHealthTitleWithFreeStatus xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                             "</FreeHealthTitleWithFreeStatus>"
                             "</soap:Body>"
                             "</soap:Envelope>",UserId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/FreeHealthTitleWithFreeStatus" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

//GetReferenceCodeByUserId
-(void) GetReferenceCodeByUserIdAPI:(NSString *)UserId    withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetReferenceCodeByUserId xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                             "</GetReferenceCodeByUserId>"
                             "</soap:Body>"
                             "</soap:Envelope>",UserId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetReferenceCodeByUserId" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

-(void) GetLabTitleAPI:(NSString *)Authkey    withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<GetLabTitle xmlns=\"http://www.virinchisoftware.com/\">"
                             "<Authkey>%@</Authkey>"
                             "</GetLabTitle>"
                             "</soap:Body>"
                             "</soap:Envelope>",Authkey];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/GetLabTitle" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

//ReSendUserVerification
-(void) ReSendUserVerificationAPI:(NSString *)MobileNumber    withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<ReSendUserVerification xmlns=\"http://www.virinchisoftware.com/\">"
                             "<MobileNumber>%@</MobileNumber>"
                             "</ReSendUserVerification>"
                             "</soap:Body>"
                             "</soap:Envelope>",MobileNumber];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/ReSendUserVerification" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

//VerifyUser
-(void) VerifyUserAPI:(NSString *)VerificationCode  MobileId:(NSString *)MobileId   withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<VerifyUser xmlns=\"http://www.virinchisoftware.com/\">"
                             "<VerificationCode>%@</VerificationCode>"
                             "<MobileId>%@</MobileId>"
                             "</VerifyUser>"
                             "</soap:Body>"
                             "</soap:Envelope>",VerificationCode,MobileId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/VerifyUser" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

//SetCallSupport
-(void) SetCallSupportAPI:(NSString *)UserId  TitleName:(NSString *)TitleName   withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<SetCallSupport xmlns=\"http://www.virinchisoftware.com/\">"
                             "<UserId>%@</UserId>"
                             "<TitleName>%@</TitleName>"
                             "</SetCallSupport>"
                             "</soap:Body>"
                             "</soap:Envelope>",UserId,TitleName];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/SetCallSupport" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}

//UpdateCaptionBaseOnImageId

-(void) UpdateCaptionBaseOnImageIdAPI:(NSString *)Caption  ImageId:(NSString *)ImageId   withCallback: (void(^) (NSDictionary* responseData)) callback
{
    NSString * soapMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>"
                             "<UpdateCaptionBaseOnImageId xmlns=\"http://www.virinchisoftware.com/\">"
                             "<Caption>%@</Caption>"
                             "<ImageId>%@</ImageId>"
                             "</UpdateCaptionBaseOnImageId>"
                             "</soap:Body>"
                             "</soap:Envelope>",Caption,ImageId];
    
    
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://services.docopd.com/docOPDServices.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"services.docopd.com" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://www.virinchisoftware.com/UpdateCaptionBaseOnImageId" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initiate the request
    connection =[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(connection)
    {
        responseData = [NSMutableData data] ;
    }
    else
    {
        NSLog(@"Connection is NULL");
    }
    callbackBlock=callback;
    
}


@end
