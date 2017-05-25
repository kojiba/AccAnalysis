//
// Created by kojiba on 25.05.17.
// Copyright (c) 2017 kojiba. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class PureDataViewController: UIViewController {

    var manager = CMMotionManager()

    @IBOutlet weak var textView: UITextView!
    let updateTime = 0.01

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.stopDeviceMotionUpdates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = updateTime
            manager.deviceMotionUpdateInterval = updateTime

            manager.startDeviceMotionUpdates(to: OperationQueue.current!) { (motion: CMDeviceMotion?, error: Error?) in

                if let acceleration = motion?.userAcceleration {

                    let accelerationX = acceleration.x
                    let accelerationY = acceleration.y
                    let accelerationZ = acceleration.z

                    self.textView.text = self.textView.text.appending("\(accelerationX); \(accelerationY); \(accelerationZ)")

                    print("\(accelerationX); \(accelerationY); \(accelerationZ)")
                }
            }
        }
    }

}
