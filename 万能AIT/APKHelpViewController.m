//
//  APKHelpViewController.m
//  YunZhiHui2
//
//  Created by Cong's Jobs on 15/12/3.
//  Copyright © 2015年 Apical. All rights reserved.
//

#import "APKHelpViewController.h"
#import "APKHelpAnswerCell.h"
#import "APKHelpQuestionCell.h"

#define QUESTION @"question"
#define ANSWER @"answer"

@interface APKHelpViewController ()

@property (strong,nonatomic) NSMutableArray *dataSource;

@end

@implementation APKHelpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"帮助", nil);
    
   NSArray *helpDataArray = @[
                            @{@"question":@"问题1",@"answer":@"答案1"},
                            @{@"question":@"问题2",@"answer":@"答案2"},
                            @{@"question":@"问题3",@"answer":@"答案3"},
                            @{@"question":@"问题4",@"answer":@"答案4"},
                            @{@"question":@"问题5",@"answer":@"答案5"},
                            @{@"question":@"问题6",@"answer":@"答案6"},
                            @{@"question":@"问题7",@"answer":@"答案7"},
                            @{@"question":@"问题8",@"answer":@"答案8"}
                            ];
    
    [self.dataSource setArray:helpDataArray];
}

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    APKHelpAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
    NSDictionary *help = self.dataSource[indexPath.section];
    cell.answerLabel.text = NSLocalizedString(help[ANSWER], nil);
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *help = self.dataSource[indexPath.section];
    NSString *key = NSLocalizedString(help[ANSWER], nil);
    CGFloat keyLabelWidth = CGRectGetWidth(self.view.frame) - 16 - 8;
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]};
    CGRect descriptionLabelRect = [key boundingRectWithSize:CGSizeMake(keyLabelWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    
    return descriptionLabelRect.size.height + 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    APKHelpQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    NSDictionary *help = self.dataSource[section];
    cell.questionLabel.text = NSLocalizedString(help[QUESTION], nil);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSDictionary *help = self.dataSource[section];
    NSString *question = NSLocalizedString(help[QUESTION], nil);
    CGFloat questionLabelWidth = CGRectGetWidth(self.view.frame) - 16 - 8;
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]};
    CGRect descriptionLabelRect = [question boundingRectWithSize:CGSizeMake(questionLabelWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    
    return descriptionLabelRect.size.height + 16;
}

@end










