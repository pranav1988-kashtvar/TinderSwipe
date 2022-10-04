//
//  ViewController.swift
//  TinderSwipe
//
//  Created by Shi Pra on 03/10/22.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    var numberOfCards = 5
    var cardOffScreenAfterPoint: CGFloat = 80
    var cardRotationAngle: CGFloat = 15
    
    var cards: [SingleCard] = []
    var cardViewModel: CardData!
    var lastIndexOfCardsOnScreen: Int = 0
    var isSetup: Bool = false
    
    // MARK: VIEW PROPERTIES
    let backgroundImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "background")
        return img
    }()
    
    // MARK: LIFE CYCLE METHOD
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        cardViewModel = CardData()
        cardViewModel.getInitialData()
        for index in 0..<numberOfCards {
            if(cardViewModel.data.count > index) {
                let card = getCardObject()
                card.model = cardViewModel.data[index]
                cards.append(card)
                view.addSubview(card)
                view.sendSubviewToBack(card)
                lastIndexOfCardsOnScreen = index
            }
        }
        view.sendSubviewToBack(backgroundImage)
    }
    
    override func viewWillLayoutSubviews() {
        if !isSetup {
            //MARK: BACKGROUND IMAGE CONSTRAINT
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            //MARK: single card constraint
            print("Number OF Cards Remain: \(cards.count)")
            for index in 0..<cards.count {
                setUpCardConstraint(index: index)
            }
            isSetup = true
        }
    }
    
    // MARK: Helper Methods
    func getCardObject() -> SingleCard {
        let card = SingleCard()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.delegate = self
        return card
    }
    
    func setUpCardConstraint(index: Int) {
        let cardWidth = UIScreen.main.bounds.size.width - 40 // 20 will be padding for each side leading / trailing
        let cardHeight = cardWidth * 1.5
        let card = cards[index]
        
        card.yConstraint =  card.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        card.yConstraint?.constant = getCenterYConstant(for: index)
        card.yConstraint?.isActive = true
        card.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        card.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
        card.heightAnchor.constraint(equalToConstant: cardHeight).isActive = true
        
    }
    
    func getCenterYConstant(for index: Int) -> CGFloat{
        return CGFloat((index) * 10)
    }
}

// MARK: Implement Pan Gesture Delegate for card
extension ViewController: PanGestureDelegate {
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        guard let card = panGesture.view as? SingleCard else {
            return
        }
        let point = panGesture.translation(in: view)
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y)
        rotateAndScaleCard(card: card, xValue: point.x)
        if panGesture.state == .ended {
            
            // CARD MAKE OFF TO SCREEN IF CARD CENTER REACH AT 80 POINT IN X AXIOS TO LEFT SIDE
            if card.center.x <  cardOffScreenAfterPoint{
                
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x - self.view.frame.width, y: card.center.y)
                } completion: { val in
                    self.addCardToBack(card: card)
                }
                
                return
            }else if card.center.x > (view.bounds.size.width - cardOffScreenAfterPoint) {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + self.view.frame.width, y: card.center.y)
                } completion: { val in
                    self.addCardToBack(card: card)
                }
                
                return
            }
            
            UIView.animate(withDuration: 0.3, delay: 0) {
                card.center = self.view.center
                card.transform = .identity
            }
        }
    }
    
    func rotateAndScaleCard(card: SingleCard, xValue: Double) {
        let scaleFactor = 1 - getDeviationPercentage(xValue: abs(xValue)) * 0.2
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let radian = getDeviationPercentage(xValue: xValue) * cardRotationAngle * CGFloat.pi/180
        card.transform = scaleTransform.rotated(by: radian)
    }
    
    func getDeviationPercentage(xValue: Double) -> Double{
        return xValue / UIScreen.main.bounds.size.width
    }
    
    func addCardToBack(card: SingleCard) {
        
        self.cards.remove(at: 0)
        card.removeFromSuperview()
        
        UIView.animate(withDuration: 0.1) {
            self.updateYConstraintsOfCards()
        } completion: { val in
            self.addCardToViewAgain(card: card)
        }

    }
    
    func addCardToViewAgain(card: SingleCard) {
        let nextCardIndex = lastIndexOfCardsOnScreen + 1
        if nextCardIndex < cardViewModel.data.count {
            card.model = cardViewModel.data[nextCardIndex]
            lastIndexOfCardsOnScreen = nextCardIndex
            view.insertSubview(card, belowSubview: cards[cards.count - 1])
            card.transform = .identity
            cards.append(card)
            setupNewCardConstraint(card: card)
        }
    }
    
    func updateYConstraintsOfCards() {
        for index in 0..<cards.count {
            let card = cards[index]
            card.yConstraint?.constant = getCenterYConstant(for: index)
        }
        view.layoutIfNeeded()
    }
    
    func setupNewCardConstraint(card: SingleCard) {
        card.yConstraint =  card.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        card.yConstraint?.constant = getCenterYConstant(for: cards.count - 1)
        card.yConstraint?.isActive = true
        card.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

