//
//  CloudCoverView.swift
//  Appstronomy
//
//  Created by Stephen McMillan on 09/03/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class CloudCoverView: UIView {
    
    let shapeLayer: CAShapeLayer = CAShapeLayer()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        
        let startAngle = (3 * Float.pi)/2// Radians (0deg)
        let endAngle = startAngle + (Float.pi * 2) // 360deg (full circle)
        
        shapeLayer.frame = self.bounds
        
        // Clear the BG colour so the gradient shows through.
        self.backgroundColor = .clear
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2 - 8.0, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 16.0
        shapeLayer.lineCap = .round
        
        shapeLayer.strokeEnd = 0.0
        
        self.layer.addSublayer(shapeLayer)
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
    }
    
    // Must be a value between 0...1
    func setPercentage(to value: Double) {
        guard (0...1).contains(value) else { return }
        shapeLayer.strokeEnd = CGFloat(value)
        label.text = "\(Int(value * 100))%"
        label.sizeToFit()
    }
}

