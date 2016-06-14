//: # Tree generator

import UIKit
import XCPlayground


//: ## Extensions

//: ### Vector math extensions
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

//: ### Array extension
extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

//: ### UIColor extensions
extension UIColor {
    
    func lighter(amount : CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightnessAmount(1 + amount)
    }
    
    func darker(amount : CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightnessAmount(1 - amount)
    }
    
    private func hueColorWithBrightnessAmount(amount: CGFloat) -> UIColor {
        var hue         : CGFloat = 0
        var saturation  : CGFloat = 0
        var brightness  : CGFloat = 0
        var alpha       : CGFloat = 0
        
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor( hue: hue,
                            saturation: saturation,
                            brightness: brightness * amount,
                            alpha: alpha )
        } else {
            return self
        }
        
    }
    
}

//: ### CGFloat extension
public extension CGFloat {
    /// SwiftRandom extension
    public static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}


//: ## Model
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


//: ## Generating
struct TreeGenerator {
    
    let lowerDX: CGFloat = -80
    let upperDX: CGFloat = 80
    
    let lowerDY: CGFloat = 40
    let upperDY: CGFloat = 120
    
    let iterations = [2, 3]
    let twigsPerIteration = [1, 2, 3]
    
    let flowerColor = [[#Color(colorLiteralRed: 0.8100712299346924, green: 0.1511939615011215, blue: 0.4035313427448273, alpha: 1)#], [#Color(colorLiteralRed: 0.2818343937397003, green: 0.5693024396896362, blue: 0.1281824260950089, alpha: 1)#], [#Color(colorLiteralRed: 0.2202886641025543, green: 0.7022308707237244, blue: 0.9593387842178345, alpha: 1)#], [#Color(colorLiteralRed: 0.9346159696578979, green: 0.6284804344177246, blue: 0.107728436589241, alpha: 1)#]].randomItem()
    
    
    func tree() -> TreeSegment {
        
        
        let base = Twig(width: 30, direction: CGVector(dx: 0, dy: 80), color: [#Color(colorLiteralRed: 0.501960814, green: 0.250980407, blue: 0, alpha: 1)#], segments: [])

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



//: ## Rendering
// specify the amount of trees to render
let treeCount = 15

class CanvasView: UIView {
    
    var tree: TreeSegment = TreeGenerator().tree()
    
    override func drawRect(rect: CGRect) {
        let startPosition = CGPoint(x: bounds.midX, y: bounds.size.height)
        tree.draw(startPosition)
    }
}

for i in 0..<treeCount {
 
    
    let canvasFrame = CGRect(x: 0, y: 0, width: 800, height: 800)
    let canvas = CanvasView(frame: canvasFrame)
    
    canvas.backgroundColor = [#Color(colorLiteralRed: 1, green: 0.9999743700027466, blue: 0.9999912977218628, alpha: 1)#]
    
    
    XCPlaygroundPage.currentPage.captureValue(canvas, withIdentifier: "tree \(i)")
    

}
