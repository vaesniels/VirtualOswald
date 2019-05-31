//
//  LoadingView.swift
//  Virtual-Oswald
//
//  Created by Yari Crollet on 07/05/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

@IBDesignable
class LoadingView: UIView {

     var view: UIView!
    var indicatorView: NVActivityIndicatorView!
    
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
        
        let indicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width / 2, height: self.view.frame.height / 2), type: .ballPulseSync, color:  UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0), padding: 0)
        indicator.center = self.view.center
        indicator.startAnimating()
        self.view.addSubview(indicator)
        self.indicatorView = indicator
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.indicatorView.center = self.view.center
    }

}
