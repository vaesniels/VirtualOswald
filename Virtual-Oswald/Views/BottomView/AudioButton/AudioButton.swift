//View made for the audiobutton.
import Foundation
import UIKit
import FontAwesome_swift
import NVActivityIndicatorView

class AudioButton: UIView {
    var view: UIView!
    var indicatorView: NVActivityIndicatorView!
    
    var delegate: BottomViewDelegate?
    var isListening: Bool =  false
    @IBOutlet weak var imageView: UIImageView!
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        self.view = view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onAudioTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.view.layer.cornerRadius = self.view.frame.width / 2
        let audio = UIImage.fontAwesomeIcon(name: .microphoneAlt , style: .solid, textColor: UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0), size: CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.width * 0.9))
        self.imageView.image = audio
        let indicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width / 2, height: self.view.frame.height / 2), type: .lineScalePulseOutRapid, color: .white, padding: 0)
        indicator.center = self.view.center
        indicator.startAnimating()
        indicator.isHidden = true
        self.view.addSubview(indicator)
        self.indicatorView = indicator
    }
    
    //Function that will be called when the audio button is tapped
    @objc func onAudioTap(){
        self.isListening = true
        let bgColor: UIColor = UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0)
        self.imageView.isHidden = true
        self.indicatorView.isHidden = false
        self.view.backgroundColor = bgColor
        self.delegate?.onAudioButtonPressed()
    }
    
    //Function that will be called when the audio button needs to be reset (after speaking or canceling)
    func reset(){
        self.isListening = false
        let bgColor: UIColor = UIColor.white
        self.indicatorView.isHidden = true
        self.imageView.isHidden = false
        self.view.backgroundColor = bgColor
    }
}
