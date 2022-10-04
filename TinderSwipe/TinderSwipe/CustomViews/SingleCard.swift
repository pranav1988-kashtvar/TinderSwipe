//
//  SingleCard.swift
//  TinderSwipe
//
//  Created by Shi Pra on 03/10/22.
//

import UIKit

protocol PanGestureDelegate: AnyObject {
    func handlePanGesture(panGesture: UIPanGestureRecognizer)
}
class SingleCard: UIView {
    
    // MARK: Properties
    var isSetup: Bool = false
    var delegate: PanGestureDelegate?
    var yConstraint:  NSLayoutConstraint?
    var model: CardViewModel? = nil {
        didSet {
            configureData()
        }
    }
    
    // MARK: View Properties
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Rate this dish"
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Steak with bearnaise sauce"
        return label
    }()
    
    let image: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "background")
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    // MARK: Lifecycle Methods
    override func layoutSubviews() {
        if !isSetup {
            setupConstraint()
            isSetup = true
        }
    }
    
    // MARK: Helper Methods
    func initialSetup() {
        isUserInteractionEnabled = true
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.cornerRadius = 10
        self.addSubview(title)
        self.addSubview(subTitle)
        self.addSubview(image)
        addPanGesture()
//        setupConstraint()
    }
    
    func setupConstraint() {
        //MARK: TITLE CONSTRAINT
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        title.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        //MARK: SUB-TITLE CONSTRAINT
        subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        subTitle.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
        subTitle.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
        subTitle.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        //MARK: Image CONSTRAINT
        image.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 10).isActive = true
        image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        image.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        image.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    func addPanGesture() {
        var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        guard let gestureDelegate = self.delegate else {
            return
        }
        gestureDelegate.handlePanGesture(panGesture: panGesture)
    }
    
    func configureData() {
        guard let model = self.model else {
            return
        }
        title.text = model.title
        subTitle.text = model.subTitle
        image.image = UIImage(named: model.imgStr)
    }
}
