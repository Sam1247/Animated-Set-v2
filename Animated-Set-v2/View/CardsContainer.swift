//
//  CardsContainer.swift
//  Animated Set
//
//  Created by Abdalla Elsaman on 7/18/19.
//  Copyright © 2019 Dumbies. All rights reserved.
//

import UIKit

var i = 0

class CardsContainer: UIView {
    
    // buffer for doing shuffling 
    var playingCardViews = [PlayingCardView]()
    
    var dickFrame: CGRect?
    var pileFrame: CGRect?
    
    enum AnimationState {
        case begining, dealt, changingBounds, dealing
    }

    
    var animationState = AnimationState.begining
    
    override func draw(_ rect: CGRect) {
        var grid = Grid(layout: .aspectRatio(0.662))
        grid.cellCount = playingCardViews.count
        grid.frame = bounds
        
        switch animationState {
        case .begining:
            // setup
            for card in playingCardViews {
                card.frame.origin = dickFrame!.origin.offsetBy(dx: -self.frame.origin.x, dy: -self.frame.origin.y)
                card.frame.size = dickFrame!.size
                card.layer.cornerRadius = 6
                //card.frame = dickFrame!
                //card.bounds = dickFrame!
                addSubview(card)
            }
            print("begining")
            
            for index in 0..<playingCardViews.count {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.75,
                    delay: 0.375 * Double(index),
                    options: .curveEaseInOut,
                    animations: {
                        if let viewFrame = grid[index] {
                            let padding = viewFrame.height * Constants.paddingRatio
                            let newViewFrame = viewFrame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
                            self.playingCardViews[index].frame = newViewFrame
                        }
                },
                    completion: { position in
                        UIView.transition(
                            with: self.playingCardViews[index],
                            duration: 0.75,
                            options: .transitionFlipFromLeft,
                            animations: {
                                self.playingCardViews[index].backgroundColor = .blue
                        },
                            completion: nil
                        )
                }
                )
            }
            
        case .changingBounds:
            print("changingBounds")
            
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
            
        case .dealing, .dealt:
            for index in playingCardViews.count-3..<playingCardViews.count {
                playingCardViews[index].frame.origin = dickFrame!.origin.offsetBy(dx: -self.frame.origin.x, dy: -self.frame.origin.y)
                playingCardViews[index].frame.size = dickFrame!.size
                playingCardViews[index].layer.cornerRadius = 6
                //card.frame = dickFrame!
                //card.bounds = dickFrame!
                addSubview(playingCardViews[index])
            }
            
            for index in 0..<grid.cellCount-3 {
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
            
            // animating 3 more cards
            
            var delayAccelerator = 0
            for index in playingCardViews.count-3..<playingCardViews.count {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.75,
                    delay: 0.375 * Double(delayAccelerator),
                    options: .curveEaseInOut,
                    animations: {
                        if let viewFrame = grid[index] {
                            let padding = viewFrame.height * Constants.paddingRatio
                            let newViewFrame = viewFrame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
                            self.playingCardViews[index].frame = newViewFrame
                        }
                },
                    completion: { position in
                        UIView.transition(
                            with: self.playingCardViews[index],
                            duration: 0.75,
                            options: .transitionFlipFromLeft,
                            animations: {
                                self.playingCardViews[index].backgroundColor = .blue
                        },
                            completion: nil
                        )
                }
                )
                delayAccelerator += 1
            }
        }
        animationState = .changingBounds
    }
}
