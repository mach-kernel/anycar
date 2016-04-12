//
//  NVController.swift
//  AnyCar
//
//  Created by David Stancu on 4/11/16.
//  Copyright © 2016 Awesome IT. All rights reserved.
//

import UIKit
import CoreData

class NVController : UINavigationController {
    
    var cars = [NSManagedObject]()
    var settings = NSManagedObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add some cars
        if (cars.count == 0) {
            // TODO: actually do it
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
