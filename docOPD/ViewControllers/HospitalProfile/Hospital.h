//
//  Hospital.h
//  docOPD
//
//  Created by Ashutosh Kumar on 8/4/15.
//  Copyright (c) 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hospital : NSObject
@property (nonatomic, strong) NSString *Treatment; // Treatment name of Hospital
@property (nonatomic, strong) NSString *TreatmentImage; // Treatment image filename of Hospital
@property (nonatomic, strong) NSString *DocPost; // Doctor Profile of hospital
@property (nonatomic, strong) NSString *DocName; // Doctor name of Hospital
@property (nonatomic, strong) NSString *DocImage; // Doctor image filename of Hospital
@property (nonatomic, strong) NSString *DocId; // Doctor id filename of Hospital
@property (nonatomic, strong) NSString *DocFee; // Doctor Fee of Hospital
@property (nonatomic, strong) NSString *DocOldFee; // Doctor old fee  of Hospital
@property (nonatomic, strong) NSString *DocAvailibility; // Doctor Availibility of Hospital
@property (nonatomic, strong) NSString *DocAboutdoctor; // Doctor Availibility of Hospital
@property (nonatomic, strong) NSMutableArray *doclistarray;
@end
