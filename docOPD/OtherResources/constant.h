//
//  constant.h
//  docOPD
//
//  Created by Ashutosh Kumar on 7/31/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#ifndef docOPD_constant_h
#define docOPD_constant_h
typedef enum TheRequestTypes
{
    kGetDocList =1,
    kGetHospitalList,
    kGetProcedureList,
    kSignUpRequest,                                                     //Get Sign In request
    kLoginRequest,
    kUserVerifyRequest,
    kOTPRequest,
    kOTPVerify,
    kResetPassword,
    kGetDoctorListByDoctorName,
    kGetHospitalByHosName,
    kHospitalProfile,
    kGetSpecialistList,
    kGetProcedureListByProcedureId,
    kDoctorProfile,
    kGetDoctorBySpecialist,
    ksetImageBooking,
    kSetBooking,
    kSetEnquiry,
    kSetEnquiryReply,
    kUpdateUserProfile,
    kUploadUserImage,
    kGetBookingAndEnquiryHistory,
    kGetSearchList,
    kCancelBooking,
    kForgetResetPassword,
    kUploadMedicalReport,
    kGetMedicalRecords,
    kUploadEnquiryImage,
    kGetDoctorByNormalSpecialist,
    kSetFreeHealthServices,
    kSetServiceImage,
}ServerRequestType;

#define AppName @"docOPD"
#define webUrl @"http://services.docopd.com/docOPDservices.asmx/"
#define serverUrl @"http://www.docopd.com/"
#define userDefault [NSUserDefaults standardUserDefaults]
#define NA @"NA"
#define FullName @"Fullname"
#define UserDOB @"UserDOB"
#define Mobile @"mobile"
#define User_id @"userid"
#define Gender @"Gender"
#define DoctorID @"doctorID"
#define EmailID @"email"
#define Password @"password"
#define OldPassword @"OldPassword"
#define Verificationcode @"verificationcode"
#define DeviceToken @"devicetoken"
#define DeviceType @"ios"
#define Format @"json"
#define keyRequestType @"RequestType"
#define AuthKey @"auth_key"
#define ReferenceCode @"ReferenceCode"
#define ContactSupport @"ContactSupport"
#define FolderID @"FolderID"
#define FolderName @"FolderName"
#define Username @"username"
#define isLogin @"isLogin"
#define usertype @"user"
#define defaultAuthKey @"12345678"
#define fName @"FirstName"
#define HospitalName @"HospitalName"
#define HospitalID @"Hospital_ID"
#define mName @"MiddleName"
#define lName @"LastName"
#define PageIndex @"PageIndex"
#define DeviceID @"DeviceID"
#define ProcedureID @"ProcedureID"
#define EnquiryID @"EnquiryID"
#define BookingID @"BookingID"
#define BookingDate @"BookingDate"
#define BookingTime @"BookingTime"
#define appointmentReason @"AppointmentReason"
#define base64 @"base64"
#define Booking_Id @"Booking Id"
#define ImgName @"imagename"
#define EnquiryId @"EnquiryId"
#define imgIDS @"imageid"
#define doctorSpec @"docSpec"
#define userComment @"comment"
#define SpecialityId @"SpecialiseId"
#define procedureName @"procedureName"
#define userProfileImgUrl @"userImgUrl"
#define ReportType @"ReportType"
#define ImgCaption @"ImageCaption"
#define medicalImgID @"medicalimageid"
#define isAllImgdownload @"isAllImgdownload"
#endif
