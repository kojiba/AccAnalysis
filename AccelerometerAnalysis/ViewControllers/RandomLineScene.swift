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
        drawAxis()
    }


    func setupCameraNode() {
        let camera = SCNCamera()
        camera.automaticallyAdjustsZRange = false

        let zIndex = 35.0
        camera.zNear = zIndex
        camera.zFar = -zIndex

        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(0, 0, Float(zIndex))
        rootNode.addChildNode(cameraNode)
    }

    func setup3dCameraNode() {
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(2,2,7)
        rootNode.addChildNode(cameraNode)
    }

    var lastPoint: SCNVector3 = SCNVector3(0, 0, 0)

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

        line.firstMaterial?.diffuse.contents = color

        let node = SCNNode(geometry: line)
        return node
    }

    func drawAxis() {
        let constantEnd = 20
        let x = createLineFromPoints(first: SCNVector3(-constantEnd, 0, 0), second: SCNVector3(constantEnd, 0, 0), color: UIColor.red)
        let xa = createLineFromPoints(first: SCNVector3(constantEnd - 1, -1, 0), second: SCNVector3(constantEnd, 0, 0), color: UIColor.red)

        let y = createLineFromPoints(first: SCNVector3(0, -constantEnd, 0), second: SCNVector3(0, constantEnd, 0), color: UIColor.green)
        let ya = createLineFromPoints(first: SCNVector3(1, constantEnd - 1, 0), second: SCNVector3(0, constantEnd, 0), color: UIColor.green)

        let z = createLineFromPoints(first: SCNVector3(0, 0, -constantEnd), second: SCNVector3(0, 0, constantEnd), color: UIColor.blue)

        let nodes = [x, xa, y, ya, z]
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
