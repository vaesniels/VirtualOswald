//
//  BottomView.swift
//  BottomSwipe
//
//  Created by Yari Crollet on 19/03/2019.
//  Copyright © 2019 Yari Crollet. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class BottomView {
    
    var superView: UIView!
    var bottomView: UIView!
    public var bottomConstraint: NSLayoutConstraint!
    var smallMenuConstraint: NSLayoutConstraint!
    var isHidden: Bool = false
    
    
    init(superView: UIView){
        self.superView = superView
    }
    
    func makeBottomView() -> UIView{
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        self.superView.addSubview(view)
        
        self.bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: view.superview, attribute: .bottom, multiplier: 1, constant: -40)
        self.superView.addConstraint(self.bottomConstraint)
        self.superView.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview, attribute: .centerX, multiplier: 1, constant: 0))
        self.superView.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view.superview, attribute: .width, multiplier: 0.95, constant: 0))
        self.superView.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: view.superview, attribute: .height, multiplier: 0.12, constant: 0))
        self.bottomView = view
        return view
    }
    
    func makeSmallMenu(){
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage.fontAwesomeIcon(name: .bars, style: .solid, textColor: UIColor.white, size: CGSize(width: superView.frame.width * 0.1, height: superView.frame.width * 0.1)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.3
        button.backgroundColor = UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0)
        button.layer.cornerRadius = superView.frame.width * 0.15 / 2
        superView.addSubview(button)
        
        let smallMenuConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: button.superview, attribute: .leading, multiplier: 1, constant: -( 20 + self.superView.frame.width * 0.15))
        superView.addConstraint(smallMenuConstraint)
        self.smallMenuConstraint = smallMenuConstraint
        
        superView.addConstraint(NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: button.superview, attribute: .bottom, multiplier: 1, constant: -20))
        superView.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: button.superview, attribute: .width, multiplier: 0.15, constant: 0))
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1/1, constant: 0))
        
        button.addTarget(self, action: #selector(smallMenuPressed(sender:)), for: .touchUpInside)
    }
    
    func makeHomeButton(superView: UIView) -> UIButton{
        let button: UIButton = UIButton(type: .custom)
        let image = UIImage.fontAwesomeIcon(name: .home, style: .solid, textColor: UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0), size: CGSize(width: superView.frame.height * 0.75, height: superView.frame.height * 0.75))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(button)
        superView.addConstraint(NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: button.superview, attribute: .leading, multiplier: 1, constant: self.superView.frame.width * 0.95 / 7.5))
        superView.addConstraint(NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: button.superview, attribute: .centerY, multiplier: 1, constant: 0))
        superView.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: button.superview, attribute: .height, multiplier: 0.5, constant: 0))
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: button, attribute: .height, multiplier: 1/1, constant: 0))
        return button
    }
    
    func makeOswaldButton(superView: UIView) -> UIButton{
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage.fontAwesomeIcon(name: .microphone, style: .solid, textColor: UIColor.white, size: CGSize(width: superView.frame.height * 0.8, height: superView.frame.height * 0.8)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.3
        button.backgroundColor = UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0)
        button.layer.cornerRadius = superView.frame.height / 2
        superView.addSubview(button)
        superView.addConstraint(NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: button.superview, attribute: .centerY, multiplier: 1, constant: 0))
        superView.addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: button.superview, attribute: .centerX, multiplier: 1, constant: 0))
        superView.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: button.superview, attribute: .height, multiplier: 1, constant: 0))
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: button, attribute: .height, multiplier: 1/1, constant: 0))
        return button
    }
    
    func makeChatButton(superView: UIView) -> UIButton{
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage.fontAwesomeIcon(name: .comments, style: .solid, textColor: UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0), size: CGSize(width: superView.frame.height * 0.75, height: superView.frame.height * 0.75)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(button)
        
        superView.addConstraint(NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: button.superview, attribute: .trailing, multiplier: 1, constant: -self.superView.frame.width * 0.95 / 7.5))
        superView.addConstraint(NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: button.superview, attribute: .centerY, multiplier: 1, constant: 0))
        superView.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: button.superview, attribute: .height, multiplier: 0.5, constant: 0))
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1/1, constant: 0))
        
        return button
    }
    
    func slideOut(){
            UIView.animate(withDuration: 0.5, delay: 0,
                options: .curveEaseInOut ,
                animations: {
                    self.bottomConstraint.constant =  40 + 0.12 * self.superView.frame.height
                    self.superView.layoutIfNeeded()
                    self.isHidden = !self.isHidden
                },
                completion: { (value: Bool) in
                    UIView.animate(withDuration: 0.5, delay: 0,
                    options: .curveEaseInOut ,
                        animations: {
                        self.smallMenuConstraint.constant =  20
                        self.superView.layoutIfNeeded()
                    },
                    completion: nil
                    )
                }
            )
    }
    
    func slideIn(){
        UIView.animate(withDuration: 0.5, delay: 0,
            options: .curveEaseInOut ,
            animations: {
                self.smallMenuConstraint.constant =  -( 20 +  self.superView.frame.width * 0.15)
                self.superView.layoutIfNeeded()
            },
            completion: { (value: Bool) in
                UIView.animate(withDuration: 0.5, delay: 0,
                   options: .curveEaseInOut ,
                   animations: {
                    self.bottomConstraint.constant =  -40
                    self.superView.layoutIfNeeded()
                    self.isHidden = !self.isHidden
                },
                   completion: nil
                )
            }
        )
    }
    
    @objc func smallMenuPressed(sender: UIButton){
        slideIn()
    }
    
}
