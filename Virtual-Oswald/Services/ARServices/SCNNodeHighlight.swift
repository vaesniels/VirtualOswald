//
//  SCNNodeHighlight.swift
//  Virtual-Oswald
//
//  Created by Yari Crollet on 17/04/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import SceneKit

extension SCNNode {
    private static let highlightAnimationKey = "highlightAnimationKey"
    private static let dehighlightAnimationKey = "dehighlightAnimationKey"
    private static let highlightAnimationDuration = 0.15
    private static var blinker: Timer = Timer()
    private static var durationTimer: Timer = Timer()
    
    func highlight(glowIntensity: Double = 3.0, glowRadius: Double = 30.0) {
        addHighlightFilter(glowIntensity: glowIntensity, glowRadius: glowRadius)
        
        SCNTransaction.begin()
        let animation = CABasicAnimation(keyPath: "filters.highlightFilter.inputIntensity")
        animation.fromValue = 0.0
        animation.duration = SCNNode.highlightAnimationDuration
        SCNTransaction.completionBlock = {
            // We add the filter again in case it was removed by dehighlight at the same time
            self.addHighlightFilter(glowIntensity: glowIntensity, glowRadius: glowRadius)
        }
        self.addAnimation(animation, forKey: SCNNode.highlightAnimationKey)
        SCNTransaction.commit()
    }
    
    /**
     Removes the highlight fitler
     */
    func dehighlight() {
        if let highlightFilter = highlightFilter() {
            let currentIntensity = highlightFilter.inputIntensity!
            highlightFilter.setValue(NSNumber(floatLiteral: 0.0), forKey: "inputIntensity")
            SCNTransaction.begin()
            let animation = CABasicAnimation(keyPath: "filters.highlightFilter.inputIntensity")
            animation.fromValue = currentIntensity
            animation.duration = SCNNode.highlightAnimationDuration
            SCNTransaction.completionBlock = {
                self.removeHighlightFilter()
            }
            self.addAnimation(animation, forKey: SCNNode.dehighlightAnimationKey)
            SCNTransaction.commit()
        }
    }
    /**
     Add a new highlight fitler if none already exists
     */
    private func addHighlightFilter(glowIntensity: Double, glowRadius: Double) {
        if highlightFilterExist() { return }
        
        let newHighlightFilter = HighlightFilter()
        newHighlightFilter.name = HighlightFilter.filterName
        newHighlightFilter.setValue(NSNumber(floatLiteral: glowRadius), forKey: "inputRadius")
        newHighlightFilter.setValue(NSNumber(floatLiteral: glowIntensity), forKey: "inputIntensity")
        
        if self.filters != nil {
            self.filters?.append(newHighlightFilter)
        }
        else {
            self.filters = [newHighlightFilter]
        }
    }
    
    func startBlinking(){
        SCNNode.blinker = Timer.scheduledTimer(withTimeInterval: 0.2,  repeats: true) { (nil) in
            self.isHidden = !self.isHidden
        }
        SCNNode.durationTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (nil) in
            SCNNode.blinker.invalidate()
            SCNNode.durationTimer.invalidate()
            self.isHidden = false
        }
    }
    
    func stopBlink(){
        SCNNode.blinker.invalidate()
        SCNNode.durationTimer.invalidate()
        self.isHidden = false
    }
    
    private func removeHighlightFilter() {
        if let highlightFilterIndex = self.highlightFilterIndex() {
            self.filters?.remove(at: highlightFilterIndex)
        }
    }
    
    private func highlightFilter() -> HighlightFilter? {
        guard let highlightFilterIndex = highlightFilterIndex() else {
            return nil
        }
        return filters?[highlightFilterIndex] as? HighlightFilter
    }
    
    private func highlightFilterIndex() -> Int? {
        return filters?.map{$0.name}.index(of: HighlightFilter.filterName) ?? nil
    }
    
    private func highlightFilterExist() -> Bool {
        return filters?.map{$0.name}.contains(HighlightFilter.filterName) ?? false
    }
    
}

class HighlightFilter: CIFilter {
    
    static let filterName = "highlightFilter"
    
    @objc dynamic var inputImage: CIImage?
    @objc dynamic var inputIntensity: NSNumber?
    @objc dynamic var inputRadius: NSNumber?
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else {
            return nil
        }
        
        let bloomFilter = CIFilter(name:"CIBloom")!
        bloomFilter.setValue(inputImage, forKey: kCIInputImageKey)
        bloomFilter.setValue(inputIntensity, forKey: "inputIntensity")
        bloomFilter.setValue(inputRadius, forKey: "inputRadius")
        
        let sourceOverCompositing = CIFilter(name:"CISourceOverCompositing")!
        sourceOverCompositing.setValue(inputImage, forKey: "inputImage")
        sourceOverCompositing.setValue(bloomFilter.outputImage, forKey: "inputBackgroundImage")
        
        return sourceOverCompositing.outputImage
    }
}
