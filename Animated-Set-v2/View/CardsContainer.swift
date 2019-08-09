//
//  CardsContainer.swift
//  Animated Set
//
//  Created by Abdalla Elsaman on 7/18/19.
//  Copyright © 2019 Dumbies. All rights reserved.
//

import UIKit

class CardsContainer: UIView {
    
    enum AnimationState {
        case begining, dealt, changingBounds, dealing
    }
    
    // buffer for doing shuffling 
    var playingCardViews = [PlayingCardView]()
    var grid = Grid(layout: .aspectRatio(0.662))
    var dickFrame: CGRect?
    var pileFrame: CGRect?
    var animationState = AnimationState.begining

    fileprivate func gridSetup() {
        grid.cellCount = playingCardViews.count
        grid.frame = bounds
    }
    
    fileprivate func playingCardViewSetup(_ index: Int) {
        playingCardViews[index].frame.origin = dickFrame!.origin.offsetBy(dx: -self.frame.origin.x, dy: -self.frame.origin.y)
        playingCardViews[index].frame.size = dickFrame!.size
        playingCardViews[index].layer.cornerRadius = 6
        addSubview(playingCardViews[index])
    }
    
    fileprivate func layoutSubviewsRespectToGrid(_ index: Int) {
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
            addSubview(view)
        }
    }
    
    fileprivate func deal3moreAnimation(_ index: Int, with delayFactor: Double) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.75,
            delay: 0.375 * Double(delayFactor),
            options: .curveEaseInOut,
            animations: {
                if let viewFrame = self.grid[index] {
                    let padding = viewFrame.height * Constants.paddingRatio
                    let newViewFrame = viewFrame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
                    self.playingCardViews[index].frame = newViewFrame
                }
            },
            completion: { position in
                UIView.transition(
                    with: self.playingCardViews[index],
                    duration: 0.3,
                    options: .transitionFlipFromLeft,
                    animations: {
                        self.playingCardViews[index].playingCardState = .faceUp
                        self.playingCardViews[index].backgroundColor = .white
                    },
                    completion: nil
                )
            }
        )
    }
    
    override func draw(_ rect: CGRect) {
        gridSetup()
        switch animationState {
        case .begining:
            // setup
            for index in 0..<playingCardViews.count {
                playingCardViewSetup(index)
            }
            // animating
            for index in 0..<playingCardViews.count {
                deal3moreAnimation(index, with: Double(index))
            }
            
        case .changingBounds:
            // layout
            for index in 0..<grid.cellCount {
                layoutSubviewsRespectToGrid(index)
            }
            
        case .dealing, .dealt:
            // setup
            for index in playingCardViews.count-3..<playingCardViews.count {
                playingCardViewSetup(index)
            }
            // layout
            for index in 0..<grid.cellCount-3 {
                 layoutSubviewsRespectToGrid(index)
            }
            // animating
            var delayFactor = 0
            for index in playingCardViews.count-3..<playingCardViews.count {
                deal3moreAnimation(index, with: Double(delayFactor))
                delayFactor += 1
            }
        }
        animationState = .changingBounds
    }
}
