//
//  DriveViewController.swift
//  AnyCar
//
//  Created by David Stancu on 4/24/16.
//  Copyright © 2016 Awesome IT. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation
import UIKit
import SwiftGifOrigin

class DriveViewController : UIViewController, CLLocationManagerDelegate {
    
    var carName: String?
    var carAssetKey: String?
    
    var avPlayer: AVAudioPlayer!
    
    var isImperial: Bool?
    var sampleSpeed: Double?
    var timer: NSTimer?

    var lastDelta: Double?
    var deltaCount = 0
    var currentState: String?
    
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    
    var clManager: CLLocationManager?
    
    @IBOutlet var vehicleImage: UIImageView!
    @IBOutlet var speedText: UILabel!
    @IBOutlet var distanceText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        vehicleState("idle")

        self.clManager = CLLocationManager()
        
        self.clManager!.desiredAccuracy = kCLLocationAccuracyBest
        self.clManager!.requestAlwaysAuthorization()
        self.clManager!.delegate = self
        
        self.clManager!.startUpdatingLocation()
        
        self.timer = NSTimer
            .scheduledTimerWithTimeInterval(
                0.1,
                target: self,
                selector: #selector(DriveViewController.updateDeltas),
                userInfo: nil,
                repeats: true
        )

        self.title = carName

        let vehicleGif = UIImage.gifWithName(self.carAssetKey!)
        self.vehicleImage.image = vehicleGif
        
        self.vehicleImage.contentMode = .ScaleAspectFit
        self.vehicleImage.clipsToBounds = true
        
        self.lastDelta = 0
        super.viewWillAppear(animated)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("updated")
        if startLocation == nil {
            startLocation = locations.first as CLLocation!
        } else {
            let lastLocation = locations.last as CLLocation!
            let distance = startLocation.distanceFromLocation(lastLocation)
            startLocation = lastLocation
            traveledDistance += distance
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            formatter.roundingMode = NSNumberFormatterRoundingMode.RoundDown
            formatter.maximumFractionDigits = 2
            
            let distanceTotal = (traveledDistance / (self.isImperial! ? 1609.34 : 1000))
            
            distanceText.text = formatter.stringFromNumber(distanceTotal)! + (self.isImperial! ? " miles" : " kilometers")
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.avPlayer.stop()
        self.timer?.invalidate()
    }

    func vehicleState(state: String) {
        let path = NSBundle
            .mainBundle()
            .pathForResource("\(self.carAssetKey!)_\(state)", ofType: "m4a")
        
        if let avp = self.avPlayer {
            if self.currentState != state {
                if avp.playing {
                    avp.stop()
                }
                
                do {
                    self.avPlayer = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path!))
                    self.avPlayer.numberOfLoops = -1
                    self.avPlayer.enableRate = true
                    self.avPlayer.prepareToPlay()
                    self.avPlayer.play()
                } catch {
                    
                }
                
                self.currentState = state
            } else {
                 self.avPlayer.rate = 0.9
            }
        } else {
            do { self.avPlayer = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path!)) }
            catch {}
            vehicleState(state)
        }
    }


    func updateDeltas(timer: NSTimer) {
        if let clManager = self.clManager {
            
            self.deltaCount += 1
            
            if let location = clManager.location {
                if let imperial = self.isImperial {
                    // Update speeds
                    let speed = location.speed * (imperial ? 1 : 1.6) / 2.23694
                    
                    if let ld = self.lastDelta {
                        print("\(speed) \(ld)")
                        
                        if speed > 0 && speed > ld {
                            if self.currentState != "accel" {
                                vehicleState("accel")
                            }
                        } else if speed < ld {
                            if self.currentState != "decel" {
                                vehicleState("decel")
                            }
                        } else if speed < 1 {
                            if self.currentState != "idle" {
                                vehicleState("idle")
                            }
                        }
                    }
                    let formatter = NSNumberFormatter()
                    formatter.numberStyle = .DecimalStyle
                    formatter.roundingMode = NSNumberFormatterRoundingMode.RoundDown
                    formatter.maximumFractionDigits = 2
                    
                    self.speedText.text = formatter.stringFromNumber(speed)! + (imperial ? "mph" : "kmh")
                    self.avPlayer.rate = Float(speed / self.sampleSpeed!)
                    self.lastDelta = speed
                }
            }
        }
    }
}
