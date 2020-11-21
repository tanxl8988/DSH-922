//
//  APKGetDVRFileListResponseObjectHandler.m
//  Aigo
//
//  Created by Mac on 17/7/5.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKGetDVRFileListResponseObjectHandler.h"

@interface APKGetDVRFileListResponseObjectHandler ()<NSXMLParserDelegate>

@property (copy,nonatomic) APKSuccessCommandHandler successCommandHandler;
@property (copy,nonatomic) APKFailureCommandHandler failureCommandHandler;
@property (strong,nonatomic) NSMutableArray *fileArray;
@property (strong,nonatomic) NSString *element;
@property (strong,nonatomic) APKDVRFile *file;
@property (strong,nonatomic) NSDateFormatter *dateFormat;
@property (strong,nonatomic) NSDateFormatter *timeFormat;
@property (strong,nonatomic) NSDateFormatter *shortDateFormat;
@property (strong,nonatomic) NSDateFormatter *fullDateFormat;

@end

@implementation APKGetDVRFileListResponseObjectHandler

- (void)handle:(id)responseObject successCommandHandler:(APKSuccessCommandHandler)successCommandHandler failureCommandHandler:(APKFailureCommandHandler)failureCommandHandler{
    
    self.successCommandHandler = successCommandHandler;
    self.failureCommandHandler = failureCommandHandler;
    
    NSData *data = responseObject;
    
    NSString *info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",info);
    
    NSXMLParser *xml = [[NSXMLParser alloc] initWithData:data];
    xml.delegate = self;
    [xml parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //    NSLog(@"%s",__func__);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    //    NSLog(@"%s",__func__);
    self.successCommandHandler(self.fileArray);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
    self.element = elementName;
    
    if ([elementName isEqualToString:@"file"]) {
        
        self.file = [[APKDVRFile alloc] init];
        self.file.type = self.fileType;
        
    }else if ([elementName isEqualToString:@"format"]){
        
        int time = [attributeDict[@"time"] intValue];
        int minute = time / 60;
        int second = time % 60;
        self.file.duration = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if ([self.element isEqualToString:@"name"]) {
        [self loadFileInfoWithOriginName:string];
    }else if ([self.element isEqualToString:@"format"]){
        self.file.format = string;
    }else if ([self.element isEqualToString:@"size"]){
        self.file.size = [self sizeWithString:string];
    }else if ([self.element isEqualToString:@"attr"]){
        self.file.isLocked = ![string isEqualToString:@"RW"];
    }else if ([self.element isEqualToString:@"time"]){
        self.file.fullStyleDate = [self.fullDateFormat dateFromString:string];
        NSString *shortDateString = [string componentsSeparatedByString:@" "].firstObject;
        self.file.shortStyleDate = [self.shortDateFormat dateFromString:shortDateString];
        self.file.time = [self.timeFormat stringFromDate:self.file.fullStyleDate];
        self.file.date = [self.shortDateFormat stringFromDate:self.file.shortStyleDate];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
    self.element = nil;
    if ([elementName isEqualToString:@"file"]) {
        [self.fileArray addObject:self.file];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    
    self.failureCommandHandler(-1);
}

#pragma mark - Utilities

- (NSString *)sizeWithString:(NSString *)string{
    
    int sizeCount = [string intValue];
    NSString *sizeString = @"0" ;
    if (sizeCount < 1024) {
        sizeString = [NSString stringWithFormat:@"%u", sizeCount] ;
    } else {
        sizeCount /= 1024 ;
        if (sizeCount < 1024) {
            sizeString = [NSString stringWithFormat:@"%uK", sizeCount] ;
        } else {
            sizeCount /= 1024 ;
            sizeString = [NSString stringWithFormat:@"%uM", sizeCount] ;
        }
    }
    return sizeString;
}

- (void)loadFileInfoWithOriginName:(NSString *)originName{// /SD/Normal/FILE170101-012105F.MOV
    
    originName = [originName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    //origin name
    self.file.originalName = originName;
    
    //file name
    self.file.name = [originName lastPathComponent];
    
    //file download path
    self.file.fileDownloadPath = [NSString stringWithFormat:@"http://192.72.1.1%@",originName];
    
    self.file.isFrontCamera = [self.file.name containsString:@"_F"] ? YES : NO;// new add
    
    //thumbnail download path
    NSString *thumbnailSubPath = [originName componentsSeparatedByString:@"SD/"].lastObject;
    self.file.thumbnailDownloadPath = [NSString stringWithFormat:@"http://192.72.1.1/thumb/%@",thumbnailSubPath];
}

#pragma mark - getter

- (NSDateFormatter *)timeFormat{
    
    if (!_timeFormat) {
        
        _timeFormat = [[NSDateFormatter alloc] init];
        [_timeFormat setDateFormat:@"HH:mm:ss"];
        [_timeFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    return _timeFormat;
}

- (NSDateFormatter *)shortDateFormat{
    
    if (!_shortDateFormat) {
        
        _shortDateFormat = [[NSDateFormatter alloc] init];
        [_shortDateFormat setDateFormat:@"yyyy-MM-dd"];
        [_shortDateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    return _shortDateFormat;
}

- (NSDateFormatter *)fullDateFormat{
    
    if (!_fullDateFormat) {
        
        _fullDateFormat = [[NSDateFormatter alloc] init];
        [_fullDateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [_fullDateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    return _fullDateFormat;
}

- (NSMutableArray *)fileArray{
    
    if (!_fileArray) {
        
        _fileArray = [[NSMutableArray alloc] init];
    }
    
    return _fileArray;
}

@end
