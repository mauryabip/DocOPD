//
//  Server.m
//  docOPD
//
//  Created by Ashutosh Kumar on 6/29/15.
//  Copyright (c) 2015 docOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "server.h"

@implementation server
- (NSMutableURLRequest*) docOPDSignup:(NSDictionary*)userInfo
{
//    NSUserDefaults *userpref = userDefault;
    NSString *mob=  [userInfo objectForKey:Mobile];
    NSString *pwrd=    [userInfo objectForKey:Password];
//    NSString *devtok = [userpref objectForKey:DeviceToken];
    NSString *devtok =  [AppDelegate MyappDelegate].deviceTok;
    NSString *fullname = [userInfo objectForKey:FullName];
    //NSString *email = [userInfo objectForKey:EmailID];
    NSString *lat = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlat];
    NSString *lng = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlong];
    NSString* vendorId = [AppDelegate MyappDelegate].vendorId;
    
    
    //UserName,Password,MobileNo,EmailId,Lat,Log,DeviceId,DeviceType,DeviceToken
    //POST /docOPDservices.asmx/UserSignUp
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"UserSignUp"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"UserName=%@&Password=%@&MobileNo=%@&EmailId=&Lat=%@&Log=%@&DeviceId=%@&DeviceType=%@&DeviceToken=%@&UserOrDoctor=%@&Gender=",fullname,pwrd,mob,lat,lng,vendorId,DeviceType,devtok,usertype];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDSignIn:(NSDictionary*)userInfo
{
//    NSUserDefaults *userpref = userDefault;
    NSString *mob=  [userInfo objectForKey:Mobile];
    NSString *pwrd=    [userInfo objectForKey:Password];
//    NSString *devtok = [userpref objectForKey:DeviceToken];
    NSString *devtok =  [AppDelegate MyappDelegate].deviceTok;
    NSString* vendorId = [AppDelegate MyappDelegate].vendorId;
    //MobileNumber,Password
    //POST UserSignIn
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"UserSignIn"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"MobileNumber=%@&Password=%@&DeviceId=%@&DeviceType=%@&DeviceToken=%@",mob,pwrd,vendorId,DeviceType,devtok];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}
- (NSMutableURLRequest*) docOPDUserVerify:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *mob=  [userpref objectForKey:Mobile];
    NSString *pwrd=    [userInfo objectForKey:Verificationcode];
    
    //MobileNumber,Password
    //POST UserSignIn
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"VerifyUser"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"MobileId=%@&VerificationCode=%@",mob,pwrd];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDPwdResetOTP:(NSDictionary*)userInfo
{
    NSString *mob=  [userInfo objectForKey:Mobile];
    //MobileNumber,
    //POST ReSendUserVerification
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"ReSendUserVerification"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"MobileNumber=%@",mob];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDVerifyOTP:(NSDictionary*)userInfo
{
    NSString *mob=  [userInfo objectForKey:Mobile];
    NSString *otp=  [userInfo objectForKey:Verificationcode];
    //MobileNumber,
    //POST ReSendUserVerification
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"VerifyOTP"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"MobileNumber=%@&VerificationCode=%@",mob,otp];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSMutableURLRequest*) docOPDForgetResetPassword:(NSDictionary*)userInfo
{
    NSString *mob=  [userInfo objectForKey:Mobile];
    NSString *password=  [userInfo objectForKey:Password];
    //MobileNumber,
    //POST ReSendUserVerification
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"ForgetResetPassword"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"MobileNumber=%@&NewPassword=%@",mob,password];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}




