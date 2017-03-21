//
//  HostoryTableViewCell.m
//  docOPD
//
//  Created by Virinchi Software on 11/21/15.
//  Copyright © 2015 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "HostoryTableViewCell.h"

@implementation HostoryTableViewCell
//@synthesize requiredCellHeight;
- (void)awakeFromNib {
    // Initialization code
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    CGSize maxSize = CGSizeMake(220.0f, CGFLOAT_MAX);
//    CGSize requiredSize = [self.LblDocName sizeThatFits:maxSize];
//    
//    self.LblDocName.frame = CGRectMake(self.LblDocName.frame.origin.x, self.LblDocName.frame.origin.y, requiredSize.width, requiredSize.height);
//    
//    requiredSize = [self.LblDocDegree sizeThatFits:maxSize];
//    self.LblDocDegree.frame = CGRectMake(self.LblDocDegree.frame.origin.x, self.LblDocDegree.frame.origin.y, requiredSize.width, requiredSize.height);
//    
//    requiredSize = [self.LblAppointmentStatic sizeThatFits:maxSize];
//    self.LblAppointmentStatic.frame = CGRectMake(self.LblAppointmentStatic.frame.origin.x, self.LblAppointmentStatic.frame.origin.y, requiredSize.width, requiredSize.height);
//   
//    requiredSize = [self.LblMeetingInfo sizeThatFits:maxSize];
//    self.LblMeetingInfo.frame = CGRectMake(self.LblMeetingInfo.frame.origin.x, self.LblMeetingInfo.frame.origin.y, requiredSize.width, requiredSize.height);
//    
//    requiredSize = [self.LblStatus sizeThatFits:maxSize];
//    self.LblStatus.frame = CGRectMake(self.LblStatus.frame.origin.x, self.LblStatus.frame.origin.y, requiredSize.width, requiredSize.height);
//    
//    
//    // Reposition labels to handle content height changes
//    
//    CGRect LblMeetingInfoFrame = self.LblMeetingInfo.frame;
//    LblMeetingInfoFrame.origin.y = self.LblAppointmentStatic.frame.origin.y + self.LblAppointmentStatic.frame.size.height + 6.0f;
//    self.LblMeetingInfo.frame = LblMeetingInfoFrame;
//    
//    CGRect LblStatusFrame = self.LblStatus.frame;
//    LblMeetingInfoFrame.origin.y = self.LblMeetingInfo.frame.origin.y + self.LblMeetingInfo.frame.size.height + 6.0f;
//    self.LblStatus.frame = LblStatusFrame;
//    
//    
//    // Calculate cell height
//    
//    requiredCellHeight = 15.0f + 6.0f + 6.0f + 15.0f;
//    
////    requiredCellHeight += self.Title.frame.size.height;
////    requiredCellHeight += self.Subtitle.frame.size.height;
////    requiredCellHeight += self.ContentText.frame.size.height;
//    requiredCellHeight += self.LblStatus.frame.size.height +self.LblStatus.frame.origin.y ;
//}

@end
