//
//  ZooNode.swift
//  Virtual-Oswald
//
//  Created by Yari Crollet on 17/04/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import UIKit
import SceneKit

class ZooNode: SCNNode {
    
    var sceneName: String!
    
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
    
    //Create a node from a 3D model
    func setup(){
        let planeScene = SCNScene(named: "art.scnassets/"+self.sceneName+"/"+self.sceneName+".dae")!
        let zooNode = planeScene.rootNode.childNode(withName: "baseNode", recursively: true)!
        zooNode.scale = SCNVector3Make(0.025 , 0.025, 0.025)
        zooNode.opacity = 0.5
        addChildNode(zooNode)
        name = "baseNode"
    }
    
    func setOpacity(opacity: CGFloat){
        let child = childNode(withName: "baseNode", recursively: true)
        child?.opacity = opacity
    }
}
