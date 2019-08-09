//
//  CardBehavior.swift
//  Animated-Set-v2
//
//  Created by Abdalla Elsaman on 8/7/19.
//  Copyright © 2019 Dumbies. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    var pileFrame: CGRect?
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    
    private func push(_ item: UIView) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat.random(in: 0...2*CGFloat.pi)
        push.magnitude = 5.0 + CGFloat.random(in: 0...5.0)
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    private func snap(_ item: UIView) {
        let snap = UISnapBehavior(item: item, snapTo:CGPoint(x: pileFrame!.origin.x + 24, y: pileFrame!.origin.y + 24))
        snap.damping = 0.5
        addChildBehavior(snap)
    }
    
    func addItem(_ item: UIView) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            self.snap(item)
            self.itemBehavior.removeItem(item)
            self.collisionBehavior.removeItem(item)
            item.frame.size = self.pileFrame!.size
        }
    }
    
    func removeItem(_ item: UIView) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator, pileFrame: CGRect) {
        self.init()
        self.pileFrame = pileFrame
        animator.addBehavior(self)
    }
}
