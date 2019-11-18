//
//  FaceTrackingViewController.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 17.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class FaceTrackingViewController: UIViewController, ARSCNViewDelegate {
    
    // MARK: - Subview
    
    private lazy var sceneView: ARSCNView = {
        let view = ARSCNView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - View lifecycle
    
    override func loadView() {
        self.view = UIView()
        
        view.addSubview(sceneView)
        makeConstraints()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .red
        sceneView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

// MARK: - Layout

private extension FaceTrackingViewController {
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
