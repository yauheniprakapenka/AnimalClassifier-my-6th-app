//
//  BoosterViewController.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 25.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit
import AnimatedGradientView

class BoosterViewController: UIViewController {
    
    // MARK: - Properties
    
    private var randomNumber: Int?
    
    private var leftCardIsOpen = true
    private var centerCardIsOpen = true
    private var rightCardIsOpen = true
    
    private let winImage = #imageLiteral(resourceName: "card-back-prize")
    private let loseImage = #imageLiteral(resourceName: "card-front")
    private let backsideImage = #imageLiteral(resourceName: "card-back")
    
    // MARK: - Subview
    
    private lazy var leftBoosterButton: UIButton = makeButton(withImage: #imageLiteral(resourceName: "card-back"))
    private lazy var centerBoosterButton: UIButton = makeButton(withImage: #imageLiteral(resourceName: "card-back"))
    private lazy var rightBoosterButton: UIButton = makeButton(withImage: #imageLiteral(resourceName: "card-back"))
    
    private lazy var okButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Продложить", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var backbutton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "button-back"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var boosterStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        return stack
    }()
    
    private lazy var backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "background-booster")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var selectCardView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "selectCardView")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var animatedGradientView: AnimatedGradientView = {
        let view = AnimatedGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.animationDuration = 4
        view.direction = .up
        view.animationValues = [(colors: ["#4e26b5", "#d50f30"], .up, .axial),
                                (colors: ["#833ab4", "#1bd817"], .right, .axial),
                                (colors: ["#4e26b5", "#d50f30"], .down, .axial),
                                (colors: ["#0f3d9b", "#1bd817"], .left, .axial)]
        
        return view
    }()
    
    // MARK: - View lifecycle
    
    override func loadView() {
        self.view = UIView()
        
        view.backgroundColor = .white
        
        view.addSubview(backgroundView)
        view.addSubview(animatedGradientView)
        view.addSubview(boosterStackView)
        view.addSubview(resultLabel)
        view.addSubview(okButton)
        view.addSubview(backbutton)
        view.addSubview(selectCardView)
        
        boosterStackView.addArrangedSubview(leftBoosterButton)
        boosterStackView.addArrangedSubview(centerBoosterButton)
        boosterStackView.addArrangedSubview(rightBoosterButton)
        
        makeConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateRandomNumber()
        
        displayResultLabel()
        
        animatedGradientView.alpha = 0.5
        
        leftBoosterButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        centerBoosterButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        rightBoosterButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Layout

private extension BoosterViewController {
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            animatedGradientView.topAnchor.constraint(equalTo: view.topAnchor),
            animatedGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animatedGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animatedGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            boosterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boosterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            boosterStackView.heightAnchor.constraint(equalToConstant: 200),
            boosterStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            resultLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.heightAnchor.constraint(equalToConstant: 20),
            
            okButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            okButton.heightAnchor.constraint(equalToConstant: 60),
            
            backbutton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            backbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            backbutton.heightAnchor.constraint(equalToConstant: 60),
            backbutton.widthAnchor.constraint(equalToConstant: 60),
            
            selectCardView.bottomAnchor.constraint(equalTo: boosterStackView.topAnchor, constant: -40),
            selectCardView.heightAnchor.constraint(equalToConstant: 70),
            selectCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

private extension BoosterViewController {
    
    func makeButton(withImage image: UIImage) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }
}

private extension BoosterViewController {
    
    // MARK: - Action
    
    @objc
    func leftButtonTapped() {
        let buttonCardID = 1
        var foregroundCardImage: UIImage?
        var cardSideImage: UIImage?
        
        foregroundCardImage = buttonCardID == randomNumber ? winImage : loseImage
        
        cardSideImage = leftCardIsOpen ? foregroundCardImage : backsideImage
        leftBoosterButton.setImage(cardSideImage, for: .normal)
        
        leftCardIsOpen = centerCardIsOpen ? false : true
        
        UIView.transition(with: leftBoosterButton, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    @objc
    func centerButtonTapped() {
        let buttonCardID = 2
        var foregroundCardImage: UIImage?
        var cardSideImage: UIImage?
        
        foregroundCardImage = buttonCardID == randomNumber ? winImage : loseImage
        
        cardSideImage = centerCardIsOpen ? foregroundCardImage : backsideImage
        centerBoosterButton.setImage(cardSideImage, for: .normal)
        
        centerCardIsOpen = centerCardIsOpen ? false : true
        
        UIView.transition(with: centerBoosterButton, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    @objc
    func rightButtonTapped() {
        let buttonCardID = 3
        var foregroundCardImage: UIImage?
        var cardSideImage: UIImage?
        
        foregroundCardImage = buttonCardID == randomNumber ? winImage : loseImage
        
        cardSideImage = rightCardIsOpen ? foregroundCardImage : backsideImage
        rightBoosterButton.setImage(cardSideImage, for: .normal)
        
        rightCardIsOpen = rightCardIsOpen ? false : true
        
        UIView.transition(with: rightBoosterButton, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    @objc
    func okButtonTapped() {
        if leftCardIsOpen == false {
            leftBoosterButton.setImage(backsideImage, for: .normal)
            UIView.transition(with: leftBoosterButton, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            leftCardIsOpen = true
        }
        
        if centerCardIsOpen == false {
            centerBoosterButton.setImage(backsideImage, for: .normal)
            UIView.transition(with: centerBoosterButton, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            centerCardIsOpen = true
        }
        
        if rightCardIsOpen == false {
            rightBoosterButton.setImage(backsideImage, for: .normal)
            UIView.transition(with: rightBoosterButton, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            rightCardIsOpen = true
        }
        
        generateRandomNumber()
        displayResultLabel()
    }

    @objc
    func backbuttonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func generateRandomNumber() {
        randomNumber = Int.random(in: 1..<4)
    }
    
    private func displayResultLabel() {
        resultLabel.text = "Загадана карта: \(randomNumber ?? 0)"
    }
}

