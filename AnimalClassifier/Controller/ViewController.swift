//
//  ViewController.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 15.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Input
    
    // MARK: - Properties
    
    private var animalRecognitionRequest = VNRecognizeAnimalsRequest(completionHandler: nil)
    private let animalRecognitionWorkQueue = DispatchQueue(label: "PetClassifierRequest", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    // MARK: - Subview
    
    private lazy var animaleImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        image.image = #imageLiteral(resourceName: "cat-and-dog")
        image.contentMode = .scaleAspectFit
        
        return image
    }()

    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.text = "Hello World!"
        
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Выбрать изображение", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - View lifecycle
    
    override func loadView() {
        self.view = UIView()
        
        view.backgroundColor = .white
        view.addSubview(animaleImageView)
        view.addSubview(resultLabel)
        view.addSubview(checkButton)
        
        makeConstraints()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVision()
    }
    
    private func setupVision() {
        animalRecognitionRequest = VNRecognizeAnimalsRequest { (request, error) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    var detectionString = ""
                    var animalCount = 0
                    for result in results {
                        let animals = result.labels
                        for animal in animals {
                            animalCount = animalCount + 1
                            var animalLabel = ""
                            if animal.identifier == "Cat" {
                                animalLabel = "😸"
                            } else {
                                animalLabel = "🐶"
                            }
                            let string = "#\(animalCount) \(animal.identifier) \(animalLabel) confidence is \(animal.confidence)\n"
                            detectionString = detectionString + string
                        }
                    }
                    if detectionString.isEmpty {
                        detectionString = "Neither cat nor dog"
                    }
                    self.resultLabel.text = detectionString
                }
            }
        }
    }
    
    private func processImage(_ image: UIImage) {
        animaleImageView.image = image
        animalClassifier(image)
    }
    
    private func animalClassifier(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        animalRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.animalRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.animaleImageView.image = image
                self.processImage(image)
            }
        }
    }
    
}

// MARK: - Action

private extension ViewController {
    @objc
    func checkButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - Layout

private extension ViewController {
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            animaleImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            animaleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animaleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animaleImageView.heightAnchor.constraint(equalToConstant: 220),
            
            resultLabel.topAnchor.constraint(equalTo: animaleImageView.bottomAnchor, constant: 40),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            checkButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 100),
            checkButton.widthAnchor.constraint(equalToConstant: 180),
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

