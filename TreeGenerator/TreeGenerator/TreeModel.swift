//
//  TreeModel.swift
//  TreeGenerator
//
//  Created by Cor Pruijs on 15-06-16.
//  Copyright © 2016 CorCoder. All rights reserved.
//

import UIKit

protocol TreeSegment {
    func draw(_ position: CGPoint)
}

class Twig: TreeSegment {
    
    let width: CGFloat
    let direction: CGVector
    let color: UIColor
    var segments: [TreeSegment]
    
    init(width: CGFloat, direction: CGVector, color: UIColor, segments: [TreeSegment]) {
        self.width = width
        self.direction = direction
        self.color = color
        self.segments = segments
    }
    
    func draw(_ position: CGPoint) {
        
        let path = UIBezierPath()
        
        // Configure appearance
        path.lineWidth = width
        color.setStroke()
        
        // Define path
        path.move(to: position)
        let endPoint = position + (direction * CGVector(dx: 1, dy: -1))
        path.addLine(to: endPoint)
        
        path.stroke()
        
        // Draw all sub segments
        segments.forEach { $0.draw(endPoint) }
        
    }
    
    var outerTwigs: [Twig] {
        let result = segments
            .flatMap { $0 as? Twig }                // Take only the TreeSegments that are Twig's
            .flatMap { $0.outerTwigs }              // Get the outerTwigs of every Twig
        return result.isEmpty ? [self] : result     // This is an outerTwig if result is empty.
    }
    
}

class Flower: TreeSegment {
    
    let color: UIColor
    let radius: CGFloat
    
    init(color: UIColor, radius: CGFloat) {
        self.color = color
        self.radius = radius
    }
    
    func draw(_ position: CGPoint) {
        color.setFill()
        UIBezierPath(arcCenter: position, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true).fill()
    }
}