- (NSMutableURLRequest*) docOPDResetPassword:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *mob=  [userpref objectForKey:Mobile];
    NSString *newpwd=  [userInfo objectForKey:Password];
   NSString *oldpwd=  [userInfo objectForKey:OldPassword];
    NSString *authKey=  [userpref objectForKey:AuthKey];
    //MobileNumber,
    //POST ReSendUserVerification
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"ResetPassword"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    //NSString *postString =  [NSString stringWithFormat:@"MobileNumber=%@&NewPassword=%@",mob,newpwd];
    NSString *postString =  [NSString stringWithFormat:@"Authkey=%@&MobileNumber=%@&OldPassword=%@&NewPassword=%@",authKey,mob,oldpwd,newpwd];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDGetAllDocList:(NSDictionary*)userInfo
{
      //POST GetDoctorList
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetDoctorList"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"Authkey=%@",[userInfo valueForKey:AuthKey]];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}
- (NSMutableURLRequest*) docOPDGetHospitalList:(NSDictionary*)userInfo
{
    //POST GetDoctorList
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetHospitalList"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"Authkey=%@",[userInfo valueForKey:AuthKey]];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDGetProcedureList:(NSDictionary*)userInfo
{
    //POST GetDoctorList
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetProcedureList"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"Authkey=%@",[userInfo valueForKey:AuthKey]];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSMutableURLRequest*) docOPDGetDoctorListByDoctorName:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *authKey=  [userpref objectForKey:AuthKey];
//    NSString *FName=[userInfo objectForKey:fName];
//    NSString *MiddleName = [userInfo objectForKey:mName];
//    NSString *LastName = [userInfo objectForKey:lName];
    
  NSString *FName=    [userInfo objectForKey:@"DocData"][@"FirstName"];
    NSString *MiddleName =[userInfo objectForKey:@"DocData"][@"MiddleName"];
    NSString *LastName = [userInfo objectForKey:@"DocData"][@"LastName"];;

    NSString *lat = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlat];
    NSString *lng = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlong];
    NSString* PIndex = [userInfo objectForKey:PageIndex];
    
    
    //UserName,Password,MobileNo,EmailId,Lat,Log,DeviceId,DeviceType,DeviceToken
    //POST /docOPDservices.asmx/UserSignUp
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetDoctorListByDoctorName"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"AuthKey=%@&FirstName=%@&MiddleName=%@&LastName=%@&Lat=%@&Log=%@&PageIndex=%@&DeviceId=%@&DeviceType=%@",authKey,FName,MiddleName,LastName,lat,lng,PIndex,[AppDelegate MyappDelegate].vendorId,DeviceType];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDGetHospitalByHosName:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *authKey=  [userpref objectForKey:AuthKey];
    NSString *HName=    [userInfo objectForKey:HospitalName];
    NSString *lat = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlat];
    NSString *lng = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlong];
    NSString* PIndex = [userInfo objectForKey:PageIndex];
    //UserName,Password,MobileNo,EmailId,Lat,Log,DeviceId,DeviceType,DeviceToken
    //POST /docOPDservices.asmx/UserSignUp
    HName = [self ReplaceSpecialCharacter:HName];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetHospitalListByHospitalName"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"request string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"AuthKey=%@&HospitalName=%@&Lat=%@&Log=%@&PageIndex=%@&deviceId=%@&DeviceType=%@",authKey,HName,lat,lng,PIndex,[AppDelegate MyappDelegate].vendorId,DeviceType];
