//
//  TaskViewController.m
//  ToDoList
//
//  Created by Ahmd Amr on 4/5/21.
//  Copyright © 2021 Ahmd Amr. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskData.h"

@interface TaskViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTxtFld;

@property (weak, nonatomic) IBOutlet UITextField *descTxtFld;

@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmnCntrl;

@property (weak, nonatomic) IBOutlet UIStackView *pickerStackView;
@property (weak, nonatomic) IBOutlet UIDatePicker *reminderPicker;


@property (weak, nonatomic) IBOutlet UIStackView *progressStackView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *progressSgmnCntrl;

@property (weak, nonatomic) IBOutlet UIStackView *creationDateStackView;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLbl;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UIStackView *pickerEditModeStackView;
@property (weak, nonatomic) IBOutlet UILabel *reminderDatePickerEditModeLbl;

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     if (_isAdd == YES){
         printf("\nADD\n");
         [_pickerEditModeStackView setHidden:YES];
         [_progressStackView setHidden:YES];
         [_creationDateStackView setHidden:YES];
     } else {
         printf("\nDetails\n");
         UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(editBtnPressed)];
         [self.navigationItem setRightBarButtonItem:editBtn];
         
         NSString *nameStr = [NSString stringWithFormat: @"%@", [_taskDictBox objectForKey:@"name"]];
         [_nameTxtFld setText:nameStr];
         [_nameTxtFld setEnabled:NO];
         [_nameTxtFld setUserInteractionEnabled:NO];
         
         NSString *descStr = [NSString stringWithFormat: @"%@", [_taskDictBox objectForKey:@"desc"]];
         [_descTxtFld setText:descStr];
         [_descTxtFld setEnabled:NO];
         [_descTxtFld setUserInteractionEnabled:NO];
         
         NSString *priorStr = [NSString stringWithFormat: @"%@", [_taskDictBox objectForKey:@"priority"]];
         [_prioritySegmnCntrl setSelectedSegmentIndex:[priorStr intValue]];
         [_prioritySegmnCntrl setEnabled:NO];
         [_prioritySegmnCntrl setUserInteractionEnabled:NO];
         
         NSString *statusStr = [NSString stringWithFormat: @"%@", [_taskDictBox objectForKey:@"status"]];
         [_progressSgmnCntrl setSelectedSegmentIndex:[statusStr intValue]];
         [_progressSgmnCntrl setEnabled:NO];
         [_progressSgmnCntrl setUserInteractionEnabled:NO];
         
         
         [_pickerStackView setHidden:YES];
         NSString *remindrStr = [NSString stringWithFormat: @"%@", [_taskDictBox objectForKey:@"reminderDate"]];
//         NSLog(@"\n\nNSStringSAVEDPicker: %@\n\n",remindrStr);
         _reminderDatePickerEditModeLbl.text = remindrStr;
         // Convert string to date object
//          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//          [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
////          NSString *dueDateString = [NSString stringWithFormat:@"2014-07-11T15:21:42.207+02:00"];
//          NSDate *dateFromApi = [dateFormatter dateFromString:remindrStr];
//          [dateFormatter setDateFormat:@"yyyy/MM/dd"];
//          NSString *finalDateString = [dateFormatter stringFromDate:dateFromApi];
//          NSLog(@"dueDateString %@", remindrStr);
//          NSLog(@"dateFromApi %@", dateFromApi);
//          NSLog(@"finalDateString%@", finalDateString);
//
//          NSDate *date = [dateFormatter dateFromString:dateFromApi];
         
         
//         NSLog(@"\n\nNSDateSAVEDPicker: %@\n\n",date);
         
//         [_reminderPicker setDate: date];
//         [_reminderPicker setEnabled:NO];
//         [_reminderPicker setUserInteractionEnabled:NO];
         
         [_progressStackView setHidden:YES];
         
         NSString *creationStr = [NSString stringWithFormat: @"%@", [_taskDictBox objectForKey:@"creationDate"]];
         _creationDateLbl.text = creationStr;
         
         [_addBtn setHidden:YES];
         
     }
}

-(void) editBtnPressed{
    
    [_nameTxtFld setEnabled:YES];
    [_nameTxtFld setUserInteractionEnabled:YES];
    
    [_descTxtFld setEnabled:YES];
    [_descTxtFld setUserInteractionEnabled:YES];
    
    [_prioritySegmnCntrl setEnabled:YES];
    [_prioritySegmnCntrl setUserInteractionEnabled:YES];

    [_pickerEditModeStackView setHidden:YES];
    [_pickerStackView setHidden:NO];
    [_reminderPicker setEnabled:YES];
    [_reminderPicker setUserInteractionEnabled:YES];
    
    [_progressStackView setHidden:NO];
    [_progressSgmnCntrl setEnabled:YES];
    [_progressSgmnCntrl setUserInteractionEnabled:YES];
    
    [_addBtn setHidden:NO];
    [_addBtn setTitle:@"Save" forState:UIControlStateNormal];
}

- (IBAction)addBtnPressed:(id)sender {
    
    NSDictionary<NSString *, id> *dataaa;
    
    NSArray *pathhh = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [pathhh objectAtIndex:0];
    NSString *filePath = [documentFolder stringByAppendingFormat:@"TaskPList.plist"];
    
    NSMutableArray *arrr = [NSMutableArray arrayWithContentsOfFile:filePath];

    NSInteger *x = _prioritySegmnCntrl.selectedSegmentIndex;
    NSString *inStr = [NSString stringWithFormat: @"%d", (int)x];
    
    NSInteger *y = _progressSgmnCntrl.selectedSegmentIndex;
    NSString *prStr = [NSString stringWithFormat: @"%d", (int)y];
    
    NSDate *currentDate = [[NSDate alloc] init];
    
    dataaa = @{ @"name" : _nameTxtFld.text, @"desc" : _descTxtFld.text, @"priority" : inStr, @"status" : prStr, @"reminderDate" : _reminderPicker.date, @"creationDate" : currentDate };
    
//    NSLog(@"\nNSDatePicker: %@\n",_reminderPicker.date);

    if (_isAdd == YES){
         [arrr addObject:dataaa];
     } else {
         [arrr replaceObjectAtIndex:_editedIndex withObject:dataaa];
     }
    
    [arrr writeToFile:filePath atomically:YES];
    [self setNotification:_nameTxtFld.text];
    [_delegationProtocol reloadTableView];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) setNotification: (NSString*) taskName {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    //[calendar setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone fromDate:_reminderPicker.date];

//    NSLog(@"picker Notifyy %@", _reminderPicker.date);

    UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
    objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"To Do!" arguments:nil];
    NSMutableString *msg = [[NSMutableString alloc] initWithString:@"Do NOT forget to do :  "];
    [msg appendString:taskName];
    objNotificationContent.body = [NSString localizedUserNotificationStringForKey: msg arguments:nil];
    objNotificationContent.sound = [UNNotificationSound defaultSound];

    /// 4. update application icon badge number
    objNotificationContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);


    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];

//    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"ten"
                                                                          content:objNotificationContent trigger:trigger];
    /// 3. schedule localNotification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
//            NSLog(@"Local Notification succeeded");
        }
        else {
            NSLog(@"Local Notification failed");
        }
    }];
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
}
@end
