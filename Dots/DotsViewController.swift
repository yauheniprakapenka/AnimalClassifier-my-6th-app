//
//  DotsViewController.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 30.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import UIKit
import AnimatedGradientView

class DotsViewController: UIViewController {
    
    // MARK: - Properties
    
    var currentLevel = 0
    var connections = [ConnectionView]()
    let renderedLines = UIImageView()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Собрано: \(score) из \(GlobalSetting.needDotsScoreToWin)"
        }
    }
    
    // MARK: - Subview
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Собрано: \(score) из \(GlobalSetting.needDotsScoreToWin)"
        label.textColor = .cyan
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "background-dots")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var animatedGradientView: AnimatedGradientView = makeAnimatedGradient(alpha: 0.3)
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        renderedLines.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImage)
        view.addSubview(animatedGradientView)
        view.addSubview(renderedLines)
        view.addSubview(scoreLabel)
        
        makeConstraints()
        
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.levelUp()
        })
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}

// MARK: - Action

private extension DotsViewController {
    private func levelUp() {
        currentLevel += 1
        
        connections.forEach { $0.removeFromSuperview() }
        connections.removeAll()
        
        for _ in 1...(currentLevel + 4) {
            let connection = ConnectionView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
            connection.layer.cornerRadius = 22
            connection.layer.borderWidth = 2
            connection.backgroundColor = .white
            connections.append(connection)
            view.addSubview(connection)
            
            connection.dragChanged = { [weak self] in
                self?.redrawLines()
            }
            
            connection.dragFinished = { [weak self] in
                self?.checkMove()
            }
        }
        
        for i in 0..<connections.count {
            if i == connections.count - 1 {
                connections[i].after = connections[0]
            } else {
                connections[i].after = connections[i + 1]
            }
        }
        
        repeat {
            connections.forEach(place)
        } while levelClear()
        
        redrawLines()
    }
    
    private func place(_ connection: ConnectionView) {
        let randomX = CGFloat.random(in: 40...view.bounds.maxX - 40)
        let randomY = CGFloat.random(in: 70...view.bounds.maxY - 70)
        connection.center = CGPoint(x: randomX, y: randomY)
    }
    
    private func redrawLines() {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        
        renderedLines.image = renderer.image { ctx in
            for connection in connections {
                var isLineClear = true
                
                for other in connections {
                    if linesCross(start1: connection.center, end1: connection.after.center, start2: other.center, end2: other.after.center) != nil {
                        isLineClear = false
                        break
                    }
                }
                
                if isLineClear {
                    UIColor.green.set()
                } else {
                    UIColor.red.set()
                }
                
                ctx.cgContext.strokeLineSegments(between: [connection.after.center, connection.center])
            }
        }
    }
    
    private func linesCross(start1: CGPoint, end1: CGPoint, start2: CGPoint, end2: CGPoint) -> (x: CGFloat, y: CGFloat)? {
        // calculate the differences between the start and end X/Y positions for each of our points
        let delta1x = end1.x - start1.x
        let delta1y = end1.y - start1.y
        let delta2x = end2.x - start2.x
        let delta2y = end2.y - start2.y
        
        // create a 2D matrix from our vectors and calculate the determinant
        let determinant = delta1x * delta2y - delta2x * delta1y
        
        if abs(determinant) < 0.0001 {
            // if the determinant is effectively zero then the lines are parallel/colinear
            return nil
        }
        
        // if the coefficients both lie between 0 and 1 then we have an intersection
        let ab = ((start1.y - start2.y) * delta2x - (start1.x - start2.x) * delta2y) / determinant
        
        if ab > 0 && ab < 1 {
            let cd = ((start1.y - start2.y) * delta1x - (start1.x - start2.x) * delta1y) / determinant
            
            if cd > 0 && cd < 1 {
                // lines cross – figure out exactly where and return it
                let intersectX = start1.x + ab * delta1x
                let intersectY = start1.y + ab * delta1y
                return (intersectX, intersectY)
            }
        }
        
        // lines don't cross
        return nil
    }
    
    private func levelClear() -> Bool {
        for connection in connections {
            for other in connections {
                if linesCross(start1: connection.center, end1: connection.after.center, start2: other.center, end2: other.after.center) != nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func checkMove() {
        if levelClear() {
            score += currentLevel + 2
            
            guard score < GlobalSetting.needDotsScoreToWin else {
                showAlert()
                
                return
            }
            
            view.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: {
                self.renderedLines.alpha = 0
                
                for connection in self.connections {
                    connection.alpha = 0
                }
            }) { finished in
                self.view.isUserInteractionEnabled = true
                self.renderedLines.alpha = 1
                self.levelUp()
            }
        } else {
            // Все еще играем на уровне
            score -= 1
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Уровень пройден!", message: "Комната внось чистая и светлая.\nПолучено \(GlobalSetting.givePointsForWin) очков.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: { action in
            GlobalSetting.profileMoney = GlobalSetting.profileMoney + GlobalSetting.givePointsForWin
            let vc = ViewController()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }))
        
        self.present(alert, animated: true)
    }
}

// MARK: - Layout

private extension DotsViewController {
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            animatedGradientView.topAnchor.constraint(equalTo: view.topAnchor),
            animatedGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animatedGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animatedGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            renderedLines.topAnchor.constraint(equalTo: view.topAnchor),
            renderedLines.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            renderedLines.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderedLines.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scoreLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

