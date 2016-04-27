//
//  DriveViewController.swift
//  AnyCar
//
//  Created by David Stancu on 4/24/16.
//  Copyright © 2016 Awesome IT. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class DriveViewController : UIViewController {
    
    var avPlayer: AVAudioPlayer!
    var milesPerHour: Bool?
    var carName: String?
    var carImageLink: String?
    var carSoundLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = carName
        let path = NSBundle.mainBundle().pathForResource("r8", ofType: "mp3")
        
        do {
            self.avPlayer = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path!))
            self.avPlayer.numberOfLoops = -1
            self.avPlayer.prepareToPlay()
            self.avPlayer.play()
        } catch let e as NSError {
            print("\(e)")
        }
        super.viewWillAppear(animated)
    }
    
    
}
