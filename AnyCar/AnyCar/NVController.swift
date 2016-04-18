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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        do {
            let results = try context
                .executeFetchRequest(NSFetchRequest(entityName: "singlyton"))
                as! [NSManagedObject]
            
            if results.count == 0 {
                let entity = NSEntityDescription.entityForName("SettingSingleton", inManagedObjectContext: context)
                
                let settingSingleton = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
                
                settingSingleton.setValue(true, forKey: "speed_metric")
                
                do {
                    try context.save()
                } catch let _ as NSError {
                    
                }
                
            }
            
            self.settings = results[0]
        } catch let error as NSError {
            print ("oh no fuck")
        }
        
        print(settings)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
