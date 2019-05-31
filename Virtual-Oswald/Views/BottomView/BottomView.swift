//View that works as a container for all the buttons at the bottom.
//This view includes the menu, audio and chatbutton.
//All delagate functions will be handeled in the MainViewController

import UIKit
import JJFloatingActionButton
import FontAwesome_swift

class BottomView: UIView, JJFloatingActionButtonDelegate{
    
    @IBOutlet weak var audioButton: AudioButton!
    @IBOutlet var contentView: UIView!
    let actionButton = JJFloatingActionButton()
    
    var delegate: BottomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("BottomView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addMenuFab()
        addChatFab()
        actionButton.delegate = self;
        audioButton.layer.cornerRadius = audioButton.frame.width / 2
    }
    
    //Function to add the menu button the the bottom view. This button will include subbuttons for every option that can be selected in the menu
    func addMenuFab(){
        let menuImage = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0), size: CGSize(width: 75, height: 75))
        
        actionButton.buttonColor = UIColor.white
        actionButton.buttonImage = menuImage
        
        let image = UIImage.fontAwesomeIcon(name: .home, style: .solid, textColor: UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0), size: CGSize(width: 75, height: 75))
        actionButton.addItem(title: "Home", image: image, action: {item in
            self.contentView.window?.rootViewController!.dismiss(animated: false, completion: nil)
        })
        
        let settingsImage = UIImage.fontAwesomeIcon(name: .tools, style: .solid, textColor: UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0), size: CGSize(width: 75, height: 75))
        actionButton.addItem(title: "Instellingen", image: settingsImage) { item in
            if let appSettings = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
        }
        let removeImage = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0), size: CGSize(width: 75, height: 75))
        actionButton.addItem(title: "Verwijder scene", image: removeImage, action: {item in
            self.delegate?.onRemoveButtonPressed()
            self.delegate?.onBottomViewShouldBeVisible(visible: false)
        })
        actionButton.configureDefaultItem { item in
            item.titlePosition = .trailing
        }
        actionButton.buttonDiameter = 0.10 * self.contentView.frame.width
        self.contentView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16).isActive = true
    }
    
    //Function to add the chat button the the bottom view. This button will show the chatview
    func addChatFab(){
        let chatBubble = UIImage.fontAwesomeIcon(name: .comments, style: .solid, textColor: UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0), size: CGSize(width: 75, height: 75))
        let actionButton = JJFloatingActionButton()
        actionButton.buttonColor = UIColor.white
        
        actionButton.addItem(title: "comments", image: chatBubble, action: { item in
            self.delegate?.onChatButtonPressed()
        })
        actionButton.buttonDiameter = 0.1 * self.contentView.frame.width
        self.contentView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16).isActive = true
    }
    
    //Function that will be called when the menubutton is pressed and it's state is closed
    func floatingActionButtonWillOpen(_ button: JJFloatingActionButton){
        self.delegate?.onFabOpenedDidChange(isOpen: true)
    }
    
    //Function that will be called when the menubutton is pressed and it's state is opened
    func floatingActionButtonWillClose(_ button: JJFloatingActionButton){
       self.delegate?.onFabOpenedDidChange(isOpen: false)
    }
}
