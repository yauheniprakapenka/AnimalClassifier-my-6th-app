//
//  Shake.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 29.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.3
        animation.values = [-6.0, 6.0, -6.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
}
