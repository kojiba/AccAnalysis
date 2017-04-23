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
    }

    func setupCameraNode() {
        let camera = SCNCamera()
        camera.automaticallyAdjustsZRange = true

        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(0, 0, 20)
        rootNode.addChildNode(cameraNode)
    }

    func drawLine(points: [SCNVector3]) {

        let geometry = SCNGeometrySource(vertices: UnsafePointer<SCNVector3>(points), count: points.count)

        var indexes: [Int32] = [Int32]()
        for index in 0 ..< points.count {
            indexes.append(Int32(index))
        }
        let data1 = Data(bytes: indexes, count: (MemoryLayout<Int32>.size * indexes.count))

        let element = SCNGeometryElement(data: data1,
                primitiveType: .line,
                primitiveCount: indexes.count, bytesPerIndex: MemoryLayout<Int32>.size)

        let line = SCNGeometry(sources: [geometry], elements: [element])
        let node = SCNNode(geometry: line)

        rootNode.childNodes.last?.removeFromParentNode()
        rootNode.addChildNode(node)
    }
}
