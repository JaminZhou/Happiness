//
//  ViewController.swift
//  Happiness
//
//  Created by JaminZhou on 14/11/16.
//  Copyright (c) 2014年 SMMOUS. All rights reserved.
//

import UIKit

class ViewController: UIViewController,FaceViewDataSource {
    
    @IBOutlet weak var faceView: FaceView! {
        willSet {
            self.faceView = newValue
            self.faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: self.faceView, action: Selector("pinch:")))
            self.faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: Selector("handleHappinessGesture:")))
            self.faceView.datasourse = self
        }
    }
    
    var happiness: Int! {
        didSet {
            faceView.setNeedsDisplay()
        }
    }
    
    func handleHappinessGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Changed || gesture.state == .Ended {
            var translation = gesture.translationInView(faceView)
            happiness = happiness - Int(translation.y/2)
            gesture.setTranslation(CGPointZero, inView: faceView)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        happiness = 100
    }
    
    func smileForFaceView(sender: FaceView) -> Float {
        return Float(happiness-50)/50.0
    }
}

