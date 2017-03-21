//
//  docOPDNetworkEngine.h
//  docOPD
//
//  Created by Virinchi Software on 22/09/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface docOPDNetworkEngine : NSObject<NSURLConnectionDelegate, NSXMLParserDelegate,UIAlertViewDelegate>{
    NSURLConnection *connection;
    NSMutableData *responseData;
    NSMutableDictionary *model;
    
}
@property BOOL syncOn;

@property (strong, nonatomic) UIAlertView *alertView;
@property (nonatomic, copy) void (^ callbackBlock)(NSDictionary *response);
@property (nonatomic, strong) NSDictionary *MedicatReportData;
@property BOOL medicalRecordsByDateFlag;
@property (nonatomic, strong) NSString *lastSyncTime;
@property (nonatomic, strong) NSString *lastSyncTimeDateForAPI;
@property (nonatomic, strong) NSString *titleName;

@property BOOL removeLoadFlag;
@property (nonatomic, strong) NSMutableArray *familyArrayData;
@property (nonatomic, strong) NSString *SpecializationName;
@property (nonatomic, strong) NSString *SpecializationID;

@property BOOL familyDataActive;




+ (docOPDNetworkEngine *)sharedInstance;

-(void) SetAlbumSharingAPI:(NSString *) UserId AlbumId:(NSString*)AlbumId MobileNumber:(NSString*)MobileNumber  EmailId:(NSString*)EmailId withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) SetMultipalImageSharingAPI:(NSString *) UserId ImageId:(NSString*)ImageId MobileNumber:(NSString*)MobileNumber  EmailId:(NSString*)EmailId withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) DeleteMultipleAlbumAPI:(NSString *) AlbumId  withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) DeleteMultipleImageAPI:(NSString *) AlbumId  withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) RemoveAlbumSharingAPI:(NSString *) MobileNumber  AlbumId:(NSString *)AlbumId withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) GetMedicalRecordsByDateAPI:(NSString *)UserId  date:(NSString *)date withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) GetMedicalImageTypeAPI: (void(^) (NSDictionary* responseData)) callback;

-(void) UpdateImageTypeAPI:(NSString *)Id withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) GetSpecialistListAPI:(NSString *)Authkey withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) SetUserRelationAPI:(NSString *)FirstName  LastName:(NSString *)LastName EmailId:(NSString *)EmailId MobileNumber:(NSString *)MobileNumber Relation:(NSString *)Relation UserId:(NSString *)UserId Lat:(NSString *)Lat Lon:(NSString *)Lon DeviceId:(NSString *)DeviceId gender:(NSString*)gender DOB:(NSString*)DOB   withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) UpdateUserRelationAPI:(NSString *)FirstName  LastName:(NSString *)LastName EmailId:(NSString *)EmailId MobileNumber:(NSString *)MobileNumber Relation:(NSString *)Relation UserId:(NSString *)UserId Lat:(NSString *)Lat Lon:(NSString *)Lon DeviceId:(NSString *)DeviceId gender:(NSString*)gender DOB:(NSString*)DOB RelationId:(NSString*)RelationId  withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) GetRelationAPI:(NSString *)UserId withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) UploadUserImageByMobileNumberAPI:(NSString *)MobileNumber   UploadImage:(NSString *)UploadImage withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) RemoveRelationAPI:(NSString *)RelationId  UserId:(NSString *)UserId   withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) SetUserReferenceAPI:(NSString *)UserId  referenceCode:(NSString *)referenceCode   withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) FreeHealthTitleWithFreeStatusAPI:(NSString *)UserId    withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) GetReferenceCodeByUserIdAPI:(NSString *)UserId    withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) GetLabTitleAPI:(NSString *)Authkey    withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) ReSendUserVerificationAPI:(NSString *)MobileNumber    withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) VerifyUserAPI:(NSString *)VerificationCode  MobileId:(NSString *)MobileId   withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) SetCallSupportAPI:(NSString *)UserId  TitleName:(NSString *)TitleName   withCallback: (void(^) (NSDictionary* responseData)) callback;

-(void) UpdateCaptionBaseOnImageIdAPI:(NSString *)Caption  ImageId:(NSString *)ImageId   withCallback: (void(^) (NSDictionary* responseData)) callback;


@end
