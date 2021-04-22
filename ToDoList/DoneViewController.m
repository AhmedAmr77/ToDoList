//
//  DoneViewController.m
//  ToDoList
//
//  Created by Ahmd Amr on 4/5/21.
//  Copyright © 2021 Ahmd Amr. All rights reserved.
//

#import "DoneViewController.h"

@interface DoneViewController (){
    
    //    NSMutableArray *devices;
        NSMutableArray *filteredTasks;
        BOOL isFiltered;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSString *path;
@property NSMutableArray *arr;

@property UISearchBar *searchBar;

@property BOOL isSorted;
@property NSMutableArray *hiPriorArr;
@property NSMutableArray *midPriorArr;
@property NSMutableArray *lowPriorArr;

@property NSMutableArray *originalAr;


@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

   _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0., 0., 320., 44.)];
   self.tableView.tableHeaderView = _searchBar;
   
    _isSorted = NO;
    
   isFiltered = false;
   _searchBar.delegate = self;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [path objectAtIndex:0];
    NSString *filePath = [documentFolder stringByAppendingFormat:@"TaskPList.plist"];
    
    // load data in array
    [self reloadTableView];
    
}

- (IBAction)addTaskBtnPressed:(id)sender { //sort BTN
    _isSorted = !_isSorted;
    [self reloadTableView];
}

