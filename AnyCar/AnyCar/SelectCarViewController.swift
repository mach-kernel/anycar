//
//  ViewController.swift
//  AnyCar
//
//  Created by David Stancu on 4/11/16.
//  Copyright © 2016 Awesome IT. All rights reserved.
//

import UIKit

class SelectCarViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    var cars: [String:Array<String>] = [
        "Audi R8" : ["r8.jpg", "r8.mp3"],
        "Jetsons" : []
    ]
    
    @IBOutlet var CarPicker: UIPickerView!
    var pickerData : Array<String>!
    
    @IBOutlet var MPH: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CarPicker.dataSource = self
        CarPicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.pickerData = Array(self.cars.keys)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let carName = pickerData[CarPicker.selectedRowInComponent(0)]
        let carAudioLink = cars[carName]![1]
        let carImageLink = cars[carName]![0]
    
        let destinationVC = segue.destinationViewController as! DriveViewController
        destinationVC.carName = carName
        destinationVC.carImageLink = carImageLink
        destinationVC.carSoundLink = carAudioLink
//        // Create a new variable to store the instance of PlayerTableViewController
//        let destinationVC = segue.destinationViewController as PlayerTableViewController
//        destinationVC.programVar = newProgramVar
    }
}

