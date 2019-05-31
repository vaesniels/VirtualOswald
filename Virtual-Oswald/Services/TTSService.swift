//
//  TTSService.swift
//  Virtual-Oswald
//
//  Created by Yari Crollet on 12/03/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import Foundation
import Speech
import AVFoundation


class TTSService {
    var lang: String = "nl-BE"
    let synth = AVSpeechSynthesizer()
    var audioSession = AVAudioSession.sharedInstance()
    
    init(){
    }
    
    /* This function will check if headphones are connected to the device and set the audio output accordingly
    */
    func setCurrentAudioDevice(){
        let currentRoute = audioSession.currentRoute
        if currentRoute.outputs.count != 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSession.Port.headphones {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
                        print("headphones are plugged in")
                    } catch _ {
                        print("error gaat standaard speakers gebruiken")
                    }
                } else {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                        print("headphones are plugged out")
                    } catch _ {
                        print("error gaat standaard speakers gebruiken")
                    }
                    
                }
            }
        }
    }

    func speakText(text: String){
        self.setCurrentAudioDevice()
        let utterance = AVSpeechUtterance(string: text)
        utterance.pitchMultiplier = SettingsService.shared().pitchValue
        utterance.rate = SettingsService.shared().speechRate
        utterance.voice = AVSpeechSynthesisVoice(language: lang)
        self.synth.speak(utterance)
        
    }
}
