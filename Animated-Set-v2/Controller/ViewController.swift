//
//  ViewController.swift
//  Animated-Set-v2
//
//  Created by Abdalla Elsaman on 8/3/19.
//  Copyright © 2019 Dumbies. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    enum UpdateState {
        case shuffled, appended
    }
    
    @IBOutlet weak var cardsContainer: CardsContainer! {
        didSet {
            let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(shuffle(recognizer:)))
            cardsContainer.addGestureRecognizer(rotationGesture)
            let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dealSwipe(recognizer:)))
            swipeDownGesture.direction = .down
            cardsContainer.addGestureRecognizer(swipeDownGesture)
        }
    }
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var discardPileButton: UIButton!
    
    var game = Set()
    var selectedPlayingCards = [PlayingCardView]() {
        didSet {
            if selectedPlayingCards.count == 3 {
                handleMatching()
            }
        }
    }
    
    var updateState = UpdateState.appended
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator, pileFrame: discardPileButton.frame)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardsContainer.dickFrame = dealButton.frame
    }
    
   
    
    func setupButtons() {
        dealButton.layer.cornerRadius = 6
        cardsContainer.dickFrame = dealButton.frame
        discardPileButton.layer.cornerRadius = 6
        cardsContainer.pileFrame = discardPileButton.frame
    }
    
    fileprivate func setupCardView(_ card: Card?) {
        let cardView = PlayingCardView(count: Count(rawValue: card!.varient3.rawValue)!, kind: Kind(rawValue: card!.varient2.rawValue)!, shadding: Shadding(rawValue: card!.varient4.rawValue)!, color: Color(rawValue: card!.varient1.rawValue)!, frame: CGRect())
        cardView.center = dealButton.center
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SetViewController.select(recognizer:)))
        cardView.addGestureRecognizer(tapGestureRecognizer)
        cardsContainer.playingCardViews.append(cardView)
    }
    
    func initialSetup() {
        cardsContainer.animationState = .begining
        for _ in 0..<4 {
            deal3more()
        }
        // updating views
        for card in game.playingCards {
            setupCardView(card)
        }
        cardsContainer.setNeedsDisplay()
    }
    
    @objc
    func updateViewFromModel() {
        // cardsContainer.playingCardViews.removeAll()
        // to get last 3 elemets
        // var startIndex = game.playingCards.count-3
        switch updateState {
        case .shuffled:
            let shuffledIndices = game.playingCards.indices.shuffled()
            let shuffledModel = shuffledIndices.map { game.playingCards[$0] }
            let shuffledViews = shuffledIndices.map { cardsContainer.playingCardViews[$0] }
            game.playingCards = shuffledModel
            cardsContainer.playingCardViews = shuffledViews
            updateState = .appended
        case .appended:
            // appending the last three cards from model
            let startIndex = game.playingCards.count-3
            for index in startIndex..<game.playingCards.count {
                let card = game.playingCards[index]
                setupCardView(card)
            }
        }
        cardsContainer.setNeedsDisplay()
    }
    
    @IBAction func deal(_ sender: Any) {
        cardsContainer.animationState = .dealing
        deal3more()
        if dealButton.isEnabled == false {
            return
        }
        updateViewFromModel()
    }
    
    func deal3more() {
        if game.deck.count == 0 {
            dealButton.isEnabled = false
            return
        }
        game.dealMoreCards()
    }
    
    @objc
    func select(recognizer: UIPanGestureRecognizer) {
        if let sender = recognizer.view as? PlayingCardView {
            if selectedPlayingCards.contains(sender) {
                sender.layer.borderColor = sender.getColorIdentity().cgColor
                selectedPlayingCards.remove(at: selectedPlayingCards.firstIndex(of: sender)!)
                return
            }
            sender.layer.borderColor = UIColor.blue.cgColor
            selectedPlayingCards.append(sender)
        }
    }
    
    func handleMatching() {
        let card1 = getCard(from: selectedPlayingCards[0])
        let card2 = getCard(from: selectedPlayingCards[1])
        let card3 = getCard(from: selectedPlayingCards[2])
        game.isMatched(card1, card2, card3) ? handleCorrectMatching() : handleWrongMatching()
    }
    
    private func handleCorrectMatching() {
        for cardView in selectedPlayingCards {
            cardView.layer.borderColor = UIColor.cyan.cgColor
            cardBehavior.addItem(cardView)
        }
        selectedPlayingCards.removeAll()
//        UIViewPropertyAnimator.runningPropertyAnimator(
//            withDuration: 0.25,
//            delay: 0,
//            options: .curveEaseInOut,
//            animations: {
//                for cardView in self.selectedPlayingCards {
//                    cardView.alpha = 0
//                }
//        },
//            completion: { (position) in
//                if position == .end {
//                    for cardView in self.selectedPlayingCards {
//                        cardView.removeFromSuperview()
//                        // updating cardsContainer.playingCardViews buffer
//                        if let index = self.cardsContainer.playingCardViews.firstIndex(of: cardView) {
//                            self.cardsContainer.playingCardViews.remove(at: index)
//                        }
//                    }
//                    if !self.game.deck.isEmpty {
//                        self.cardsContainer.animationState = .dealt
//                        self.deal3more()
//                        self.updateViewFromModel()
//                    }
//
//
//                    // clearing selected cards
//                    self.selectedPlayingCards.removeAll()
//                }
//        })
        
        
    }
    
    private func handleWrongMatching() {
        for cardView in selectedPlayingCards {
            cardView.layer.borderColor = UIColor.red.cgColor
        }
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(removeWrongSelectionHighlight), userInfo: nil, repeats: false)
    }
    
    @objc
    private func removeWrongSelectionHighlight() {
        for cardView in selectedPlayingCards {
            cardView.layer.borderColor = cardView.getColorIdentity().cgColor
        }
        // clearing selected cards
        selectedPlayingCards.removeAll()
    }
    
    func getCard(from cardView: PlayingCardView) -> Card {
        let card = Card(
            color: Card.Varient(rawValue: cardView.color.rawValue)!,
            kind: Card.Varient(rawValue: cardView.kind.rawValue)!,
            count: Card.Varient(rawValue: cardView.count.rawValue)!,
            shadding: Card.Varient(rawValue: cardView.shadding.rawValue)!
        )
        return card
    }
    
    @objc
    func shuffle(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            game.shufflePlayingCards()
            updateState = .shuffled
            updateViewFromModel()
        default:
            break
        }
    }
    
    @objc
    func dealSwipe(recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case .down:
            deal3more()
            updateViewFromModel()
        default:
            break
        }
    }
}
