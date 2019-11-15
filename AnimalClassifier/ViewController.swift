//
//  ViewController.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 15.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Subview
    
    private lazy var animaleImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        image.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        image.layer.borderWidth = 1
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
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        button.setTitle("Проверить", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .normal)
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
    }
    
}

// MARK: - Action

private extension ViewController {
    @objc
    func checkButtonTapped() {
        print("checkButtonTapped")
    }
}

// MARK: - Layout

private extension ViewController {
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            animaleImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            animaleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            animaleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            animaleImageView.heightAnchor.constraint(equalToConstant: 200),
            
            resultLabel.topAnchor.constraint(equalTo: animaleImageView.bottomAnchor, constant: 40),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            checkButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 100),
            checkButton.widthAnchor.constraint(equalToConstant: 140),
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

