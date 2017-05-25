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
    let updateTime = 0.01
    var line: [SCNVector3] = [SCNVector3]()

    var accelerations: [SCNVector3] = [SCNVector3]()
    var velocities: [SCNVector3] = [SCNVector3]()
    var coordinates: [SCNVector3] = [SCNVector3]()

    var lineScene: RandomLineScene!
    let threshold: Double = 0.02
    let scale: Double = 1500

    let velocityThreshold: Double = 0.02
    let maxVelocity: Double = 25

    override func viewDidLoad() {
        super.viewDidLoad()

        lineScene = RandomLineScene()
        scene.scene = lineScene

        scene.autoenablesDefaultLighting = true
        scene.allowsCameraControl = true
        scene.layer.borderColor = UIColor.red.cgColor
        scene.layer.borderWidth = 1.0

//        self.view.isUserInteractionEnabled = false

        line.append(SCNVector3(0, 0, 0))

        self.lineScene.setupCameraNode()

        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = updateTime
            manager.deviceMotionUpdateInterval = updateTime

            manager.startDeviceMotionUpdates(to: OperationQueue.current!) { (motion: CMDeviceMotion?, error: Error?) in

                if let acceleration = motion?.userAcceleration {

                    let accelerationX = acceleration.x
                    let accelerationY = acceleration.y
                    let accelerationZ = acceleration.z

                    let updateTime = self.updateTime

                    var velocityX = 0.0
                    var velocityY = 0.0
                    var velocityZ = 0.0

                    if let last = self.velocities.last {
                        velocityX = Double(last.x)
                        velocityY = Double(last.y)
                        velocityZ = Double(last.z)
                    }

                    // current vel
                    velocityX = accelerationX * updateTime + velocityX
                    velocityY = accelerationY * updateTime + velocityY
                    velocityZ = accelerationZ * updateTime + velocityZ

                    if abs(velocityX) < self.threshold {
                        velocityX = 0
                    }
                    if abs(velocityY) < self.threshold {
                        velocityY = 0
                    }
                    if abs(velocityZ) < self.threshold {
                        velocityZ = 0
                    }

                    // current coords
                    var coordX = 0.0
                    var coordY = 0.0
                    var coordZ = 0.0

                    if let last = self.coordinates.last {
                        coordX = Double(last.x)
                        coordY = Double(last.y)
                        coordZ = Double(last.z)
                    }

                    coordX = coordX + velocityX * updateTime + accelerationX * updateTime * updateTime * 0.5
                    coordY = coordY + velocityY * updateTime + accelerationY * updateTime * updateTime * 0.5
                    coordZ = 0 //coordZ + velocityZ * updateTime + accelerationZ * updateTime * updateTime * 0.5

                    if abs(coordX) > 0.05 {
                        if coordX < 0 {
                            coordX += 0.05
                        } else {
                            coordX -= 0.05
                        }
                    }

                    if abs(coordY) > 0.05 {
                        if coordY < 0 {
                            coordY += 0.05
                        } else {
                            coordY -= 0.05
                        }
                    }

                    velocityX = self.filterVelocityToThreshold(velocityX)
                    velocityY = self.filterVelocityToThreshold(velocityY)

                    self.accelerations.append(SCNVector3(accelerationX, accelerationY, accelerationZ))
                    self.velocities.append(SCNVector3(velocityX, velocityY, velocityZ))
                    self.coordinates.append(SCNVector3(coordX, coordY, coordZ))

                    self.lineScene.appendNewPoint(point: SCNVector3(coordX * self.scale,
                            coordY * self.scale,
                            coordZ * self.scale))
                }
            }
        }
    }

    func filterVelocityToThreshold(_ velocity: Double) -> Double{
        if abs(velocity) < self.threshold {
            return 0
        }
        if velocity > maxVelocity {
            return maxVelocity
        }
        return velocity
    }

}
