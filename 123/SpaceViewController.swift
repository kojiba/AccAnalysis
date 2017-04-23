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
    let threshold: Double = 0.002
    let scale: Double = 10

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
                    var constant = updateTime * updateTime / 2
                    constant *= self.scale

                    var deltaX = 0.0
                    var deltaY = 0.0
                    var deltaZ = 0.0

                    if let last = self.line.last {
                        deltaX = Double(last.x)
                        deltaY = Double(last.y)
                        deltaZ = Double(last.z)
                    }

                    var xAcceleration = acceleration.x
                    var yAcceleration = acceleration.y
                    var zAcceleration = acceleration.z

                    if abs(xAcceleration) < self.threshold {
                        xAcceleration = 0
                    }
                    if abs(yAcceleration) < self.threshold {
                        yAcceleration = 0
                    }
                    if abs(zAcceleration) < self.threshold {
                        zAcceleration = 0
                    }

                    if xAcceleration == 0
                     && yAcceleration == 0
                     && zAcceleration == 0 {
                        return
                    }

                    let xa = xAcceleration * constant
                    let y = yAcceleration * constant
                    let z = zAcceleration * constant

                    self.line.append(SCNVector3(xa + deltaX, y + deltaY, z + deltaZ))
                    self.lineScene.appendNewPoint(point: SCNVector3(xa + deltaX, y + deltaY, z + deltaZ))
                }
            }
        }
    }

}
