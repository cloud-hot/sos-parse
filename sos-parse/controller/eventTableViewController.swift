//
//  eventTableViewController.swift
//  sos-parse
//
//  Created by wenjiez on 14/11/20.
//  Copyright (c) 2014年 wenjiez. All rights reserved.
//

import UIKit

class eventTableViewController: PFQueryTableViewController {
    
    override func queryForTable() -> (PFQuery) {
        let query = super.queryForTable()
        query.orderByAscending("priority")
        return query
    }
}
