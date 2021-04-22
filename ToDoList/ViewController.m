//
//  ViewController.m
//  ToDoList
//
//  Created by Ahmd Amr on 4/2/21.
//  Copyright © 2021 Ahmd Amr. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
  
    NSMutableArray *filteredTasks;
    BOOL isFiltered;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSString *path;
@property NSMutableArray *arr;
@property NSMutableArray *originalAr;

@property UISearchBar *searchBar;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0., 0., 320., 44.)];
    self.tableView.tableHeaderView = _searchBar;
    
    isFiltered = false;
    _searchBar.delegate = self;
    
    [self reloadTableView];
}


- (IBAction)addTaskBtnPressed:(id)sender {
    TaskViewController *taskViCont = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskViewController"];
    [taskViCont setDelegationProtocol:self];
    [taskViCont setIsAdd:YES];
    [[self navigationController] pushViewController:taskViCont animated:YES];
}

- (void)reloadTableView{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [path objectAtIndex:0];
    NSString *filePath = [documentFolder stringByAppendingFormat:@"TaskPList.plist"];
    
    // load data in array
    _originalAr = [NSArray arrayWithContentsOfFile:filePath];
    _arr = [NSMutableArray array];
    for (NSDictionary *task in _originalAr) {
        NSString *statusStr = [NSString stringWithFormat: @"%@", [task valueForKey:@"status"]];
        if([statusStr intValue] == 0){
            [_arr addObject:task];
        }
    }
    _tableView.reloadData;
}

//-----------------TABLE VIEW---------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFiltered) {
        return filteredTasks.count;
    }
    return _arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCell" forIndexPath:indexPath];
    
    // Configure the cell...
    UIImageView *img = [cell viewWithTag:1];
    UILabel *lbl = [cell viewWithTag:2];
    
    NSDictionary *dict = [NSDictionary dictionary];
    if (isFiltered) {
        dict = [filteredTasks objectAtIndex:indexPath.row];
    } else {
        dict = [_arr objectAtIndex:indexPath.row];
    }
    NSString *nameStr = [NSString stringWithFormat: @"%@", [dict valueForKey:@"name"]];
    lbl.text = nameStr;
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskViewController *taskViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskViewController"];
    
    if (isFiltered) {
        printf("\nTrue\n");
        for (int i=0; i<[_originalAr count];i++) {
            NSDictionary *task = [_originalAr objectAtIndex:i];
            NSString *nameStrOriginal = [NSString stringWithFormat: @"%@", [task valueForKey:@"name"]];
            NSString *nameStrFilter = [NSString stringWithFormat: @"%@", [filteredTasks[indexPath.row] valueForKey:@"name"]];
            if (nameStrFilter == nameStrOriginal) {
                [taskViewController setTaskDictBox: _originalAr[i]];
                [taskViewController setEditedIndex: i];
            }
        }
    } else {
        printf("\nselectedFalse\n");
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (isFiltered) {
            printf("\ndeletedTrue\n");
            for (int i=0; i<[_arr count];i++) {
                NSDictionary *task = [_arr objectAtIndex:i];
                NSString *nameStrOriginal = [NSString stringWithFormat: @"%@", [task valueForKey:@"name"]];
                NSString *nameStrFilter = [NSString stringWithFormat: @"%@", [filteredTasks[indexPath.row] valueForKey:@"name"]];
                if (nameStrFilter == nameStrOriginal) {
                    [_arr removeObjectAtIndex:i];
                }
            }
        } else {
            printf("\ndeletedFalse\n");
            [_arr removeObjectAtIndex:indexPath.row];
        }
        [_tableView reloadData];
        
        NSArray *pathhh = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentFolder = [pathhh objectAtIndex:0];
        NSString *filePath = [documentFolder stringByAppendingFormat:@"TaskPList.plist"];
        
        [_arr writeToFile:filePath atomically:YES];
    }
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
