//
// Created by kojiba on 19.04.17.
// Copyright (c) 2017 kojiba. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class RandomLineScene: SCNScene {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()
//        setupCameraNode()
        drawAxis()
    }

    func setupCameraNode() {
        let camera = SCNCamera()
        camera.automaticallyAdjustsZRange = true
        
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(0, 0, 10)
        rootNode.addChildNode(cameraNode)
    }

    var lastPoint: SCNVector3 = SCNVector3(0,0,0)

    func appendNewPoint(point: SCNVector3) {
        let line = createLineFromPoints(first: lastPoint, second: point)
        rootNode.addChildNode(line)
        lastPoint = point
    }

    func createLineFromPoints(first: SCNVector3, second: SCNVector3, color: UIColor = UIColor.white) -> SCNNode {
        let geometry = SCNGeometrySource(vertices: UnsafePointer<SCNVector3>([first, second]), count: 2)
        let indexes: [Int32] = [0, 1]
        let data1 = Data(bytes: indexes, count: (MemoryLayout<Int32>.size * indexes.count))

        let element = SCNGeometryElement(data: data1,
                primitiveType: .line,
                primitiveCount: indexes.count, bytesPerIndex: MemoryLayout<Int32>.size)

        let line = SCNGeometry(sources: [geometry], elements: [element])

//        line.firstMaterial?.lightingModel = .blinn
//        line.firstMaterial?.emission.contents = color
        line.firstMaterial?.diffuse.contents = color

        let node = SCNNode(geometry: line)
        return node
    }

    func drawAxis() {
        let x = createLineFromPoints(first: SCNVector3(0, 0, 0), second: SCNVector3(20, 0, 0), color: UIColor.red)
        let y = createLineFromPoints(first: SCNVector3(0, 0, 0), second: SCNVector3(0, 20, 0), color: UIColor.green)
        let z = createLineFromPoints(first: SCNVector3(0, 0, 0), second: SCNVector3(0, 0, 20), color: UIColor.blue)

        let nodes = [x,y,z]
        for node in nodes {
            rootNode.addChildNode(node)
        }
    }

    func pairPointsForLines(points: [SCNVector3]) -> [[SCNVector3]] {

        var result = [[SCNVector3]]()

        let range = 0..<(points.count - 1)
        for index in range {
            result.append([points[index], points[index + 1]])
        }

        return result
    }
}