- (void)reloadTableView{
    printf("reload");
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [path objectAtIndex:0];
    NSString *filePath = [documentFolder stringByAppendingFormat:@"TaskPList.plist"];
    
    // load data in array
    _originalAr = [NSArray arrayWithContentsOfFile:filePath];
    _hiPriorArr = [NSMutableArray array];
    _midPriorArr = [NSMutableArray array];
    _lowPriorArr = [NSMutableArray array];
    _arr = [NSMutableArray array];
    for (NSDictionary *task in _originalAr) {
        NSString *statusStr = [NSString stringWithFormat: @"%@", [task valueForKey:@"status"]];
        if([statusStr intValue] == 2){
            [_arr addObject:task];
            NSString *priorStr = [NSString stringWithFormat: @"%@", [task valueForKey:@"priority"]];
            switch ([priorStr intValue]) {
                case 0:
                    [_hiPriorArr addObject:task];
                   break;
                case 1:
                    [_midPriorArr addObject:task];
                   break;
                case 2:
                    [_lowPriorArr addObject:task];
                   break;
                default:
                    break;
            }
        }
    }
    _tableView.reloadData;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isSorted == YES) {
        return 3;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFiltered) {
        return filteredTasks.count;
    }else if (_isSorted == YES) {
        NSInteger *numOfRows = 0;
        switch (section) {
            case 0:
                numOfRows = [_hiPriorArr count];
                break;
            case 1:
                numOfRows = [_midPriorArr count];
                break;
            case 2:
                numOfRows = [_lowPriorArr count];
                break;
            default:
                break;
        }
        return numOfRows;
    }
    return [_arr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoneCell" forIndexPath:indexPath];
    
    // Configure the cell...
    UIImageView *img = [cell viewWithTag:1];
    UILabel *lbl = [cell viewWithTag:2];
    
    NSDictionary *dict = [NSDictionary dictionary];
    if (isFiltered) {
        printf("\nfilteredInProgress\n");
        dict = [filteredTasks objectAtIndex:indexPath.row];
        NSString *priorStr = [NSString stringWithFormat: @"%@", [dict valueForKey:@"priority"]];
        switch ([priorStr intValue]) {
            case 0:
                img.image = [UIImage imageNamed:@"red.png"];
                break;
            case 1:
                img.image = [UIImage imageNamed:@"orange.png"];
                break;
            case 2:
                img.image = [UIImage imageNamed:@"blue.png"];
                break;
            default:
                break;
        }
    } else {
        if(_isSorted == YES){
            switch (indexPath.section) { //by Section for sort
                case 0:
                    dict = [_hiPriorArr objectAtIndex:indexPath.row];
                    img.image = [UIImage imageNamed:@"red.png"];
                    break;
                case 1:
                    dict = [_midPriorArr objectAtIndex:indexPath.row];
                    img.image = [UIImage imageNamed:@"orange.png"];
                    break;
                case 2:
                    dict = [_lowPriorArr objectAtIndex:indexPath.row];
                    img.image = [UIImage imageNamed:@"blue.png"];
                    break;
                default:
                    break;
            }
        } else {
            dict = [_arr objectAtIndex:indexPath.row];
            NSString *priorStr = [NSString stringWithFormat: @"%@", [dict valueForKey:@"priority"]];
            switch ([priorStr intValue]) {  //without sort
                case 0:
                   img.image = [UIImage imageNamed:@"red.png"];
                   break;
                case 1:
                   img.image = [UIImage imageNamed:@"orange.png"];
                   break;
                case 2:
                   img.image = [UIImage imageNamed:@"blue.png"];
                   break;
                default:
                    break;
            }
        }
    }
    NSString *nameStr = [NSString stringWithFormat: @"%@", [dict valueForKey:@"name"]];
    lbl.text = nameStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (isFiltered) {
            printf("\ndeletedTrue\n");
            for (int i=0; i<[_arr count];i++) {
                NSDictionary *task = [_originalAr objectAtIndex:i];
                NSString *nameStrOriginal = [NSString stringWithFormat: @"%@", [task valueForKey:@"name"]];
                NSString *nameStrFilter = [NSString stringWithFormat: @"%@", [filteredTasks[indexPath.row] valueForKey:@"name"]];
                if (nameStrFilter == nameStrOriginal) {
                    [_originalAr removeObjectAtIndex:i];
                }
            }
        } else {
            printf("\ndeletedFalse\n");
            NSDictionary *selectedTask = [_arr objectAtIndex:indexPath.row];
            for (int i=0; i<[_originalAr count];i++) {
                NSDictionary *task = [_originalAr objectAtIndex:i];
                NSString *nameStrOriginal = [NSString stringWithFormat: @"%@", [task valueForKey:@"name"]];
                NSString *nameStrSorted = [NSString stringWithFormat: @"%@", [selectedTask valueForKey:@"name"]];
                if (nameStrSorted == nameStrOriginal) {
                    [_originalAr removeObjectAtIndex:i];
                }
            }
        }
        
        NSArray *pathhh = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentFolder = [pathhh objectAtIndex:0];
        NSString *filePath = [documentFolder stringByAppendingFormat:@"TaskPList.plist"];
        
        [_originalAr writeToFile:filePath atomically:YES];

        [self reloadTableView];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *titleName = @"";
    if(_isSorted == YES){
        switch (section) {
            case 0:
                titleName = @"High";
                break;
            case 1:
                titleName = @"Mid";
                break;
            case 2:
                titleName = @"Low";
                break;
            default:
                break;
        }
    }
    return titleName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskViewController *taskViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskViewController"];
    
    if (isFiltered) {
        printf("\nTrue\n");
        for (int i=0; i<[_arr count];i++) {
            NSDictionary *task = [_arr objectAtIndex:i];
            NSString *nameStrOriginal = [NSString stringWithFormat: @"%@", [task valueForKey:@"name"]];
            NSString *nameStrFilter = [NSString stringWithFormat: @"%@", [filteredTasks[indexPath.row] valueForKey:@"name"]];
            if (nameStrFilter == nameStrOriginal) {
                [taskViewController setTaskDictBox: _arr[i]];
                [taskViewController setEditedIndex:i];
            }
        }
    } else {
        for (int i=0; i<[_originalAr count];i++) {
            NSDictionary *task = [_originalAr objectAtIndex:i];
            NSString *nameStrOriginal = [NSString stringWithFormat: @"%@", [task valueForKey:@"name"]];
            NSString *nameStrSelected = [NSString stringWithFormat: @"%@", [_arr[indexPath.row] valueForKey:@"name"]];
            if (nameStrSelected == nameStrOriginal) {
                [taskViewController setTaskDictBox: _originalAr[i]];
                [taskViewController setEditedIndex: i];
            }
        }
    }
    [self.navigationController pushViewController:taskViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y += CGRectGetHeight(self.tableView.tableHeaderView.frame);
    self.tableView.contentOffset = contentOffset;
}

- (void)viewDidAppear:(BOOL)animated{
    [self reloadTableView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        isFiltered = false;
        [_searchBar endEditing:YES];
    } else {
        isFiltered = true;
        filteredTasks = [[NSMutableArray alloc]init];
        for (NSDictionary *task in _arr) {
            NSString *nameStr = [NSString stringWithFormat: @"%@", [task valueForKey:@"name"]];
            NSRange range = [nameStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [filteredTasks addObject:task];
            }
        }
    }
    [self.tableView reloadData];
}

@end
