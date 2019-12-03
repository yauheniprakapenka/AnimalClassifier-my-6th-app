//
//  AirplaneAndRobotViewController.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 23.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit
import RealityKit

class AirplaneAndRobotViewController: UIViewController {
    
    // MARK: - Properties
    
    var roboAnchor: RoboMan.RoboAdventure!
    
    // MARK: - Sublayer
    
    private lazy var arView: ARView = {
        let view = ARView(frame: UIScreen.main.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(arView)

        roboAnchor = try! RoboMan.loadRoboAdventure()
        roboAnchor.generateCollisionShapes(recursive: true)
        arView.scene.anchors.append(roboAnchor)
    }
}

// MARK: - Layout

private extension AirplaneAndRobotViewController {
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
