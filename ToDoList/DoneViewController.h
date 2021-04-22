//
//  DoneViewController.h
//  ToDoList
//
//  Created by Ahmd Amr on 4/5/21.
//  Copyright © 2021 Ahmd Amr. All rights reserved.
//

#import "ViewController.h"
#import "TaskViewController.h"
#import "DelegationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : ViewController  <UITableViewDataSource, UITableViewDelegate, DelegationProtocol, UISearchBarDelegate>

@end

NS_ASSUME_NONNULL_END