//    NSLog(@"Parameter string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDHospitalProfile:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *authKey=  [userpref objectForKey:AuthKey];
    NSString *HosID=    [userInfo objectForKey:HospitalID];
    NSString *lat = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlat];
    NSString *lng = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlong];
    NSString* DevId = [AppDelegate MyappDelegate].vendorId;
    NSString* userid = [userpref objectForKey:User_id];

    
    //UserName,Password,MobileNo,EmailId,Lat,Log,DeviceId,DeviceType,DeviceToken
    //POST /docOPDservices.asmx/UserSignUp
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"HospitalProfile"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"AuthKey=%@&HospitalId=%@&UserId=%@&Lat=%@&Log=%@&DeviceId=%@&DeviceType=%@",authKey,HosID,userid,lat,lng,DevId,DeviceType];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDGetSpecialistList:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *authKey=  [userpref objectForKey:AuthKey];
    //AuthKey
    //POST /docOPDservices.asmx/GetSpecialistList
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetSpecialistList"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"AuthKey=%@",authKey];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}
- (NSMutableURLRequest*) docOPDGetProcedureListByProcedureId:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *authKey=  [userpref objectForKey:AuthKey];
    NSString *pid=    [userInfo objectForKey:ProcedureID];
    NSString *lat = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlat];
    NSString *lng = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlong];
    NSString* PIndex = [userInfo objectForKey:PageIndex];
    //UserName,Password,MobileNo,EmailId,Lat,Log,DeviceId,DeviceType,DeviceToken
    //POST /docOPDservices.asmx/UserSignUp
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetProcedureListByProcedureId"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"AuthKey=%@&ProcedureId=%@&Lat=%@&Log=%@&PageIndex=%@",authKey,pid,lat,lng,PIndex];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSMutableURLRequest*) docOPDDoctorProfile:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *authKey=  [userpref objectForKey:AuthKey];
    NSString *DoctorId=    [userInfo objectForKey:DoctorID];
    NSString* userid = [userpref objectForKey:User_id];
    NSString *lat = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlat];
    NSString *lng = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlong];
    NSString* DevId = [AppDelegate MyappDelegate].vendorId;
    NSString *proID=    [userInfo objectForKey:@"pro_id"];
    NSString* specid = [userInfo objectForKey:@"spec_id"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"DoctorProfile"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"AuthKey=%@&DoctorId=%@&UserId=%@&Lat=%@&Log=%@&DeviceId=%@&DeviceType=%@&ProcedureId=%@&SpecialiseId=%@",authKey,DoctorId,userid,lat,lng,DevId,DeviceType,proID?proID:@"",specid?specid:@""];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSMutableURLRequest*) docOPDGetDoctorBySpecialist:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *authKey=  [userpref objectForKey:AuthKey];
    NSString *SpecId=    [userInfo objectForKey:@"SpecId"];
    NSString *lat = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlat];
    NSString *lng = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlong];
    NSString* PIndex = [userInfo objectForKey:PageIndex];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetDoctorBySpecialist"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"Authkey=%@&SpecialistId=%@&Lat=%@&Log=%@&PageIndex=%@&DeviceType=%@&DeviceId=%@",authKey,SpecId,lat,lng,PIndex,DeviceType,[AppDelegate MyappDelegate].vendorId];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDGetDoctorByNormalSpecialist:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *authKey=  [userpref objectForKey:AuthKey];
    NSString *SpecId=    [userInfo objectForKey:@"SpecId"];
    NSString *lat = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlat];
    NSString *lng = [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlong];
    NSString* PIndex = [userInfo objectForKey:PageIndex];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetDoctorByNormalSpecialist"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    //    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"Authkey=%@&SpecialistId=%@&Lat=%@&Log=%@&PageIndex=%@&DeviceType=%@&DeviceId=%@",authKey,SpecId,lat,lng,PIndex,DeviceType,[AppDelegate MyappDelegate].vendorId];
    //    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}



