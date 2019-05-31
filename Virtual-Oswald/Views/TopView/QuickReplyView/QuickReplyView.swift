//View made to show the quickreplies in the topview
import UIKit

class QuickReplyView: UIView {
    
    var delegate: TopViewDelegate?
    
    @IBOutlet var contentView: UIView!
    var currentQuickReplies: [QuickReply]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("QuickReplyView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    //Function to add the quickreplies to the topview
    func addQuickReplies(quickReplies: [QuickReply]){
        self.currentQuickReplies = quickReplies
         let w = self.contentView.frame.width / CGFloat(quickReplies.count)
         let h = self.contentView.frame.height
         for i in 0...quickReplies.count - 1 {
         let view = UIView(frame: CGRect(x: CGFloat(w * CGFloat(i)), y: CGFloat(0), width: w, height: h))
         view.isUserInteractionEnabled = true
         let button = UIButton(frame: CGRect(x: (view.frame.width * 0.05), y: (view.frame.height * 0.1), width: view.frame.width * 0.9, height: view.frame.height * 0.8))
         button.setTitle(quickReplies[i].title, for: .normal)
         button.titleLabel?.font = UIFont(name: "Poppins", size: 12)
         button.layer.cornerRadius = 20
         button.backgroundColor =  UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0)
         button.tag = i
         button.addTarget(self, action: #selector(onQuickReplyTapped), for: .touchUpInside)
         button.isUserInteractionEnabled = true
         view.addSubview(button)
         self.contentView.addSubview(view)
         }
    }
    
    //Function called when the quickreply is tapped
    @objc func onQuickReplyTapped(sender: UIButton!){
        self.delegate?.onQuickReplyTapped(message: self.currentQuickReplies[sender.tag].text)
    }
    
    //Function to remove the quickreplies from the topview. This will be called when a new request is sent to Oswald
    func removeQuickReplies(){
        for i in self.contentView.subviews {
            i.removeFromSuperview()
        }
    }
}
