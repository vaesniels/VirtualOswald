//
//  STTService.swift
//  Virtual-Oswald
//
//  Created by niels vaes on 06/03/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import Foundation
import Speech
import AVFoundation

class STTService{
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "nl-BE")) //1
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    public var audioEngine = AVAudioEngine()
    var timer: Timer?
    var topView: TopView?
    var player: AVAudioPlayer?
    var textResult: String = "" {
        didSet{
            delegate?.onSTTResultDidUpdate(result: "Uw vraag : \""+textResult+"\"")
        }
    }
    
    var delegate: STTDelegate?
    
    init(){
        speechRecognizer?.delegate = self as? SFSpeechRecognizerDelegate  //3
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "nl-BE"))
    }
    /*
    func stopRecording(){
        if audioEngine.isRunning {
            recognitionRequest?.endAudio()
            recognitionTask?.finish();
            //audioEngine.stop()
            print (self.textResult);
        }
        
    }*/
    
    func cancelRecording(){
        if audioEngine.isRunning {
            self.playSound()
            recognitionRequest?.endAudio()
            recognitionTask?.cancel();
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest = nil
            recognitionTask = nil
            self.timer?.invalidate()
        }
    }
    
    func getText() -> String {
        return self.textResult
    }

    /* This function will start the voice recognition task created by the 'prepare()' methode
     */
    func startRecording(lang: String){
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: lang))
        self.playSound()
            prepare();
            audioEngine.prepare()
            do {
                try audioEngine.start()
                
            } catch {
                print("audioEngine couldn't start because of an error.")
            }
  
    }
    
    /* This function will reset the 'SpeechTimer'
     */
    func restartSpeechTimer(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {(timer) in
            self.delegate?.onTimerExpired(result: self.textResult)
        })
    }
    
    /* The following function will create a task to recognize human voice and translate it to text, everytime a new input is detected and the result text is updated. The result is also send to the MainViewController with a dellegate. After the 'SpeechTimer' runs out this task will stop.
     */
    func prepare(){
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textResult = (result?.bestTranscription.formattedString)!;
                print(self.textResult)
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                print("final is reached")
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }else{
                self.restartSpeechTimer()
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "startRecording", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
