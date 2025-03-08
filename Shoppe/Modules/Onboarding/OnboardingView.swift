//
//  OnboardingView.swift
//  Shoppe
//
//  Created by Дарья on 04.03.2025.
//

import UIKit

class OnboardingView: UIView {
    
    
    private let pageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 9
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        let baseFont = UIFont(name: Fonts.Raleway.bold, size: 28) ?? UIFont.systemFont(ofSize: 28)
        let scaledFont = UIFontMetrics.default.scaledFont(for: baseFont)

        label.textColor = .black
        //label.font = UIFont(name: Fonts.Raleway.bold, size: 28)
        label.textAlignment = .center
        label.font = scaledFont
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pageDescription: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: Fonts.NunitoSans.light, size: 19)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private let pageButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: Fonts.NunitoSans.light, size: 18)
        button.backgroundColor = .systemBlue
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pageView)
        pageView.addSubview(pageLabel)
        pageView.addSubview(pageDescription)
        pageView.addSubview(pageImageView)
        pageView.addSubview(pageButton)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setPageLabeltext(text: String) {
        pageLabel.text = text
    }
    
    public func setPageDescriptiontext(text: String) {
        pageDescription.text = text
    }
    
        public func setImage(image: UIImage) {
            pageImageView.image = image
        }
    
    public func setView() -> UIView {
        return pageView
    }
    
    public func setButton(text: String, target: Any?, action: Selector?) {
        pageButton.setTitle(text, for: .normal)
        if let target = target, let action = action {
        pageButton.addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    public func hideButton(_ isHidden: Bool) {
        pageButton.isHidden = isHidden
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            pageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 55),
            pageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            pageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            pageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            
            pageImageView.topAnchor.constraint(equalTo: pageView.topAnchor, constant: 0),
            pageImageView.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 0),
            pageImageView.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: 0),
            //pageImageView.heightAnchor.constraint(equalToConstant: 300),
            
            pageLabel.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 30),
            pageLabel.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: -30),
            pageLabel.topAnchor.constraint(equalTo: pageImageView.bottomAnchor, constant: 30),
            pageLabel.heightAnchor.constraint(equalToConstant: 70),
            
            pageDescription.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 10),
            pageDescription.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: -10),
            pageDescription.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 0),
            pageDescription.bottomAnchor.constraint(lessThanOrEqualTo: pageView.bottomAnchor, constant: -10),
            
            pageButton.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 60),
            pageButton.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: -60),
            pageButton.heightAnchor.constraint(equalToConstant: 50),
            pageButton.bottomAnchor.constraint(lessThanOrEqualTo: pageView.bottomAnchor, constant: -20)
        ])
    }
    
}
