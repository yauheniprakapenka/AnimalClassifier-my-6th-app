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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        let scene = SCNScene()
        
        createBox(in: scene)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(boxTapped(touch:)))
        self.sceneView.addGestureRecognizer(gestureRecognizer)
        
        sceneView.scene = scene
    }
    
    @objc func boxTapped(touch: UITapGestureRecognizer) {
        let sceneView = touch.view as! SCNView
        let touchLocation = touch.location(in: sceneView)
        let touchResults = sceneView.hitTest(touchLocation, options: [:])
        guard !touchResults.isEmpty, let node = touchResults.first?.node else { return }
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor.white
        boxMaterial.specular.contents = UIColor.red
        node.geometry?.materials[0] = boxMaterial
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

// Action

private extension FaceTrackingViewController {
    
    private func createSphere(in scene: SCNScene) {
        let sphereGeometry = SCNSphere(radius: 0.1)
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIImage(named: "555.jpg")
        // sphereMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(2, 2, 2) - изменить размер текстуры, здесь уменьшили в 2 раза
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.geometry?.materials = [sphereMaterial]
        sphereNode.position = SCNVector3(0, 0, -0.7)
        
        scene.rootNode.addChildNode(sphereNode)
    }
    
    private func createText(in scene: SCNScene) {
        // Текст
        let textGeometry = SCNText(string: "Slipknot", extrusionDepth: 2.0)
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor.red
        let textNode = SCNNode(geometry: textGeometry)
        textNode.scale = SCNVector3(0.005, 0.005, 0.005)
        textNode.geometry?.materials = [textMaterial]
        textNode.position = SCNVector3(0, 0.2, -1.0)
        
        scene.rootNode.addChildNode(textNode)
    }
    
    private func createFigures(in scene: SCNScene) {
        let array: [SCNGeometry] = [SCNPlane(), SCNSphere(), SCNBox(), SCNPyramid(), SCNTube(), SCNCone(), SCNTorus(), SCNCylinder(), SCNCapsule()]
        var xCoordinate: Double = 1
        
        for geometryShape in array {
            let node = SCNNode(geometry: geometryShape)
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            
            node.geometry?.materials = [material]
            node.scale = SCNVector3(0.1, 0.1, 0.1)
            
            node.position = SCNVector3(xCoordinate, 0, -1)
            xCoordinate -= 0.2
            
            scene.rootNode.addChildNode(node)
        }
    }
    
    private func createBox(in scene: SCNScene) {
        // Квадрат
        let boxGeometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor.brown
        boxMaterial.specular.contents = UIColor.yellow
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.geometry?.materials = [boxMaterial]
        boxNode.position = SCNVector3(0, 0, -1.0)
        
        scene.rootNode.addChildNode(boxNode)
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
