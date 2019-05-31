//
//  FocalNode.swift
//  ARRefurnishing
//
//  Created by Yari Crollet on 11/04/2019.
//  Copyright © 2019 Yari Crollet. All rights reserved.
//

import UIKit
import SceneKit

class FocalNode: SCNNode {

    let size: CGFloat = 0.1
    let segmentWidth: CGFloat = 0.004
    var sceneName: String!
    
    private let colorMaterial: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        return material
    }()
    override init() {
        super.init()
    }
    
    convenience init(sceneName: String) {
        self.init()
        self.sceneName = sceneName
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func createSegment(width: CGFloat, height: CGFloat) -> SCNNode {
        let segment = SCNPlane(width: width, height: height)
        segment.materials = [colorMaterial]
        
        return SCNNode(geometry: segment)
    }
    
    private func addHorizontalSegment(dx: Float) {
        let segmentNode = createSegment(width: segmentWidth, height: size)
        segmentNode.position.x += dx
        
        addChildNode(segmentNode)
    }
    
    private func addVerticalSegment(dy: Float) {
        let segmentNode = createSegment(width: size, height: segmentWidth)
        segmentNode.position.y += dy
        
        addChildNode(segmentNode)
    }
    
    private func setup() {
        let zooNode = ZooNode(sceneName: self.sceneName)
        addChildNode(zooNode)
    }
}
