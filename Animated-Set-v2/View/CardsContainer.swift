//
//  CardsContainer.swift
//  Animated Set
//
//  Created by Abdalla Elsaman on 7/18/19.
//  Copyright © 2019 Dumbies. All rights reserved.
//

import UIKit

class CardsContainer: UIView {
    
    var playingCardViews = [PlayingCardView]()
    
    var dickFrame: CGRect?
    var pileFrame: CGRect?
    
    override func draw(_ rect: CGRect) {
        //self.subviews.forEach{ $0.removeFromSuperview() }
        var grid = Grid(layout: .aspectRatio(0.662))
        grid.cellCount = playingCardViews.count
        grid.frame = bounds
        for index in 0..<grid.cellCount {
            if let viewFrame = grid[index] {
                let view = playingCardViews[index]
                let padding = viewFrame.height * Constants.paddingRatio
                let newViewFrame = viewFrame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5,
                    delay: 0,
                    options: [.allowUserInteraction],
                    animations: {
                        view.frame = newViewFrame
                },
                    completion: nil)
                view.frame = newViewFrame
                addSubview(view)
            }
        }
    }
    
    
}
