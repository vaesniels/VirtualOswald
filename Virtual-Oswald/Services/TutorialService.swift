//
//  TutorialService.swift
//  Virtual-Oswald
//
//  Created by Yari Crollet on 30/04/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import Foundation
import FontAwesome_swift

class TutorialService {
    
    var steps: [TutorialStep]
    var delegate: TutorialDelegate?
    var index = 0
    
    init(){
        self.steps = [
            TutorialStep(text: "Scan de omgeving tot het 3D model zichtbaar is.", image: UIImage(named: "scanIcon")!, next: .scan),
            TutorialStep(text: "Gelukt! Klik nu op het scherm om het model te plaatsen.", image: UIImage(named: "tapIcon")!,next: .placeFocalNode),
            TutorialStep(text: "Nu kan je het model proberen te schalen.", image: UIImage(named: "pinchIcon")!, next: .editPinch),
            TutorialStep(text: "Schitterend! nu kan je het model draaien.", image: UIImage(named: "rotateIcon")! ,next: .editRotate),
            TutorialStep(text: "Probeer nu het model te verplaatsen.", image: UIImage(named: "moveIcon")!, next: .editMove),
            TutorialStep(text: "Je kan het model wijzigen door er op te drukken.", image: UIImage(named: "tapIcon")!, next: .editTap),
            TutorialStep(text: "Hou het scherm ingedrukt als het model naar wens is om het model vast te zetten.", image: UIImage(named: "tapIcon")!, next: .editLongPress),
            TutorialStep(text: "Het is mogelijk om op een dier in het model te drukken. Probeer het maar eens.", image: UIImage(named: "tapIcon")!, next: .animalPress),
            TutorialStep(text: "Goed gedaan!. Je weet nu alles, je kunt nu vragen stellen aan Oswald door op de microfoon knop te drukken.", image: UIImage.fontAwesomeIcon(name: .microphoneAlt , style: .solid, textColor: UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0), size: CGSize(width: 75, height: 75)), next: .microphonePress)
        ]
    }
    
    func getStepWithState(nextState: TutorialState) -> TutorialStep {
        for item in self.steps {
            if(nextState == item.next){
                self.delegate?.onStateChanged(state: item.next)
                return item
            }
        }
        return TutorialStep(text: "test", image: UIImage(named: "tapIcon")!, next: .finished)
    }
    
    func getNextStep() -> TutorialStep{
        var index = self.index
        self.index = self.index + 1
        let step = self.steps[index]
        self.delegate?.onStateChanged(state: step.next)
        return step
    }
}

class TutorialStep {
    var text: String
    var image: UIImage
    var next: TutorialState
    
    init(text: String , image: UIImage, next: TutorialState) {
        self.image = image
        self.text = text
        self.next = next
    }
}

enum TutorialState {
    case scan
    case placeFocalNode
    case editPinch
    case editRotate
    case editMove
    case editTap
    case editLongPress
    case animalPress
    case microphonePress
    case finished
}
