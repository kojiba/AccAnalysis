//
//  CubeScene.swift
//  CubeSceneKit
//
//  Created by Matt Coneybeare on 10/31/14.
//  Copyright (c) 2014 Urban Apps. All rights reserved.
//

import UIKit
import SceneKit

class CubeScene: SCNScene {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()
        setupCameraNode()
        setupFaceNodes()
        setupEdgeNodes()
    }

    let numDashes: Int = 12

    let cubeSize: Float = 1.0
    let easing: Float = 4
    let thinStrokeWeight: Float = 1.0
    let thickStrokeWeight: Float = 2.0
    let dashLength: Float = 0.5

//    let l: CGFloat = cubeSize * 0.585 * CGFloat(canvasSize)
//    let q: CGFloat = -1 * (thinStrokeWeight / 2)

    let l: Float = 25.0 // 0.585 // This is the length where rotation won't extend past the borders
    let q: Float = -0.5

    private func setupCameraNode() {
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 25
        camera.zNear = 0
        camera.zFar = 250

        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(0, 0, 200.0)
        rootNode.addChildNode(cameraNode)
    }

    private func squareVertices(length: Float) -> [SCNVector3] {
        let m = length/Float(2)

        let topLeft =       SCNVector3Make(-m-q,  m+q, m+q)
        let topRight =      SCNVector3Make( m+q,  m+q, m+q)
        let bottomLeft =    SCNVector3Make(-m-q, -m-q, m+q)
        let bottomRight =   SCNVector3Make( m+q, -m-q, m+q)

        return [topLeft, topRight, bottomLeft, bottomRight]
    }

    private func cubeFace() -> SCNGeometry {

        let vertices : [SCNVector3] = squareVertices(length: l)
        let geoSrc = SCNGeometrySource(vertices: UnsafePointer<SCNVector3>(vertices), count: vertices.count)

        // index buffer
        let idx1 : [Int32] = [0, 3]
        let data1 = NSData(bytes: idx1, length: (MemoryLayout<Int32>.size * idx1.count))
        let geoElements1 = SCNGeometryElement(data: data1 as Data, primitiveType: SCNGeometryPrimitiveType.line, primitiveCount: idx1.count, bytesPerIndex: MemoryLayout<Int32>.size)

        let idx2 : [Int32] = [1, 2]
        let data2 = NSData(bytes: idx2, length: (MemoryLayout<Int32>.size * idx2.count))
        let geoElements2 = SCNGeometryElement(data: data2 as Data, primitiveType: SCNGeometryPrimitiveType.line, primitiveCount: idx2.count, bytesPerIndex: MemoryLayout<Int32>.size)

        let geo = SCNGeometry(sources: [geoSrc], elements: [geoElements1, geoElements2])

        return geo
    }

    private func setupFaceNodes() {
        // sides
        for i in 0..<4 {
            let face = SCNNode(geometry: cubeFace())
            face.rotation = SCNVector4Make(0, 1, 0, Float(i) * Float(M_PI_2))
            rootNode.addChildNode(face)
        }
        // top/bottom
        for i in [1, 3] {
            let face = SCNNode(geometry: cubeFace())
            face.rotation = SCNVector4Make(1, 0, 0, Float(i) * Float(M_PI_2))
            rootNode.addChildNode(face)
        }
    }

    private func threeEdgeFace() -> SCNGeometry {

        let vertices : [SCNVector3] = squareVertices(length: l)
        let geoSrc = SCNGeometrySource(vertices: UnsafePointer<SCNVector3>(vertices), count: vertices.count)

        // index buffer
        let idx1 : [Int32] = [0, 1]
        let data1 = NSData(bytes: idx1, length: (MemoryLayout<Int32>.size * idx1.count))
        let geoElements1 = SCNGeometryElement(data: data1 as Data, primitiveType: SCNGeometryPrimitiveType.line, primitiveCount: idx1.count, bytesPerIndex: MemoryLayout<Int32>.size)

        let idx2 : [Int32] = [0, 2]
        let data2 = NSData(bytes: idx2, length: (MemoryLayout<Int32>.size * idx2.count))
        let geoElements2 = SCNGeometryElement(data: data2 as Data, primitiveType: SCNGeometryPrimitiveType.line, primitiveCount: idx2.count, bytesPerIndex: MemoryLayout<Int32>.size)

        let idx3 : [Int32] = [2, 3]
        let data3 = NSData(bytes: idx3, length: (MemoryLayout<Int32>.size * idx3.count))
        let geoElements3 = SCNGeometryElement(data: data3 as Data, primitiveType: SCNGeometryPrimitiveType.line, primitiveCount: idx3.count, bytesPerIndex: MemoryLayout<Int32>.size)

        let geo = SCNGeometry(sources: [geoSrc], elements: [geoElements1, geoElements2, geoElements3])

        return geo

    }

    private func setupEdgeNodes() {
        // sides
        for i in 0..<4 {
            let edges = SCNNode(geometry: threeEdgeFace())
            edges.rotation = SCNVector4Make(0, 1, 0, Float(i) * Float(M_PI_2))
            rootNode.addChildNode(edges)
        }
    }
}
