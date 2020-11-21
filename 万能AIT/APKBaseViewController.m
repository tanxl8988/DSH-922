//
//  APKBaseViewController.m
//  保时捷项目
//
//  Created by Mac on 16/4/21.
//
//

#import "APKBaseViewController.h"
#import "APKDVRFile.h"

@interface APKBaseViewController ()

@end

@implementation APKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}


-(NSArray *)sortDVRFileWithFileDateAndFOrR:(NSArray*)SourceArr
{
    
    if (SourceArr.count == 0) {
        return nil;
    }
    
    NSArray *timeSortArr = [self sortFileWithdate:SourceArr];
    
    NSMutableArray *nameSortArr = [self changeFAndRFile:timeSortArr];
    
    NSArray *sortArr = [NSArray arrayWithArray:nameSortArr];
    
    return sortArr;
}


-(NSArray *)sortFileWithdate:(NSArray *)fileArr
{
    NSArray *sortArr = [fileArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        APKDVRFile *file1 = obj1;
        APKDVRFile *file2 = obj2;
        return [file2.fullStyleDate compare:file1.fullStyleDate];
    }];
    
    return sortArr;
}

-(NSMutableArray *)changeFAndRFile:(NSArray *)sortArr
{
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:sortArr];
    
    for (int i = 0;i < sortArr.count - 1; i++) {
        APKDVRFile *file1 = arr[i];
        APKDVRFile *file2 = arr[i + 1];
        
        int sameTime = [self compareOneDay:file1.fullStyleDate withAnotherDay:file2.fullStyleDate];
        if (sameTime == 1 && [file2.name containsString:@"F."]) {
            
            [arr replaceObjectAtIndex:i withObject:file2];
            [arr replaceObjectAtIndex:i+1 withObject:file1];
            
        }
    }
    return arr;
}

-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSComparisonResult result = [oneDay compare:anotherDay];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedSame) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

@end
