//
//  MakeGradient.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 01.12.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import AnimatedGradientView

extension UIViewController {
    func makeAnimatedGradient(alpha: CGFloat) -> AnimatedGradientView {
        let view = AnimatedGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = alpha
        view.animationDuration = 4
        view.direction = .up
        view.animationValues = [(colors: ["#4e26b5", "#d50f30"], .up, .axial),
                                (colors: ["#833ab4", "#1bd817"], .right, .axial),
                                (colors: ["#4e26b5", "#d50f30"], .down, .axial),
                                (colors: ["#0f3d9b", "#1bd817"], .left, .axial)]
        
        return view
    }
}
