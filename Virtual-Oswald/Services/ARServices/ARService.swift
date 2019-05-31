import Foundation
import ARKit

class ARService:NSObject, ARSCNViewDelegate {
    
    var sceneView: ARSCNView
    var Dier = " "
    var dieren = ["nijlpaard","leeuw","olifant","eland","wolf"]
    var currentAnchor: ARAnchor?
    var results: simd_float4x4?
    var delegate: ARServiceDelegate?
    var tutorialDelegate : TutorialDelegate?
    var tutorialState: TutorialState = .scan
    var currentAngleY: Float = 0.0
    
    var dummyNode: SCNNode?
    var planeNode: SCNNode?
    var highlightedNode: SCNNode?
    var anchor: ARAnchor!
    var scene: String = "savane"
    var endNodeState: SceneState? {
        didSet{
            updateState()
        }
    }
    var animalArray: [SCNNode]?
    var completedWalkthrough: Bool?
    var completedWalkthroughInThisSession = false
    var demo : Bool?
    let session = ARSession()
    let sessionConfiguration: ARWorldTrackingConfiguration = {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal,.vertical]
        return config
    }()
    var focalNode: FocalNode?
    var endNode: SCNNode?
    private var screenCenter: CGPoint!
    private var originalRotation: SCNVector3?
    
    var didntFoundAnimal: ((String) -> Void)?
    var closeTopview: (() -> Void)?
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }
    
    func viewWillAppear() {
        if ARWorldTrackingConfiguration.isSupported {
            session.run(sessionConfiguration, options: [.removeExistingAnchors, .resetTracking])
        } else {
            print("Sorry, your device doesn't support ARKit")
        }
            
    }
    
    func viewDidLoad() {
        screenCenter = sceneView.center
        sceneView.delegate = self
        
        sceneView.session = session
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        self.demo = SettingsService.shared().demoApplication ?? false
        
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        
        sceneView.preferredFramesPerSecond = 60
        self.completedWalkthrough = UserDefaults.standard.bool(forKey: "completedWalkthrough")
        
        if(!self.doneWalkthrough()){

            self.tutorialDelegate?.getStepWithState(nextState: .scan)
        }
        else{
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
            sceneView.addGestureRecognizer(longPress)
            let pichgesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
            sceneView.addGestureRecognizer(pichgesture)
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewPanned))
            sceneView.addGestureRecognizer(panGesture)
            let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(viewRotated))
            sceneView.addGestureRecognizer(rotationGesture)
            self.tutorialState = .finished
        }
    }
    
    func doneWalkthrough() -> Bool{
        if(self.demo ?? false){
            print("demo app")
            return false
        }
        print("geen demo app")
        return self.completedWalkthrough ?? false
    }
    
    func ShowAllAnimals(animalType: String){
        self.animalArray = []
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            if(node.name != nil){
                if(animalType == node.name!.description){
                    self.animalArray?.append(node)
                    //node.toggleBlink(shouldBlink: true)
                }
            }
        }
        if(self.animalArray == []){
            self.didntFoundAnimal!(animalType);
        }
        else{
            self.closeTopview!();
            self.blinkArray()
        }
            
        
    }
    
    func blinkArray(){
        let blinker = Timer.scheduledTimer(withTimeInterval: 0.2,  repeats: true) { (nil) in
            for node in self.animalArray! {
                node.isHidden = !node.isHidden
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (nil) in
            blinker.invalidate()
            for node in self.animalArray! {
                node.isHidden = false
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        guard focalNode != nil else { return }
        switch sender.state {
        case .ended:
            if(self.endNode == nil || self.endNodeState == .removed || self.tutorialState == .placeFocalNode){
                self.endNodeState = .none
            }else{
                if(self.endNodeState == .edit){
                    if(self.scene == "savane"){self.scene = "forestZoo"}else{self.scene = "savane"}
                    let zooNode = ZooNode(sceneName: self.scene)
                    let base = self.endNode?.childNode(withName: "baseNode", recursively: true)
                    self.endNode?.replaceChildNode(base!, with: zooNode)
                    if(self.tutorialState == .editTap){
                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
                        sceneView.addGestureRecognizer(longPress)
                    
                        self.tutorialDelegate?.getStepWithState(nextState: .editLongPress)
                        
                    }
                }
                if(self.endNodeState == .final){
                    let location: CGPoint = sender.location(in: sceneView)
                    let hits = self.sceneView.hitTest(location, options: nil)
                    if !hits.isEmpty{
                        let tappedNode = hits.first?.node
                        if(self.dieren.contains((tappedNode?.name!.description)!)){
                            if(self.highlightedNode == tappedNode){
                                self.highlightedNode?.dehighlight()
                                self.Dier = " "
                                self.highlightedNode = nil
                            }else {
                                if(self.highlightedNode != nil){
                                    self.highlightedNode?.dehighlight()
                                    self.highlightedNode?.stopBlink()
                                }
                                self.highlightedNode = tappedNode
                                self.highlightedNode?.highlight()
                                self.highlightedNode?.startBlinking()
                                self.Dier = (tappedNode?.name!.description)!
                            }
                            if(self.tutorialState == .animalPress){
                                self.tutorialDelegate?.getStepWithState(nextState: .microphonePress)
                                self.delegate?.onFinalmode()
                                self.completedWalkthroughInThisSession = true
                                UserDefaults.standard.set(true, forKey: "completedWalkthrough")
                            }
                        }
                    }
                }
            }
            break
        default:
            break;
        }
    }
    
    func updateState(){
        
        switch self.endNodeState {
        case .none:
            self.endNode?.removeFromParentNode()
            let zooNode = ZooNode(sceneName: self.scene)
            self.endNode = SCNNode()
            self.endNode?.addChildNode(zooNode)
            self.endNode?.position = self.focalNode!.position
            self.sceneView.scene.rootNode.addChildNode(self.endNode!)
            self.focalNode?.removeFromParentNode()
            self.endNodeState = .edit
            if(self.tutorialState == .placeFocalNode){
                let pichgesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
                sceneView.addGestureRecognizer(pichgesture)
                self.tutorialDelegate?.getStepWithState(nextState: .editPinch)
            }
            break;
        case .edit?:
            let base  = self.endNode?.childNode(withName: "baseNode", recursively: true) as! ZooNode
            let size = base.boundingBox
            let xSize = size.max.x - size.min.x
            let ySize = size.max.y - size.min.y
            let width = CGFloat(1.5)
            let plane = SCNPlane(width: CGFloat(xSize), height: CGFloat(ySize))
            plane.materials.first?.diffuse.contents = UIImage(named: "editAnchor")
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            planeNode.position = base.position
            planeNode.name = "indicator"
            
            self.endNode?.addChildNode(planeNode)
            base.setOpacity(opacity: 0.5)
            self.delegate?.onEditMode()
            break
        case .final?:
            self.endNode?.childNode(withName: "indicator", recursively: true)?.removeFromParentNode()
            let zooNode = self.endNode?.childNode(withName: "baseNode", recursively: true) as! ZooNode
            zooNode.setOpacity(opacity: 1)
            break
        case .changed?:
            
            break
        default: break
        }
    }
    
    @objc func viewPanned(_ gesture: UIPanGestureRecognizer){
        if(self.endNodeState == .edit){
            let location = gesture.location(in: sceneView)
            switch gesture.state {
            case .began:
                break
            case .changed:
                guard let result = sceneView.hitTest(location, types: .featurePoint).first else { return }

                let transform = result.worldTransform
                let newPosition = float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                let pos = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                endNode?.position = pos
            case .ended:
                if(self.tutorialState == .editMove){
                    self.tutorialDelegate?.getStepWithState(nextState: .editTap)
                }
                break
            default:
                print("in default")
            }
        }
    }
    
    @objc func viewRotated(_ gesture: UIRotationGestureRecognizer){
        if(self.endNodeState == .edit){
            switch gesture.state {
            case .began:
                originalRotation = endNode?.eulerAngles
            case .changed:
                guard var originalRotation = originalRotation else { return }
                originalRotation.y -= Float(gesture.rotation)
                endNode!.eulerAngles = originalRotation
            case .ended:
                if(self.tutorialState == .editRotate){
                    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewPanned))
                    sceneView.addGestureRecognizer(panGesture)
                    self.tutorialDelegate?.getStepWithState(nextState: .editMove)
                }
                break;
            default:
                originalRotation = nil
            }
        }
    }
    
    @objc func onLongPress(_ gesture: UILongPressGestureRecognizer){
        switch gesture.state {
        case .began:
            switch self.endNodeState {
            case .edit?:
                self.endNodeState = .final
                if(self.doneWalkthrough() || self.completedWalkthroughInThisSession){
                    self.delegate?.onFinalmode()
                }
                break
            case .final?:
                self.endNodeState = .edit
                break
            default: break
            }
        case .ended:
            if(self.tutorialState == .editLongPress){
                self.tutorialDelegate?.getStepWithState(nextState: .animalPress)
            }
        default:
            break
        }
        
    }
    
    @objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
        if(self.endNodeState == .edit){
            guard let _ = endNode else { return }
            var originalScale = endNode?.scale
            
            switch gesture.state {
            case .began:
                originalScale = endNode?.scale
                gesture.scale = CGFloat((endNode?.scale.x)!)
            case .changed:
                guard var newScale = originalScale else { return }
                if gesture.scale < 0.1{ newScale = SCNVector3(x: 0.1, y: 0.1, z: 0.1) }
                else if gesture.scale > 5{
                    newScale = SCNVector3(5, 5, 5)
                }else{
                    newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
                }
                endNode?.scale = newScale
            case .ended:
                guard var newScale = originalScale else { return }
                if gesture.scale < 0.1{ newScale = SCNVector3(x: 0.1, y: 0.1, z: 0.1) }else if gesture.scale > 5{
                    newScale = SCNVector3(5, 5, 5)
                }else{
                    newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
                }
                endNode?.scale = newScale
                gesture.scale = CGFloat((endNode?.scale.x)!)
                if(self.tutorialState == .editPinch){
                    let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(viewRotated))
                    sceneView.addGestureRecognizer(rotationGesture)
                    self.tutorialDelegate?.getStepWithState(nextState: .editRotate)
                    
                }
            default:
                gesture.scale = 1.0
                originalScale = nil
            }
        }
    }
    
    func removeScene(){
        self.endNode?.removeFromParentNode()
        self.endNode = nil
        self.endNodeState = .removed
        self.focalNode = FocalNode(sceneName: self.scene)
        sceneView.scene.rootNode.addChildNode(self.focalNode!)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard endNode == nil else { return }
        guard focalNode == nil else { return }
        
        let node = FocalNode(sceneName: self.scene)
       
        sceneView.scene.rootNode.addChildNode(node)
         if(self.tutorialState == .scan){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.tutorialDelegate?.getStepWithState(nextState: .placeFocalNode)
            }
            
            
        }
        
        self.anchor = anchor
        self.focalNode = node
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard endNode == nil else { return }
        guard let focalNode = focalNode else { return }
        let hit = sceneView.hitTest(screenCenter, types: [.featurePoint])
        guard let positionColumn = hit.first?.worldTransform.columns.3 else { return }
        focalNode.position = SCNVector3(x: positionColumn.x, y: positionColumn.y, z: positionColumn.z)
    }
}
