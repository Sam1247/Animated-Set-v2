//
//  PlayingCardView.swift
//  Animated Set
//
//  Created by Abdalla Elsaman on 7/23/19.
//  Copyright © 2019 Dumbies. All rights reserved.
//

import UIKit
var i = 0

class PlayingCardView: UIView {
    
    private var shapes = [UIView]()
    
    let count    : Count
    let kind     : Kind
    let shadding : Shadding
    let color    : Color
    
    override var frame: CGRect {
        didSet {
            self.layer.cornerRadius = frame.height * Constants.cornerRadiusRatio
        }
    }
    
    init(count: Count, kind: Kind, shadding: Shadding, color: Color, frame: CGRect) {
        self.count = count
        self.kind = kind
        self.shadding = shadding
        self.color = color
        super.init(frame: frame)
        self.backgroundColor = getRandomColor()
        self.clipsToBounds = true
//        self.layer.borderWidth = 0.75
//        self.layer.borderColor = getColorIdentity().cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func draw(_ rect: CGRect) {
//        for _ in 0..<count.rawValue {
//            let newShape = ShapeView(frame: frame)
//            newShape.isOpaque = false
//            shapes.append(newShape)
//        }
//        var path = UIBezierPath()
//        switch kind {
//        case .diamond:
//            let bounds = getFrameFromeUIStackView(number: count.countValue())
//            for bound in bounds {
//                print(bounds)
//                let beginingPoint = bound.origin.offsetBy(dx: 0, dy: (bound.height/2))
//                path.move(to: beginingPoint)
//                path.addLine(to: beginingPoint.offsetBy(dx: bound.width/2, dy: -(bound.height/2)))
//                path.addLine(to: beginingPoint.offsetBy(dx: bound.width, dy: 0))
//                path.addLine(to: beginingPoint.offsetBy(dx: bound.width/2, dy: (bound.height/2)))
//                path.close()
//            }
//        case .oval:
//            path = UIBezierPath(ovalIn: bounds)
//        case .triangle:
//            path = UIBezierPath()
//            path.move(to: CGPoint(x: 0, y: bounds.height - bounds.height * Constants.marginRatio))
//            path.addLine(to: CGPoint(x: bounds.width/2, y: 0))
//            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height - bounds.height * Constants.marginRatio))
//            path.close()
//        }
//        path.lineWidth = frame.height * Constants.strokeRatio * 5
//        path.addClip()
//
//        switch color {
//        case .green:
//            UIColor.green.setFill()
//            UIColor.green.setStroke()
//        case .purple:
//            UIColor.purple.setFill()
//            UIColor.purple.setStroke()
//        case .red:
//            UIColor.red.setFill()
//            UIColor.red.setStroke()
//        }
//
//        switch shadding {
//        case .open:
//            path.stroke()
//        case .shaded:
//            path.fill()
//            alpha = 0.3
//        case .solid:
//            path.fill()
//        }
//    }
    
//    private func getFrameFromeUIStackView(number: Int) -> [CGRect] {
//        let stack = UIStackView(arrangedSubviews: shapes)
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.spacing = frame.height/16
//        stack.distribution = .fillEqually
//        addSubview(stack)
//        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: frame.width * Constants.marginRatio).isActive = true
//        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -frame.width * Constants.marginRatio).isActive = true
//        stack.heightAnchor.constraint(equalToConstant: frame.height * CGFloat(shapes.count) / 3 - frame.height * Constants.marginRatio).isActive = true
//        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        var boundss = [CGRect]()
//        for view in stack.arrangedSubviews {
//            boundss.append(view.bounds)
//        }
//        return boundss
//    }

    func getColorIdentity() -> UIColor {
        switch color {
        case .green:
            return UIColor.green
        case .purple:
            return UIColor.purple
        case .red:
            return UIColor.red
        }
    }
    
    private func getRandomColor() -> UIColor {
        let colors = [UIColor.red, .gray, .blue, .black, .darkGray, .cyan, .brown, .green, .orange, .magenta]
        return colors[Int.random(in: 0..<colors.count)]
    }

}

struct Constants {
    static let marginRatio: CGFloat = 0.0625
    static let strokeRatio: CGFloat = 0.01
    static let cornerRadiusRatio: CGFloat = 0.065
    static let paddingRatio: CGFloat = 0.025
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

