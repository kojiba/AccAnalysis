//
// Created by kojiba on 19.04.17.
// Copyright (c) 2017 kojiba. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import CoreMotion

class SpaceViewController: UIViewController {

    @IBOutlet weak var scene: SCNView!

    var manager = CMMotionManager()
    let updateTime = 0.1
    var line: [SCNVector3] = [SCNVector3]()

    var lineScene: RandomLineScene!

    override func viewDidLoad() {
        super.viewDidLoad()

        lineScene = RandomLineScene()
        scene.scene = lineScene

        scene.autoenablesDefaultLighting = true
        scene.allowsCameraControl = true
        scene.layer.borderColor = UIColor.red.cgColor
        scene.layer.borderWidth = 1.0

        self.lineScene.setupCameraNode()

        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = updateTime
            manager.deviceMotionUpdateInterval = updateTime

            manager.startDeviceMotionUpdates(to: OperationQueue.current!) { (motion: CMDeviceMotion?, error: Error?) in

                if let acceleration = motion?.userAcceleration {

                    let updateTime = self.updateTime
                    let constant = updateTime * updateTime / 2

                    var deltaX = 0.0
                    var deltaY = 0.0
                    var deltaZ = 0.0

                    if let last = self.line.last {
                        deltaX = Double(last.x)
                        deltaY = Double(last.y)
                        deltaZ = Double(last.z)
                    }

                    self.line.append(SCNVector3(deltaX + acceleration.x * constant, deltaY + acceleration.y * constant, deltaZ + acceleration.z * constant))
                    self.lineScene.drawLine(points: self.line)
                }
            }
        }
    }

}
