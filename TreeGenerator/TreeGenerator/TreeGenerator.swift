//
//  TreeGenerator.swift
//  TreeGenerator
//
//  Created by Cor Pruijs on 15-06-16.
//  Copyright © 2016 CorCoder. All rights reserved.
//

import UIKit

struct TreeGenerator {
    
    let lowerDX: CGFloat = -80
    let upperDX: CGFloat = 80
    
    let lowerDY: CGFloat = 40
    let upperDY: CGFloat = 120
    
    let iterations = [2, 3]
    let twigsPerIteration = [1, 2, 3]
    
    let flowerColor = [UIColor(red: 0.8100712299346924, green: 0.1511939615011215, blue: 0.4035313427448273, alpha: 1), UIColor(red: 0.2818343937397003, green: 0.5693024396896362, blue: 0.1281824260950089, alpha: 1),
                       UIColor(red: 0.2202886641025543, green: 0.7022308707237244, blue: 0.9593387842178345, alpha: 1), UIColor(red: 0.9346159696578979, green: 0.6284804344177246, blue: 0.107728436589241, alpha: 1)].randomItem()
    
    
    func tree() -> TreeSegment {
        
        
        let base = Twig(width: 30, direction: CGVector(dx: 0, dy: 80), color: UIColor(red: 0.501960814, green: 0.250980407, blue: 0, alpha: 1), segments: [])
        
        for _ in 0...iterations.randomItem() {
            base.outerTwigs.map(addTwigs)
        }
        
        base.outerTwigs.map(addFlower)
        
        return base
    }
    
    internal func addFlower(twig: Twig) {
        
        let randomMultiplier = CGFloat.random()
        
        let flower = Flower(color: flowerColor.darker(0.5 - randomMultiplier), radius: 30 * randomMultiplier)
        
        
        twig.segments.append(flower)
    }
    
    internal func addTwigs(twig: Twig) {
        
        for _ in 0...twigsPerIteration.randomItem() {
            let subSegment = Twig(width: 0.6 * twig.width,
                                  direction: CGVector(dx: CGFloat.random(lowerDX, upperDX), dy: CGFloat.random(lowerDY, upperDY)),
                                  color: twig.color.darker(0.2),
                                  segments: [])
            twig.segments.append(subSegment)
        }
    }
}

