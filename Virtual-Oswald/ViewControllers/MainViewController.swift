//Mainviewcontroller that handles all functions of the delegates and combines all the subview
import Foundation
import UIKit
import ARKit
import JJFloatingActionButton
import FontAwesome_swift
import AVFoundation

class MainViewController: UIViewController {
    
    @IBOutlet weak var BViewHeightNormal: NSLayoutConstraint!
    @IBOutlet weak var chatViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: TopView!
    @IBOutlet weak var topImageView: TopImageView!
    @IBOutlet weak var quickReplyView: QuickReplyView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var chatView: ChatView!
    @IBOutlet weak var bottomView: BottomView!
    @IBOutlet weak var noWifiView: NoWifiView!
    @IBOutlet weak var tutorialView: TutorialView!
    
    var uiService = UIService();
    let httpService: HttpService = HttpService(Lang: "nl-BE")
    let ttsService: TTSService = TTSService()
    let tutorialService: TutorialService = TutorialService()
    var arService: ARService!
    var networkService: NetworkService!
    lazy var sttService: STTService = {
        let service = STTService()
        service.topView = topView
        return service
    }();
    var Dier = ""
    
    override func viewDidAppear(_ animated: Bool) {
        AppPermissions.shared().updateCameraPermissions();
        super.viewDidAppear(animated)
        if(!AppPermissions.shared().cameraPermission){
            print("toegang tot camera")
            self.present(uiService.createSettingsAlert(Title: "Toegang vereist", Message: "Om gebruik te maken van AR en dus om virtuele dieren te kunnen zien hebben wij toegang nodig tot uw camera"), animated: true, completion: nil)
        }
        else{
            print("geen toegang")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        arService = ARService(sceneView: self.sceneView)
        self.sttService.delegate = self
        self.topView.delegate = self
        self.quickReplyView.delegate = self
        self.bottomView.delegate = self
        self.bottomView.audioButton.delegate = self
        self.chatView.delegate = self
        self.arService.delegate = self
        self.arService.tutorialDelegate = self
        self.tutorialView.delegate = self
        self.tutorialService.delegate = self
        arService.viewDidLoad()
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        self.ttsService.setCurrentAudioDevice()
        AppPermissions.shared().updateCameraPermissions();
        AppPermissions.shared().updateSpeechRecognitionPermissions();
        AppPermissions.shared().updateMicrophonePermissions()
        self.arService.didntFoundAnimal = { animal in
            self.topView.setText(text: "Ik kon geen " + animal + " vinden op dit landschap")
            self.ttsService.speakText(text: "Ik kon geen " + animal + " vinden op dit landschap")
        }
        self.arService.closeTopview = {
            self.topView.close();
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arService.viewWillAppear()
        self.networkService = NetworkService.shared()
        self.networkService.delegate = self
    }
    
    //Function to close the chatview. It updates it updates its position and makes it invisible when the keyboard is dismissed
    @objc func keyboardWillBeHidden(note: Notification){
        self.chatViewBottomConstraint.constant = 0
        self.chatView.isHidden = true
    }
    
    //Function to show the chatview. It updates its position to the top of the keyboard when the keyboard is showed
    @objc func keyboardDidShow(notification : Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.chatViewBottomConstraint.constant = -keyboardHeight
        }
    }
    
    //Function to send the message to Oswald
    //This function handles the response received from Oswald as well with closure functions
    func sendMessage(text: String){
        if(text == ""){
            self.topView.close()
        }
        else{
            var httpRequest = self.httpService.getRequestForOswald()
            httpRequest = self.httpService.addMessageToRequest(httpRequest: httpRequest, text: text , Dier: self.arService.Dier)
            self.httpService.getRequest(request: httpRequest)
            self.bottomView.audioButton.reset()
            self.topImageView.isHidden = true
            self.topView.showLoadingView()
            self.quickReplyView.removeQuickReplies()
            self.httpService.didReceiveImage = { image, message in
                print("received image")
                if let data = try? Data(contentsOf: URL(string: image)!) {
                        if let imageData = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.topImageView.imageView.image = imageData
                                self.topImageView.isHidden = false
                                self.topView.setText(text: message)
                                self.ttsService.speakText(text: message)
                            }
                        }
                    }
            }
            self.httpService.didReceiveMessage = { message in
                DispatchQueue.main.async {
                    if(message == "Aw6tL4SVycR2KGXWAUkV"){
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let gameViewController = storyboard.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
                        self.sttService.cancelRecording()
                        self.topView.close()
                        self.present(gameViewController, animated: true, completion: nil)
                    }else{
                        if(message.contains("4cMKc9YFpxgulVmrXiwl")){
                            let submessage = message.substring(from: 20)
                            self.sttService.cancelRecording()
                            self.arService.ShowAllAnimals(animalType: submessage.lowercased())
                        }
                        else{
                            self.topView.setText(text: message)
                            self.ttsService.speakText(text: message)
                        }
                    }
                }
            }
            self.httpService.didReceiveQuickReplies = { quickreplies in
                DispatchQueue.main.async {
                    self.quickReplyView.addQuickReplies(quickReplies: quickreplies)
                    self.quickReplyView.isHidden = false
                }
            }
        }
    }
    
    //Function to indicate if you want to start or stop speaking
    func handleAudio(){
        self.ttsService.synth.stopSpeaking(at: .immediate)
        if(self.sttService.audioEngine.isRunning){
            self.sttService.cancelRecording()
            self.topView.close()
            self.bottomView.audioButton.reset()
        }else {
            self.sttService.startRecording(lang: "nl-BE")
            self.sttService.textResult = ""
            self.topImageView.isHidden = true
            self.quickReplyView.isHidden = true
            self.topView.setText(text: "Uw vraag : \"\"")
        }
    }
}


