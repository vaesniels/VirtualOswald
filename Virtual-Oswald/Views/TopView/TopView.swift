//View that is used as a container for the message that is received from Oswald.
//This view includes the quickreplies, message and image received from Oswald
import UIKit

class TopView: UIView {
    
    var delegate: TopViewDelegate?
    
    @IBOutlet weak var text: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var loadingView: LoadingView!
    var quickReplyView: UIView!
    var correctPosition: CGFloat?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("TopView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        swipe.direction = .up
        self.contentView.addGestureRecognizer(swipe)
        correctPosition = self.frame.origin.y;
        self.text.isHidden = true
        self.loadingView.isHidden = true
        self.contentView.clipsToBounds = true
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //Function that will be called when you swipe up in the topview.
    @objc func closeView(gesture: UISwipeGestureRecognizer) {
        if(gesture.direction == .up){
            self.close()
        }
    }
    
    //Function to close the topview
    func close(){
        self.delegate?.onTopViewDidClose()
        UIView.animate(withDuration: 0.5, animations: {
            self.frame.origin.y -= (UIScreen.main.bounds.height * 0.1 + self.contentView.frame.size.height)
        },completion: { (value: Bool) in })
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { (value: Bool) in
            self.frame.origin.y = self.correctPosition!
            self.setText(text: "")
            self.isHidden = true
        })
    }
    
    //Function to show the topview
    func showView(){
        if(self.isHidden){
            self.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 1
            }, completion: nil)
        }
    }
    
    func setText(text: String){
        self.loadingView.isHidden = true
        self.text.isHidden = false
        self.text.text = text;
    }
    
    func showLoadingView(){
        self.text.isHidden = true
        self.loadingView.isHidden = false
    }
}
