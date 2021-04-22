//
//  TaskData.h
//  ToDoList
//
//  Created by Ahmd Amr on 4/2/21.
//  Copyright © 2021 Ahmd Amr. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskData : NSObject

@property NSString *name, *desc, *priority;
@property NSDate *creationDate, *reminderDate;

@end

NS_ASSUME_NONNULL_END
