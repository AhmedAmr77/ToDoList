//
//  ViewController.h
//  ToDoList
//
//  Created by Ahmd Amr on 4/2/21.
//  Copyright © 2021 Ahmd Amr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskViewController.h"
#import "DelegationProtocol.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DelegationProtocol, UISearchBarDelegate>


@end