//All delegates handled bij the mainviewcontroller

extension MainViewController: STTDelegate{
    func onSTTResultDidUpdate(result: String) {
        self.topView.setText(text: result)
    }
    
    func onTimerExpired(result: String) {
        print("in timer delegate")
        self.sendMessage(text: result)
        self.sttService.cancelRecording()
    }
}

extension MainViewController: TopViewDelegate {
    func onTopViewDidClose() {
        self.quickReplyView.isHidden = true
        self.topImageView.isHidden = true
        self.sttService.cancelRecording()
        self.ttsService.synth.stopSpeaking(at: .immediate)
        self.bottomView.audioButton.reset()
    }
    
    func onQuickReplyTapped(message: String) {
        self.ttsService.synth.stopSpeaking(at: .immediate)
        self.sendMessage(text: message)
    }
}

extension MainViewController: BottomViewDelegate{
    
    func onFabOpenedDidChange(isOpen: Bool) {
        if(isOpen){
            BViewHeightNormal = MyConstraint.changeMultiplier(BViewHeightNormal, multiplier: 1)
        }else {
            BViewHeightNormal = MyConstraint.changeMultiplier(BViewHeightNormal, multiplier: 0.1)
        }
    }
    
    func onBottomViewShouldBeVisible(visible: Bool) {
        if(visible){
            self.bottomView.isHidden = false
        }else {
            self.bottomView.isHidden = true
        }
    }
    
    func onRemoveButtonPressed() {
        arService.removeScene()
    }
    
    func onChatButtonPressed(){
        self.chatView.isHidden = false
        self.chatView.textField.becomeFirstResponder()
    }
    
    func onAudioButtonPressed() {
        if(!AppPermissions.shared().microphonePermission || !AppPermissions.shared().speechPermission){
            self.present(uiService.createSettingsAlert(Title: "Toegang tot microfoon en spraakherkenning vereist", Message: "Om vragen aan Oswald te stellen heeft de applicatie toegang nodig tot uw microfoon en spraakherkenning."), animated: true, completion: nil)
        }
        else{
            self.topView.showView()
            
            self.handleAudio();
        }
    }
}

extension MainViewController: ChatViewDelegate{
    func onSendButtonPressed() {
        self.topView.showView()
        self.sendMessage(text: self.chatView.textField.text ?? "")
        self.chatView.textField.text = ""
    }
}


extension MainViewController: ARServiceDelegate{
    func onEditMode() {
        self.onBottomViewShouldBeVisible(visible: false)
    }
    
    func onFinalmode() {
        self.onBottomViewShouldBeVisible(visible: true)
    }
}

extension MainViewController: NetworkDelegate {
    func OnNetworkConnected(isConnected: Bool) {
        self.noWifiView.isHidden = isConnected
    }
}

extension MainViewController: TutorialDelegate {
    
    func getStepWithState(nextState: TutorialState) {
            let step: TutorialStep = self.tutorialService.getStepWithState(nextState: nextState)
            self.tutorialView.image.image = step.image
            self.tutorialView.text.text = step.text
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7){
            self.tutorialView.isHidden = false
        }
    }
    
    func OnGoToNextStep() {
        let step: TutorialStep = self.tutorialService.getNextStep()
        self.tutorialView.image.image = step.image
        self.tutorialView.text.text = step.text
        self.tutorialView.isHidden = false
    }
    
    func OnViewShouldDissapear() {
        self.tutorialView.isHidden = true
        self.sttService.cancelRecording()
        self.ttsService.synth.stopSpeaking(at: .immediate)
        
    }
    
    func onStateChanged(state: TutorialState) {
        self.arService.tutorialState = state
    }
}
