//
//  CameraViewController.swift
//  Virtual-Oswald
//
//  Created by Yari Crollet on 12/03/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import Foundation
import ARKit
import UIKit

@available(iOS 11.3, *)
class CameraViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var textBubbleLableButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var textBubble: UILabel!
    @IBOutlet weak var Oswald: UIButton!
    var oswaldComponent: OswaldComponent!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.delegate = self
        
        oswaldComponent = OswaldComponent(uiController: self)
        //oswaldComponent.doAnimation(operation: false
        initSwipeGestures()

        
    }
    
    func initSwipeGestures(){
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(CameraViewController.handleSwipes(_:)))
        upSwipe.direction = .up
        self.view.addGestureRecognizer(upSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .up) {
            let achtionSheet = ActionSheet()
            present(achtionSheet.showActionSheet(), animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("camera view loaded")
        super.viewWillAppear(animated)
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "ARImages", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("in render")
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        
        print(imageAnchor.referenceImage.name!)
        
        // 1. Load plane's scene.
        let planeScene = SCNScene(named: "art.scnassets/Oswald/oswald.dae")!
        let planeNode = planeScene.rootNode.childNode(withName: "baseNode", recursively: true)!
        
        // 2. Calculate size based on planeNode's bounding box.
        let (min, max) = planeNode.boundingBox
        let size = SCNVector3Make(max.x - min.x, max.y - min.y, max.z - min.z)
        
        // 3. Calculate the ratio of difference between real image and object size.
        // Ignore Y axis because it will be pointed out of the image.
        let widthRatio = Float(imageAnchor.referenceImage.physicalSize.width)/size.x
        let heightRatio = Float(imageAnchor.referenceImage.physicalSize.height)/size.z
        // Pick smallest value to be sure that object fits into the image.
        let finalRatio = [widthRatio, heightRatio].min()!
        
        // 4. Set transform from imageAnchor data.
        planeNode.transform = SCNMatrix4(imageAnchor.transform)
        
        // 5. Animate appearance by scaling model from 0 to previously calculated value.
        let appearanceAction = SCNAction.scale(to: CGFloat(finalRatio), duration: 0.4)
        appearanceAction.timingMode = .easeOut
        // Set initial scale to 0.
        planeNode.scale = SCNVector3Make(0, 0, 0)
        // Add to root node.
        sceneView.scene.rootNode.addChildNode(planeNode)
        // Run the appearance animation.
        planeNode.runAction(appearanceAction)
    }
    @IBAction func textBubbleButton(_ sender: Any) {
       // oswaldComponent.textBalloonButton();
        
    }
}
