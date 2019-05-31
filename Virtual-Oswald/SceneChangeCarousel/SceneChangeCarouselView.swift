//
//  SceneChageCarouselView.swift
//  Virtual-Oswald
//
//  Created by Yari Crollet on 02/04/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import UIKit

class SceneChageCarouselView: UIView {
    
    var imageArray = ["forestZoo","savane"]
    var delegate: SceneChangeCarouselDelegate?
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var carousel: iCarousel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("SceneChangeCarouselView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        carousel.type = .coverFlow
        carousel.contentMode = .scaleAspectFit
        carousel.isPagingEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onBackdropPressed))
        self.contentView.addGestureRecognizer(tap)
    }
    
    @objc func onBackdropPressed(){
        self.delegate?.onBackDropPress()
    }
    
    @objc func onImageTapped(gesture: UIGestureRecognizer){
        self.delegate?.onSceneSelected(name: imageArray[gesture.view!.tag])
    }

}

extension SceneChageCarouselView: iCarouselDataSource, iCarouselDelegate {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return imageArray.count
    }
    
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var imageView: UIImageView!
        if view == nil {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.carousel.frame.height, height: self.carousel.frame.height))
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView = view as? UIImageView
        }
        imageView.image = UIImage(named: imageArray[index])
        imageView.layer.backgroundColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0).cgColor
        imageView.layer.cornerRadius = 10
        
        imageView.isUserInteractionEnabled = true
        imageView.tag = index
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: #selector(onImageTapped))
        imageView.addGestureRecognizer(tapRec)
        
        return imageView
    }

}
