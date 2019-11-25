//
//  BoosterViewController.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 25.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit

class BoosterViewController: UIViewController {
    
    //    private lazy var boosterButton: UIButton = {
    //        let button = UIButton(type: .system)
    //        button.backgroundColor = .red
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.addTarget(self, action: #selector(boosterButtonTapped), for: .touchUpInside)
    //        return button
    //    }()
    
    private var randomPrize = 0
    
    private lazy var leftBoosterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "card-back"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var centerBoosterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "card-back"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var rightBoosterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "card-back"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
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
    
    // MARK: - View lifecycle
    
    override func loadView() {
        self.view = UIView()
        
        view.backgroundColor = .white
        
        //           view.addSubview(boosterButton)
        view.addSubview(boosterStackView)
        
        makeConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generatePrizeNumber()
        
        boosterStackView.addArrangedSubview(leftBoosterButton)
        boosterStackView.addArrangedSubview(centerBoosterButton)
        boosterStackView.addArrangedSubview(rightBoosterButton)
    }
    
    @objc
    func leftButtonTapped() {
        let button = 1
        print("Сгенерировано: \(randomPrize)")
        
        guard button == randomPrize else {
            print("Не угадал")
            generatePrizeNumber()
            return
        }
        
        print("Победа")
        generatePrizeNumber()
    }
    
    @objc
    func centerButtonTapped() {
        let button = 2
        print("Сгенерировано: \(randomPrize)")
        
        guard button == randomPrize else {
            print("Не угадал")
            generatePrizeNumber()
            return
        }
        
        print("Победа")
        generatePrizeNumber()
    }
    
    @objc
    func rightButtonTapped() {
        let button = 3
        print("Сгенерировано: \(randomPrize)")
        
        guard button == randomPrize else {
            print("Не угадал")
            generatePrizeNumber()
            return
        }
        
        print("Победа")
        generatePrizeNumber()
    }
    
    private func generatePrizeNumber() {
        randomPrize = Int.random(in: 1..<4)
    }
}

// MARK: - Layout

private extension BoosterViewController {
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            boosterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boosterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            boosterStackView.heightAnchor.constraint(equalToConstant: 200),
            boosterStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
