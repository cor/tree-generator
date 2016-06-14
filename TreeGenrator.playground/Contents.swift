//: # Tree generator

import UIKit
import XCPlayground


//: ## Vector math extensions
/**
 * Adds a CGVector to this CGPoint and returns the result as a new CGPoint.
 */
public func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

/**
 * Multiplies the x and y fields of a CGVector with the same scalar value and
 * returns the result as a new CGVector.
 */
public func * (vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

/**
 * Multiplies two CGVector values and returns the result as a new CGVector.
 */
public func * (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
}



//: ## The Model
protocol TreeSegment {
    func draw(position: CGPoint)
}

struct Twig: TreeSegment {
    
    let width: CGFloat
    let direction: CGVector
    let color: UIColor

    var segments: [TreeSegment]

    
    func draw(position: CGPoint) {
        
        let path = UIBezierPath()
        
        path.moveToPoint(position)
        let endPoint = position + (direction * CGVector(dx: 1, dy: -1))
        path.addLineToPoint(endPoint)
        
        path.lineWidth = width
        
        color.setStroke()
        path.stroke()
        
        for segment in segments {
            segment.draw(endPoint)
        }
    }
    
}

struct Flower: TreeSegment {
    
    func draw(position: CGPoint) {
        
    }
}


//: ## Generating
func generateTree(repetitions: Int = 4) -> TreeSegment {
    
    var segment = Twig(width: 10.0,
                        direction: CGVector(dx: 10.0, dy: 80.0),
                        color: [#Color(colorLiteralRed: 0.1288586854934692, green: 0, blue: 0.4869538545608521, alpha: 1)#],
                        segments: [])
    
    segment.segments.append(segment)
    
    return segment
}




//: ## Rendering
class CanvasView: UIView {
    
    var tree: TreeSegment = generateTree()
    
    override func drawRect(rect: CGRect) {
        let startPosition = CGPoint(x: bounds.midX, y: bounds.size.height)
        tree.draw(startPosition)
    }
}



let canvasFrame = CGRect(x: 0, y: 0, width: 800, height: 800)
let canvas = CanvasView(frame: canvasFrame)

canvas.backgroundColor = [#Color(colorLiteralRed: 1, green: 0.9999743700027466, blue: 0.9999912977218628, alpha: 1)#]


XCPlaygroundPage.currentPage.captureValue(canvas, withIdentifier: "result")


