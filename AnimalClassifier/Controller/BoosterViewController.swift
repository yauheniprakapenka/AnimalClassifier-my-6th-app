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
    
    private let goldImage = #imageLiteral(resourceName: "card-gold")
    private let silverImage = #imageLiteral(resourceName: "card-silver")
    private let backsideImage = #imageLiteral(resourceName: "card-back")
    
    // MARK: - Subview
    
    private lazy var leftBoosterButton: UIButton = makeButton(withImage: #imageLiteral(resourceName: "card-back"))
    private lazy var centerBoosterButton: UIButton = makeButton(withImage: #imageLiteral(resourceName: "card-back"))
    private lazy var rightBoosterButton: UIButton = makeButton(withImage: #imageLiteral(resourceName: "card-back"))
    
    private lazy var getRewardButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        button.setTitle("Назад", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(GetRewardButtonTapped), for: .touchUpInside)
        
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
    
    private lazy var randomNumberForDebugLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "\(GlobalSetting.money)"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var animatedGradientView: AnimatedGradientView = makeAnimatedGradient(alpha: 0.5)
    
    // MARK: - View lifecycle
    
    override func loadView() {
        self.view = UIView()
        
        view.backgroundColor = .white
        
        view.addSubview(backgroundView)
        view.addSubview(animatedGradientView)
        view.addSubview(boosterStackView)
        view.addSubview(randomNumberForDebugLabel)
        view.addSubview(getRewardButton)
        view.addSubview(selectCardView)
        view.addSubview(moneyLabel)
        
        boosterStackView.addArrangedSubview(leftBoosterButton)
        boosterStackView.addArrangedSubview(centerBoosterButton)
        boosterStackView.addArrangedSubview(rightBoosterButton)
        
        makeConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateRandomNumber()
        
        displayResultLabel()
        
        getRewardButton.alpha = 0
        
        leftBoosterButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        centerBoosterButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        rightBoosterButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
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
        
        foregroundCardImage = buttonCardID == randomNumber ? goldImage : silverImage
        GlobalSetting.money = buttonCardID == randomNumber ? GlobalSetting.money + GlobalSetting.gold : GlobalSetting.money + GlobalSetting.silver
        moneyLabel.text = "\(GlobalSetting.money)"
        
        cardSideImage = leftCardIsOpen ? foregroundCardImage : backsideImage
        leftBoosterButton.setImage(cardSideImage, for: .normal)
        
        leftCardIsOpen = centerCardIsOpen ? false : true
        
        UIView.transition(with: leftBoosterButton, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
        GlobalSetting.boosterIsActive = false
        
        disableBoosterButton()
        getRewardButton.alpha = 1
    }
    
    @objc
    func centerButtonTapped() {
        let buttonCardID = 2
        var foregroundCardImage: UIImage?
        var cardSideImage: UIImage?
        
        foregroundCardImage = buttonCardID == randomNumber ? goldImage : silverImage
        GlobalSetting.money = buttonCardID == randomNumber ? GlobalSetting.money + GlobalSetting.gold : GlobalSetting.money + GlobalSetting.silver
        moneyLabel.text = "\(GlobalSetting.money)"
        
        cardSideImage = centerCardIsOpen ? foregroundCardImage : backsideImage
        centerBoosterButton.setImage(cardSideImage, for: .normal)
        
        centerCardIsOpen = centerCardIsOpen ? false : true
        
        UIView.transition(with: centerBoosterButton, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
        GlobalSetting.boosterIsActive = false
        
        disableBoosterButton()
        getRewardButton.alpha = 1
    }
    
    @objc
    func rightButtonTapped() {
        let buttonCardID = 3
        var foregroundCardImage: UIImage?
        var cardSideImage: UIImage?
        
        foregroundCardImage = buttonCardID == randomNumber ? goldImage : silverImage
        GlobalSetting.money = buttonCardID == randomNumber ? GlobalSetting.money + GlobalSetting.gold : GlobalSetting.money + GlobalSetting.silver
        moneyLabel.text = "\(GlobalSetting.money)"
        
        cardSideImage = rightCardIsOpen ? foregroundCardImage : backsideImage
        rightBoosterButton.setImage(cardSideImage, for: .normal)
        
        rightCardIsOpen = rightCardIsOpen ? false : true
        
        UIView.transition(with: rightBoosterButton, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
        GlobalSetting.boosterIsActive = false
        
        disableBoosterButton()
        getRewardButton.alpha = 1
    }
    
    @objc
    func GetRewardButtonTapped() {
        
        GlobalSetting.boosterIsActive = false
        GlobalSetting.boosterAvailabelTimer = 5
        
        let vc = ViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        
        displayResultLabel()
    }

    private func generateRandomNumber() {
        randomNumber = Int.random(in: 1..<4)
    }
    
    private func displayResultLabel() {
        randomNumberForDebugLabel.text = GlobalSetting.debugMode ? "Загадана карта: \(randomNumber ?? 0)" : ""
    }
    
    private func disableBoosterButton() {
        leftBoosterButton.isUserInteractionEnabled = false
        centerBoosterButton.isUserInteractionEnabled = false
        rightBoosterButton.isUserInteractionEnabled = false
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
            
            randomNumberForDebugLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            randomNumberForDebugLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            randomNumberForDebugLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            randomNumberForDebugLabel.heightAnchor.constraint(equalToConstant: 20),
            
            getRewardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            getRewardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            getRewardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            getRewardButton.heightAnchor.constraint(equalToConstant: 60),
            
            selectCardView.bottomAnchor.constraint(equalTo: boosterStackView.topAnchor, constant: -40),
            selectCardView.heightAnchor.constraint(equalToConstant: 70),
            selectCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            moneyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            moneyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

//extension UIViewController {
//    func makeAnimatedGradient() -> AnimatedGradientView {
//        let view = AnimatedGradientView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.animationDuration = 4
//        view.direction = .up
//        view.animationValues = [(colors: ["#4e26b5", "#d50f30"], .up, .axial),
//                                (colors: ["#833ab4", "#1bd817"], .right, .axial),
//                                (colors: ["#4e26b5", "#d50f30"], .down, .axial),
//                                (colors: ["#0f3d9b", "#1bd817"], .left, .axial)]
//        
//        return view
//    }
//}
