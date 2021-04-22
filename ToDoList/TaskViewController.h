//
//  TaskViewController.h
//  ToDoList
//
//  Created by Ahmd Amr on 4/5/21.
//  Copyright © 2021 Ahmd Amr. All rights reserved.
//

#import "ViewController.h"
#import "DelegationProtocol.h"
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskViewController : UIViewController <UNUserNotificationCenterDelegate>

@property id <DelegationProtocol> delegationProtocol;
@property Boolean isAdd;
@property NSDictionary *taskDictBox;
@property int editedIndex;

@end

NS_ASSUME_NONNULL_END
