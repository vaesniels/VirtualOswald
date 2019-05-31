//
//  BorderLayer.swift
//  AudioButton
//
//  Created by Yari Crollet on 07/05/2019.
//  Copyright © 2019 Yari Crollet. All rights reserved.
//

import UIKit

class BorderLayer: CALayer {
    
    var lineColor: CGColor = UIColor(red:0.96, green:0.57, blue:0.12, alpha:1.0).cgColor
    var lineWidth: CGFloat = 2.0
    var startAngle: CGFloat = 0.0
    @NSManaged var endAngle: CGFloat
    
    override func draw(in ctx: CGContext) {
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        ctx.beginPath()
        ctx.setStrokeColor(lineColor)
        ctx.setLineWidth(lineWidth)
        ctx.addArc(
            center: center,
            radius: bounds.height/2 - lineWidth / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        ctx.drawPath(using: .stroke)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.endAngle = 0.0
    }
}
