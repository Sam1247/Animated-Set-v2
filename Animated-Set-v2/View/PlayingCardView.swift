//
//  PlayingCardView.swift
//  Animated Set
//
//  Created by Abdalla Elsaman on 7/23/19.
//  Copyright © 2019 Dumbies. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {
    
    enum PlayingCardState {
        case faceUp, facedown
    }
    
    var playingCardState = PlayingCardState.facedown { didSet { setNeedsDisplay() } }
    
    private var shapes = [UIView]()
    
    let count    : Count
    let kind     : Kind
    let shadding : Shadding
    let color    : Color
    
    override var frame: CGRect {
        didSet {
            self.layer.cornerRadius = frame.height * Constants.cornerRadiusRatio
            setNeedsDisplay()
        }
    }
    
    init(count: Count, kind: Kind, shadding: Shadding, color: Color, frame: CGRect) {
        self.count = count
        self.kind = kind
        self.shadding = shadding
        self.color = color
        super.init(frame: frame)
        self.backgroundColor = .green
        self.clipsToBounds = true
        self.layer.borderWidth = 0.75
        self.layer.borderColor = getColorIdentity().cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func drawFrame(_ frame: CGRect) {
        var path: UIBezierPath
        switch kind {
        case .diamond:
            path = UIBezierPath()
            let beginingPoint = frame.origin.offsetBy(dx: 0, dy: (frame.height/2))
            path.move(to: beginingPoint)
            path.addLine(to: beginingPoint.offsetBy(dx: frame.width/2, dy: -(frame.height/2)))
            path.addLine(to: beginingPoint.offsetBy(dx: frame.width, dy: 0))
            path.addLine(to: beginingPoint.offsetBy(dx: frame.width/2, dy: (frame.height/2)))
            path.close()
        case .oval:
            path = UIBezierPath(ovalIn: frame)
        case .triangle:
            path = UIBezierPath()
            let beginingPoint = frame.origin.offsetBy(dx: frame.width/2, dy: 0)
            path.move(to: beginingPoint)
            path.addLine(to: beginingPoint.offsetBy(dx: frame.width/2, dy: (frame.height)))
            path.addLine(to: beginingPoint.offsetBy(dx: -frame.width/2, dy: (frame.height)))
            path.close()
        }
        UIGraphicsGetCurrentContext()?.saveGState()
        path.lineWidth = frame.height * Constants.strokeRatio * 5
        path.addClip()
        
        switch color {
        case .green:
            UIColor.green.setFill()
            UIColor.green.setStroke()
        case .purple:
            UIColor.purple.setFill()
            UIColor.purple.setStroke()
        case .red:
            UIColor.red.setFill()
            UIColor.red.setStroke()
        }
        switch shadding {
        case .open:
            path.stroke()
        case .shaded:
            path.fill()
            alpha = 0.3
        case .solid:
            path.fill()
        }
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
    
    fileprivate func addPadding(_ frame: CGRect) -> CGRect {
        let padding = frame.height * Constants.paddingRatio * 2.5
        let newViewFrame = frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        return newViewFrame
    }
    
    override func draw(_ rect: CGRect) {
        switch playingCardState {
        case .faceUp:
            switch count {
            case .one:
                let frames = getFrames(count: 1)
                for frame in frames {
                    drawFrame(addPadding(frame))
                }
            case .two:
                let frames = getFrames(count: 2)
                for frame in frames {
                    drawFrame(addPadding(frame))
                }
            case .three:
                let frames = getFrames(count: 3)
                for frame in frames {
                    drawFrame(addPadding(frame))
                }
            }
        case .facedown:
            break
        }
    }
    
    private func getFrames(count: Int) -> [CGRect] {
        var frames = [CGRect]()
        switch count {
        case 1:
            frames.append(CGRect(x: 0, y: bounds.height/3, width: bounds.width, height: bounds.height/3))
        case 2:
            frames.append(CGRect(x: 0, y: bounds.height/6, width: bounds.width, height: bounds.height/3))
            frames.append(CGRect(x: 0, y: bounds.height/3 + bounds.height/6, width: bounds.width, height: bounds.height/3))
        case 3:
            frames.append(CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height/3))
            frames.append(CGRect(x: 0, y: bounds.height/3, width: bounds.width, height: bounds.height/3))
            frames.append(CGRect(x: 0, y: (bounds.height*2)/3, width: bounds.width, height: bounds.height/3))
        default:
            break
        }
        return frames
    }
    
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
    static let paddingRatio: CGFloat = 0.065
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

