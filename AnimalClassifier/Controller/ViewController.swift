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
    
    private lazy var catAndDogImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        image.image = #imageLiteral(resourceName: "cat-and-dog-select-default")
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "plus-button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var selectedImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFit
        
        return image
    }()

    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 26, weight: .light)
        label.textColor = #colorLiteral(red: 0.7051772475, green: 0.4836726785, blue: 0.2945596576, alpha: 1)
        label.text = "Hello World!"
        
        return label
    }()
    
    // MARK: - View lifecycle
    
    override func loadView() {
        self.view = UIView()
        
        view.backgroundColor = .white
        
        view.addSubview(catAndDogImageView)
        view.addSubview(selectedImageView)
        view.addSubview(resultLabel)
        view.addSubview(addButton)
        
        makeConstraints()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.alpha = 0
        setupVision()
    }
    
    private func setupVision() {
        animalRecognitionRequest = VNRecognizeAnimalsRequest { (request, error) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    var detectionString = ""
                    for result in results {
                        let animals = result.labels
                        for animal in animals {
                            var animalLabel = ""
                            if animal.identifier == "Cat" {
                                animalLabel = "кот"
                                self.catAndDogImageView.image = #imageLiteral(resourceName: "cat-and-dog-select-cat")
                            } else {
                                animalLabel = "собака"
                                self.catAndDogImageView.image = #imageLiteral(resourceName: "cat-and-dog-select-dog")
                            }
                            // let string = "This is \(animal.identifier) \(animalLabel) confidence is \(animal.confidence)\n"
                            let string = "это \(animalLabel) "
                            detectionString = detectionString + string
                        }
                    }
                    
                    if detectionString.isEmpty {
                        detectionString = "Это не кот и не собака 💁‍♀️"
                    }

                    self.resultLabel.text = detectionString
                    self.resultLabel.alpha = 1
                }
            }
        }
    }
    
    func processImage(_ image: UIImage) {
        selectedImageView.image = image
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
                self.processImage(image)
            }
        }
    }
    
    private func mafeDefault() {
        catAndDogImageView.image = #imageLiteral(resourceName: "cat-and-dog-select-default")
        resultLabel.text = ""
        selectedImageView.image = nil
    }
}

// MARK: - Action

private extension ViewController {
    @objc
    func addButtonTapped() {
        mafeDefault()
        
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
            self?.libraryButtonTapped()
        }))
        alert.addAction(UIAlertAction(title: "Интернет", style: .default, handler: { [weak self] _ in
            self?.unsplashButtonTapped()
        }))
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            self?.cameraButtonTapped()
        }))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func libraryButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func unsplashButtonTapped() {
        let vc = PhotoCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationVC = UINavigationController(rootViewController: vc)
        present(navigationVC, animated: true, completion: nil)
    }
    
    func cameraButtonTapped() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: - Layout

private extension ViewController {
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.heightAnchor.constraint(equalToConstant: 20),
            
            catAndDogImageView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 0),
            catAndDogImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            catAndDogImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            catAndDogImageView.heightAnchor.constraint(equalToConstant: 220),
            
            selectedImageView.topAnchor.constraint(equalTo: catAndDogImageView.bottomAnchor, constant: 20),
            selectedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedImageView.heightAnchor.constraint(equalToConstant: 180),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 80),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor)
        ])
    }
}