- (NSMutableURLRequest*) docOPDsetImageBooking:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
 
    NSString *imagename    =   [userInfo objectForKey:ImgName];
    NSString *base64str    =   [userInfo objectForKey:base64];
    NSString *bookingId    =   [userInfo objectForKey:Booking_Id];
    NSString *userid       = [userpref objectForKey:User_id];
   
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"setImageBooking"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"UploadImage=%@&ImageName=%@&UserId=%@&BookingId=%@",base64str,imagename,userid,bookingId];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDUploadEnquiryImage:(NSDictionary*)userInfo
{
    //NSUserDefaults *userpref = userDefault;
    
    NSString *imagename    =   [userInfo objectForKey:ImgName];
    NSString *base64str    =   [userInfo objectForKey:base64];
    NSString *enquiryId    =   [userInfo objectForKey:EnquiryId];
    //NSString *userid       = [userpref objectForKey:User_id];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"UploadEnquiryImage"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    //    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"UploadImage=%@&ImageName=%@&EnquiryId=%@",base64str,imagename,enquiryId];
    //    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDSetServiceImage:(NSDictionary*)userInfo
{
    //NSUserDefaults *userpref = userDefault;
    NSString *userId       =   [userInfo objectForKey:User_id];
    NSString *imagename    =   [userInfo objectForKey:ImgName];
    NSString *base64str    =   [userInfo objectForKey:base64];
    NSString *ServiceId    =   [userInfo objectForKey:@"ServiceId"];
    //NSString *userid       = [userpref objectForKey:User_id];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"SetServiceImage"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    //    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"UploadImage=%@&ImageName=%@&UserId=%@&ServiceId=%@",base64str,imagename,userId,ServiceId];
    //    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}




- (NSMutableURLRequest*) docOPDSetBooking:(NSDictionary*)userInfo
{
/*
AuthKey:
UserId:
UserName:
DoctorId:
HospitalId:
BookingDate:
BookingTime:
AppointmentReason:
EmailId:
MobileNo:
Lat:
Log:
DeviceId:
DeviceType:
ImageId:
    
 */
    
    NSUserDefaults *userpref = userDefault;
    NSString *authKey           =  [userpref objectForKey:AuthKey];
    NSString *UserId            =    [userInfo objectForKey:User_id];
    NSString *username          =    [userInfo objectForKey:FullName];
    NSString *DoctorId          =    [userInfo objectForKey:DoctorID];
    NSString *HospitalId        =    [userInfo objectForKey:HospitalID];
    NSString *bookingdate       =    [userInfo objectForKey:BookingDate];
    NSString *bookingtime       =    [userInfo objectForKey:BookingTime];
    NSString *AppointmentReason =    [userInfo objectForKey:appointmentReason];
    NSString *emailid           =    [userInfo objectForKey:EmailID];
    NSString *MobileNo          =    [userInfo objectForKey:Mobile];
    NSString *lat               =   [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlat];
    NSString *lng               =   [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlong];
    NSString* DevId             =   [AppDelegate MyappDelegate].vendorId;
    NSString* imgid             =   [userInfo objectForKey:imgIDS];;
    
    NSLog(@"%@",[userInfo objectForKey:appointmentReason]);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"SetBooking"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"Authkey=%@&UserId=%@&UserName=%@&DoctorId=%@&HospitalId=%@&BookingDate=%@&BookingTime=%@&AppointmentReason=%@&EmailId=%@&MobileNo=%@&Lat=%@&Log=%@&DeviceId=%@&DeviceType=%@&ImageId=%@",authKey,UserId,username,DoctorId,HospitalId,bookingdate,bookingtime,AppointmentReason,emailid,MobileNo,lat,lng,DevId,DeviceType,imgid];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDSetFreeHealthServices:(NSDictionary*)userInfo
{
    
    NSString *UserId            =    [userInfo objectForKey:User_id];
    NSString *gender            =    [userInfo objectForKey:Gender];
    NSString *location          =    [userInfo objectForKey:@"location"];
    NSString *PinNumber         =    [userInfo objectForKey:@"PinNumber"];
    NSString *TypeName          =    [userInfo objectForKey:@"TypeName"];
    NSString *Age               =    [userInfo objectForKey:@"Age"];
    NSString *LabTitleId        =    [userInfo objectForKey:@"LabTitleId"];
    NSString *username          =    [userInfo objectForKey:FullName];
    NSString *AppointmentReason =    [userInfo objectForKey:appointmentReason];
    NSString *emailid           =    [userInfo objectForKey:EmailID];
    NSString *MobileNo          =    [userInfo objectForKey:Mobile];
    NSString *bookingDate       =    [userInfo objectForKey:BookingDate];
    NSString *lat               =   [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlat];
    NSString *lng               =   [NSString stringWithFormat:@"%f",[AppDelegate MyappDelegate].currentlong];
    NSString* DevId             =   [AppDelegate MyappDelegate].vendorId;
    
    NSLog(@"%@",[userInfo objectForKey:appointmentReason]);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"SetFreeHealthServices"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    //    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"UserId=%@&Location=%@&Name=%@&Age=%@&Gender=%@&MobileNumber=%@&Email=%@&TypeName=%@&Lat=%@&Lon=%@&DeviceId=%@&DeviceType=%@&PinNumber=%@&AppoinmentReason=%@&AppoinmentDate=%@&LabTitleId=%@",UserId,location,username,Age,gender,MobileNo,emailid,TypeName,lat,lng,DevId,DeviceType,PinNumber,AppointmentReason,bookingDate,LabTitleId];
    //    NSLog(@"string: %@",postString);
    

    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}




- (NSMutableURLRequest*) docOPDSetEnquiry:(NSDictionary*)userInfo
{
    /*
     AuthKey:
     UserId:
     DoctorId:
     HospitalId:
     UserName:
     UserMobNo:
     UserEmailId:
     SpecialistName:
     ProcedureName:
     UserComment:	
     DeviceId:	
     DeviceType:
     //new add SpecialiseId
     */
    
    NSUserDefaults *userpref = userDefault;
    NSString *authKey           =  [userpref objectForKey:AuthKey];
    NSString *UserId            =    [userInfo objectForKey:User_id];
    NSString *DoctorId          =    [userInfo objectForKey:DoctorID];
    NSString *HospitalId        =    [userInfo objectForKey:HospitalID];
    NSString *username          =    [userInfo objectForKey:FullName];
    NSString *MobileNo          =    [userInfo objectForKey:Mobile];
    NSString *emailid           =    [userInfo objectForKey:EmailID];
    NSString *SpecialistName    =    [userInfo objectForKey:doctorSpec];
    NSString *SpecID            =    [userInfo objectForKey:SpecialityId];
    NSString *ProcedureId       =    [userInfo objectForKey:ProcedureID];
    SpecialistName              = [self ReplaceSpecialCharacter:SpecialistName];
    NSString *ProcedureName     =    [userInfo objectForKey:procedureName];
    ProcedureName               = [self ReplaceSpecialCharacter:ProcedureName];
    NSString *UserComment       =    [userInfo objectForKey:userComment];
    UserComment                 = [self ReplaceSpecialCharacter:UserComment];
    NSString* DevId             =   [AppDelegate MyappDelegate].vendorId;

    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"SetOpenEnquiry"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"AuthKey=%@&UserId=%@&DoctorId=%@&HospitalId=%@&UserName=%@&UserMobNo=%@&UserEmailId=%@&SpecialistName=%@&ProcedureName=%@&UserComment=%@&DeviceId=%@&DeviceType=%@&SpecialiseId=%@&ProcedureId=%@",authKey,UserId,DoctorId?DoctorId:@"",HospitalId?HospitalId:@"",username?username:@"",MobileNo?MobileNo:@"",emailid?emailid:@"",SpecialistName?SpecialistName:@"",ProcedureName?ProcedureName:@"",UserComment?UserComment:@"",DevId,DeviceType,SpecID?SpecID:@"",ProcedureId?ProcedureId:@""];
    
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDUpdateUserProfile:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *authKey=  [userpref objectForKey:AuthKey];
    NSString *mobile=    [userInfo objectForKey:Mobile];
    NSString *email = [userInfo objectForKey:EmailID];
    NSString *username = [userInfo objectForKey:Username];
    NSString *gender = [userInfo objectForKey:Gender];

    username = [self ReplaceSpecialCharacter:username];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"UpdateUserProfile"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"auth=%@&MobileNumber=%@&email=%@&Username=%@&DateOfBirth=&Gender=%@",authKey,mobile,email,username,gender];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSMutableURLRequest*) docOPDUploadUserImage:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *UserId=  [userpref objectForKey:User_id];
    NSString *authKey=    [userpref objectForKey:AuthKey];
    NSString *UploadImage = [userInfo objectForKey:base64];
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"UploadUserImage"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"UserId=%@&AuthKey=%@&UploadImage=%@",UserId,authKey,UploadImage];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSMutableURLRequest*) docOPDGetBookingAndEnquiryHistory:(NSDictionary*)userInfo
{
    NSUserDefaults *userpref = userDefault;
    NSString *UserId=  [userpref objectForKey:User_id];
 
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetBookingAndEnquiryHistory"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"UserId=%@&Authkey=%@",UserId,[userpref objectForKey:AuthKey]];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDGetSearchList:(NSDictionary*)userInfo
{
    NSString *authKey=    [userInfo objectForKey:AuthKey];
    NSString *search = [userInfo objectForKey:@"search"];
    search = [self ReplaceSpecialCharacter:search];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetSearchList"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"AuthKey=%@&Search=%@",authKey,search];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDCancelBooking:(NSDictionary*)userInfo
{
    NSString *authKey=    [userInfo objectForKey:AuthKey];
    NSString *bookId = [userInfo objectForKey:BookingID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"CancelBooking"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"AuthKey=%@&BookingId=%@",authKey,bookId];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*) docOPDSetEnquiryReply:(NSDictionary*)userInfo
{
    NSString *authKey=  [userInfo objectForKey:AuthKey];
    NSString *enqid =  [userInfo objectForKey:EnquiryID];
    NSString *replyContent =  [userInfo objectForKey:userComment];
    replyContent = [self ReplaceSpecialCharacter:replyContent];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"SetEnquiryReply"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"AuthKey=%@&EnquiryId=%@&Reply=%@",authKey,enqid,replyContent];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}
- (NSMutableURLRequest*) docOPDUploadMedicalReport:(NSDictionary*)userInfo
{
    NSString *userid=  [userInfo objectForKey:User_id];
    NSString *album =  [userInfo objectForKey:FolderName];
    NSString *uploadimg =  [userInfo objectForKey:base64];
    NSString *ImageName =  [userInfo objectForKey:ImgName];
    NSString *RType =  [userInfo objectForKey:ReportType];
    NSString *imgTag = [userInfo objectForKey:ImgCaption];
    if ([RType isEqualToString:@"Priscription"]) {
        RType =@"Precription";   
    }
    RType= [NSString stringWithFormat:@"Medical%@",RType];
    

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"UploadMedicalReport"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"UserId=%@&UploadImage=%@&ImageName=%@&ReportType=%@&ImageTag=%@&AlbumName=%@",userid?userid:@"",uploadimg?uploadimg:@"",ImageName?ImageName:@"",RType?RType:@"",imgTag,album?album:@""];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSMutableURLRequest*) docOPDGetMedicalRecords:(NSDictionary*)userInfo
{
    NSString *userid=  [userInfo objectForKey:User_id];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc ]initWithURL:[NSURL URLWithString:webUrl@"GetMedicalRecords"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
//    NSLog(@"string: %@",request);
    NSString *postString =  [NSString stringWithFormat:@"UserId=%@",userid?userid:@""];
//    NSLog(@"string: %@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}




-(NSString*)ReplaceSpecialCharacter:(NSString*)string{
    string = [string stringByReplacingOccurrencesOfString:@"&"
                                                         withString:@"%26"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return string;
}

#pragma mark *******************************************************************************************
#pragma mark sendRequestToServer
- (void) sendRequestToServer:(NSDictionary *)userInfo withDataDic:(NSDictionary *)datadic
{
    
    // if Device is not connected with internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView* aAlert = [[UIAlertView alloc] initWithTitle:@"Data Connection Status" message:@"Your Wi-Fi is not working.\nYour Cellular data is not working." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [aAlert show];
         [self.delegate requestError];
        [[AppDelegate MyappDelegate] hideIndicator];
        return;
    }
    
    // Request
    NSMutableURLRequest *request;
    currentRequestType = ((NSNumber*)[userInfo objectForKey:keyRequestType]).intValue;
    switch (currentRequestType)
    {
        case kGetDocList:
            request = [self docOPDGetAllDocList:datadic];
            break;
            
        case kGetHospitalList:
            request = [self docOPDGetHospitalList:datadic];
            break;
            
        case kGetProcedureList:
            request = [self docOPDGetProcedureList:datadic];
            break;
            
        case kSignUpRequest:
            request = [self docOPDSignup:datadic];
            break;
            
        case kLoginRequest:
            request = [self docOPDSignIn:datadic];
            break;
            
        case kUserVerifyRequest:
            request = [self docOPDUserVerify:datadic];
            break;
            
        case kOTPRequest:
            request = [self docOPDPwdResetOTP:datadic];
            break;
    
        case kOTPVerify:
            request = [self docOPDVerifyOTP:datadic];
            break;
          
        case kResetPassword:
            request = [self docOPDResetPassword:datadic];
            break;
        
        case kForgetResetPassword:
            request = [self docOPDForgetResetPassword:datadic];
            break;
            
            
        case kGetDoctorListByDoctorName:
            request = [self docOPDGetDoctorListByDoctorName:datadic];
            break;
        
        case kGetHospitalByHosName:
            request = [self docOPDGetHospitalByHosName:datadic];
            break;
         
        case kHospitalProfile:
            request = [self docOPDHospitalProfile:datadic];
            break;
            
        case kGetSpecialistList:
            request = [self docOPDGetSpecialistList:datadic];
            break;
            
        case kGetProcedureListByProcedureId:
            request = [self docOPDGetProcedureListByProcedureId:datadic];
            break;
         
        case kDoctorProfile:
            request = [self docOPDDoctorProfile:datadic];
            break;
            
        case kGetDoctorBySpecialist:
            request = [self docOPDGetDoctorBySpecialist:datadic];
            break;
        case ksetImageBooking:
            request =[self docOPDsetImageBooking:datadic];
            break;
   
        case kSetBooking:
            request = [self docOPDSetBooking:datadic];
            break;
            
        case kSetEnquiry:
            request = [self docOPDSetEnquiry:datadic];
            break;
         
        case kUpdateUserProfile:
            request = [self docOPDUpdateUserProfile:datadic];
            break;
            
        case kUploadUserImage:
            request = [self docOPDUploadUserImage:datadic];
            break;
            
        case kGetBookingAndEnquiryHistory:
            request = [self docOPDGetBookingAndEnquiryHistory:datadic];
            break;
            
        case kGetSearchList:
            request = [self docOPDGetSearchList:datadic];
            break;
            
        case kCancelBooking:
            request = [self docOPDCancelBooking:datadic];
            break;
            
        case kSetEnquiryReply:
            request = [self docOPDSetEnquiryReply:datadic];
            break;
            
        case kUploadMedicalReport:
            request = [self docOPDUploadMedicalReport:datadic];
            break;
       
        case kGetMedicalRecords:
            request = [self docOPDGetMedicalRecords:datadic];
            break;
            
        case kUploadEnquiryImage:
            request=[self docOPDUploadEnquiryImage:datadic];
            break;
        case kGetDoctorByNormalSpecialist:
            request=[self docOPDGetDoctorByNormalSpecialist:datadic];
            break;
        case kSetFreeHealthServices:
            request=[self docOPDSetFreeHealthServices:datadic];
            break;
        case kSetServiceImage:
            request=[self docOPDSetServiceImage:datadic];
            break;
            //SetServiceImage
        default:
//            NSLog(@"currentRequestType not found");
            [[AppDelegate MyappDelegate] hideIndicator];
            break;
    }
    
//    NSURLConnection* theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (self.connection)
    {
        receivedData=[[NSMutableData alloc]init];
    }
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [receivedData appendData:data];
}



- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)connError
{
    
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:AppName@" Requires an Active Internet Connection to Get You Information"message:@"Could Not Connect to docOPD Service.\nPlease Try Again Later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
//    NSLog(@"Error: %@", connError);
    [self.delegate requestError];
}


- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    
    
   // NSString *string = [[NSString alloc] initWithData: receivedData encoding: NSUTF8StringEncoding];
    
    
        //parse out the json data
//        NSError* error;
//        NSDictionary* json = [NSJSONSerialization
//                              JSONObjectWithData:receivedData //1
//                              
//                              options:kNilOptions
//                              error:&error];
//    
    
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:receivedData //1
                          
                          options:NSJSONReadingMutableContainers
                          error:&error];
    
    
    
//        NSArray* latestLoans = [json objectForKey:@"loans"]; //2
//        
//        NSLog(@"loans: %@", latestLoans); //3
    
    
    
//    SBJsonParser *obj = [[SBJsonParser alloc] init];
//    NSDictionary *jsonDic =  [obj objectWithString:string];
    [self.delegate requestFinished:json];
}



-(NSMutableArray*)getResults
{
    return daataArray;
}


-(NSString *)replcaeSpecialCharacterFromString:(NSString *)originalStr
{
    NSString *str=[originalStr stringByReplacingOccurrencesOfString:@"-" withString:@"\\u002D"];
    return str;
}

@end

