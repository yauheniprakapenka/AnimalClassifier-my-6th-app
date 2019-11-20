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

class FaceTrackingViewController: UIViewController {
    
    // MARK: - Input
    var planes = [Plane]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        let scene = SCNScene()
        sceneView.scene = scene
        
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func setupGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(placeBox))
        tapGestureRecognizer.numberOfTouchesRequired = 1
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func placeBox(tapGesure: UITapGestureRecognizer) {
        let sceneView = tapGesure.view as! ARSCNView
        let location = tapGesure.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        guard let hitResult = hitTestResult.first else { return }
        
        createBox(hitResult: hitResult)
    }
    
    func createBox(hitResult: ARHitTestResult) {
        let position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                  hitResult.worldTransform.columns.3.y + 0.05 + 0.5,
                                  hitResult.worldTransform.columns.3.z)
        let box = Box(atPosition: position)
        sceneView.scene.rootNode.addChildNode(box)
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

// MARK: - ARSCNViewDelegate

extension FaceTrackingViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        let plane = Plane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
        }.first
        
        guard plane != nil else { return }
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
}
