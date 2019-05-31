//
//  AppPermissions.swift
//  Virtual-Oswald
//
//  Created by niels vaes on 25/03/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import Foundation
import AVFoundation
import Speech

class AppPermissions{
    
    var speechPermission = false;
    var cameraPermission = false;
    var microphonePermission = false;
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    // Gets the permissions for the Camera
    func updateCameraPermissions(){
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case AVAuthorizationStatus.authorized:
            print(" acces to camera ")
            self.cameraPermission =  true
        case AVAuthorizationStatus.notDetermined:
            self.cameraPermission = true
        case AVAuthorizationStatus.denied:
            self.cameraPermission = false
        case .restricted:
            self.cameraPermission = false
        }
    }
    
    // Gets the permissions for the Microphone
    func updateMicrophonePermissions(){
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print("Permission granted")
            self.microphonePermission =  true
        case AVAudioSession.RecordPermission.denied:
            print("Pemission denied")
            self.microphonePermission =  false
        case AVAudioSession.RecordPermission.undetermined:
            print("Request permission here")
            self.microphonePermission =  true
        }
    }
    
    // Gets the permissions for speech recognition
    func updateSpeechRecognitionPermissions(){
               
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                
                switch authStatus {
                case .authorized: print("acces to speech")
                    self.speechPermission = true
                case .denied: print(" no acces to speech")
                    self.speechPermission = false
                case .restricted: print(" no acces to speech")
                    self.speechPermission = false
                case .notDetermined: print(" no acces to speech")
                    self.speechPermission = true
                }
            }
        }
    }
    
    private static var sharedappPermissions: AppPermissions = {
        let appPermissions = AppPermissions();
        return appPermissions
    }()
    
    class func shared() -> AppPermissions {
        return sharedappPermissions
    }
    
}

