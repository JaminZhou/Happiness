//
//  FaceView.swift
//  Happiness
//
//  Created by JaminZhou on 14/11/16.
//  Copyright (c) 2014年 SMMOUS. All rights reserved.
//

import UIKit

protocol FaceViewDataSource {
    func smileForFaceView(sender:FaceView) -> Float;
}

@IBDesignable
class FaceView: UIView {
    
    let EYE_H: CGFloat = 0.35
    let EYE_V: CGFloat = 0.35
    let EYE_RADIUS: CGFloat = 0.10
    let MOUTH_H: CGFloat = 0.45
    let MOUTH_V: CGFloat = 0.40
    let MOUTH_SMILE: CGFloat = 0.25
    
    var datasourse: FaceViewDataSource?
    
    @IBInspectable
    var scale: CGFloat = 0.90 {
        willSet {
            if self.scale != newValue {
                self.scale = newValue
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable
    var storkeColor: UIColor = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func setup() {
        contentMode = UIViewContentMode.Redraw
    }
    
    override func awakeFromNib() {
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()
        
        var midPoint = CGPoint() // center of our bounds in our coordinate system
        midPoint.x = bounds.origin.x + bounds.size.width/2
        midPoint.y = bounds.origin.y + bounds.size.height/2
        
        var size = bounds.size.width/2
        if bounds.size.height < bounds.size.width {size = bounds.size.height/2}
        size *= scale // scale is percentage of full view size
        
        CGContextSetLineWidth(context, 5.0)
        storkeColor.setStroke()
        
        drawCircle(atPoint: midPoint, withRadius: size, inContext: context) // head
        
        var eyePoint = CGPoint()
        eyePoint.x = midPoint.x - size * EYE_H
        eyePoint.y = midPoint.y - size * EYE_V
        
        drawCircle(atPoint: eyePoint, withRadius: size * EYE_RADIUS, inContext: context) // left eye
        eyePoint.x += size * EYE_H * 2
        drawCircle(atPoint: eyePoint, withRadius: size * EYE_RADIUS, inContext: context) // right eye
        
        var mouthStart = CGPoint()
        mouthStart.x = midPoint.x - MOUTH_H * size
        mouthStart.y = midPoint.y + MOUTH_V * size
        var mouthEnd = mouthStart
        mouthEnd.x += MOUTH_H * size * 2
        var mouthCP1 = mouthStart
        mouthCP1.x += MOUTH_H * size * 2/3
        var mouthCP2 = mouthEnd
        mouthCP2.x -= MOUTH_H * size * 2/3
        
        var smile = datasourse?.smileForFaceView(self)
        if smile < -1 {smile = -1}
        if smile > 1 {smile = 1}
        
        var smileOffSet = MOUTH_SMILE * size * CGFloat(smile!)
        mouthCP1.y += smileOffSet
        mouthCP2.y += smileOffSet
        
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, mouthStart.x, mouthStart.y)
        CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y) // bezier curve
        CGContextStrokePath(context)
    }
    
    func drawCircle(atPoint p: CGPoint, withRadius radius: CGFloat, inContext context: CGContextRef) {
        UIGraphicsPushContext(context)
        CGContextBeginPath(context)
        CGContextAddArc(context, p.x, p.y, radius, 0, CGFloat(2*M_PI), 1) // 360 degree (0 to 2pi) arc
        CGContextStrokePath(context)
        UIGraphicsPopContext()
    }
    
    func pinch(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed || gesture.state == .Ended {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
}
