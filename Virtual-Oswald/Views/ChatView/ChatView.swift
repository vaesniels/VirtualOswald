//View that will be shown when the chat button is pressed

import UIKit

class ChatView: UIView, UITextFieldDelegate{
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    var delegate: ChatViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("ChatView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        self.textField!.delegate = self
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    //Function called when the 'send' button is pressed in the chatview.
    //It will call a delegate function to send the text from the textfield to Oswald
    @IBAction func onSendPress(_ sender: Any) {
        self.textField.resignFirstResponder()
        self.delegate?.onSendButtonPressed()
    }
    
    //Function called when the textfield is unfocused.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.text = ""
        self.textField.resignFirstResponder()
        return true
    }
}
