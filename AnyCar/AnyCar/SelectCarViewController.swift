//
//  ViewController.swift
//  AnyCar
//
//  Created by David Stancu on 4/11/16.
//  Copyright © 2016 Awesome IT. All rights reserved.
//

import UIKit

class SelectCarViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    var cars: [String:String] = [
        "Audi R8" : "r8",
        "Jetsons" : "jetsons"
    ]
    
    @IBOutlet var CarPicker: UIPickerView!
    @IBOutlet var unitModal: UISegmentedControl!
    @IBOutlet var unitSampleLabel: UILabel!
    @IBOutlet var unitSample: UILabel!
    @IBOutlet var unitSampleSlider: UISlider!
    @IBOutlet var unitCeiling: UILabel!
    @IBOutlet var infoButton: UIButton!
    
    var pickerData : Array<String>!
    
    @IBOutlet var MPH: UISegmentedControl!
    
    @IBAction func sampleChanged(sender: AnyObject) {
        self.unitSample.text = "\(self.unitSampleSlider.value)"
    }
    
    @IBAction func unitsChanged(sender: AnyObject) {
        let isImperial = self.unitModal.selectedSegmentIndex == 0
        
        self.unitSampleLabel.text = isImperial ? "mph" : "kmh"
        self.unitCeiling.text = isImperial ? "mph" : "kmh"
        
        // Approximation
        self.unitSampleSlider.maximumValue = isImperial ? 160.0 : 257.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CarPicker.dataSource = self
        CarPicker.delegate = self
        let infoButtonImage = UIImage(contentsOfFile: "info.png")
        self.infoButton.setBackgroundImage(infoButtonImage, forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.pickerData = Array(self.cars.keys)
        self.unitSample.text = "\(self.unitSampleSlider.value)"
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
    
    @IBAction func infoButtonTapped(sender: UIButton) {

        let alert = UIAlertController(title: "Sampling Speed", message: "Choose a top speed for your activity! (suggested: 6mph for walking/jogging, 25mph for biking, 100mph for driving)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let carName = pickerData[CarPicker.selectedRowInComponent(0)]
    
        let destinationVC = segue.destinationViewController as! DriveViewController
        destinationVC.carName = carName
        destinationVC.carAssetKey = cars[carName]
        destinationVC.sampleSpeed = Double(self.unitSampleSlider.value)
        destinationVC.isImperial = self.unitModal.selectedSegmentIndex == 0
    }
}

