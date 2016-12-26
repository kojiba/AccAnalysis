//
//  ViewController.swift
//  123
//
//  Created by kojiba on 23.12.16.
//  Copyright © 2016 kojiba. All rights reserved.
//

import UIKit
import CoreMotion


class ViewController: UIViewController, UIAccelerometerDelegate {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var botLabel: UILabel!

    var manager = CMMotionManager()
    let updateTime = 0.02
    let gravityConstant = 9.80665

    override func viewDidLoad() {
        super.viewDidLoad()

        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = updateTime

            if let queue = OperationQueue.current {
                manager.startAccelerometerUpdates(to: queue) { (data: CMAccelerometerData?, error: Error?) in

                    if let error = error {
                        print(error)
                        return
                    }

                    if let acceleration = data?.acceleration {

                        print(acceleration)

                        let formatter = NumberFormatter()
                        formatter.maximumFractionDigits = 4
                        formatter.minimumFractionDigits = 4
                        let updateTime = self.updateTime
                        let gravityConstant = self.gravityConstant

                        self.topLabel.text = formatter.string(from:
                        NSNumber(value: acceleration.x * updateTime * updateTime * gravityConstant))!
                        self.midLabel.text = formatter.string(from:
                        NSNumber(value: acceleration.y * updateTime * updateTime * gravityConstant))!
                        self.botLabel.text = formatter.string(from:
                        NSNumber(value: acceleration.z * updateTime * updateTime * gravityConstant))!
                    }
                }
            }
        } else {
            print("Accelerometer unavailable")
        }
    }
}

