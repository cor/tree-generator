//
//  TreeView.swift
//  TreeGenerator
//
//  Created by Cor Pruijs on 15-06-16.
//  Copyright © 2016 CorCoder. All rights reserved.
//

import UIKit

@IBDesignable
class TreeView: UIView {

    var tree: TreeSegment = TreeGenerator().tree()
    
    override func draw(_ rect: CGRect) {
        let startPosition = CGPoint(x: bounds.midX, y: bounds.size.height)
        tree = TreeGenerator().tree()
        tree.draw(startPosition)
    }

}
