//
//  TreeModel.swift
//  TreeGenerator
//
//  Created by Cor Pruijs on 15-06-16.
//  Copyright © 2016 CorCoder. All rights reserved.
//

import UIKit

protocol TreeSegment {
    func draw(position: CGPoint)
}

class Twig: TreeSegment {
    
    let width: CGFloat
    let direction: CGVector
    let color: UIColor
    
    
    init(width: CGFloat, direction: CGVector, color: UIColor, segments: [TreeSegment]) {
        self.width = width
        self.direction = direction
        self.color = color
        self.segments = segments
    }
    
    
    var segments: [TreeSegment]
    
    
    func draw(position: CGPoint) {
        
        let path = UIBezierPath()
        
        path.moveToPoint(position)
        let endPoint = position + (direction * CGVector(dx: 1, dy: -1))
        path.addLineToPoint(endPoint)
        
        path.lineWidth = width
        
        color.setStroke()
        path.stroke()
        
        segments.map { $0.draw(endPoint) }
        
    }
    
    var outerTwigs: [Twig] {
        get {
            var result: [Twig] = []
            
            let twigs = segments.flatMap { $0 as? Twig }
            
            if twigs.isEmpty {
                result.append(self)
            } else {
                twigs.map { result.appendContentsOf($0.outerTwigs) }
            }
            
            return result
        }
    }
    
}

class Flower: TreeSegment {
    
    let color: UIColor
    let radius: CGFloat
    
    init(color: UIColor, radius: CGFloat) {
        self.color = color
        self.radius = radius
    }
    
    func draw(position: CGPoint) {
        let circlePath = UIBezierPath(arcCenter: position,
                                      radius: radius,
                                      startAngle: CGFloat(0),
                                      endAngle:CGFloat(M_PI * 2),
                                      clockwise: true)
        
        color.setFill()
        circlePath.fill()
    }
}
