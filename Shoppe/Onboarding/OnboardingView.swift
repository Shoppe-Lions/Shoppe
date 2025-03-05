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
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pageDescription: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
    
    
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pageView)
        pageView.addSubview(pageLabel)
        pageView.addSubview(pageDescription)
        pageView.addSubview(pageImageView)
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            pageView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            pageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            pageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            pageView.heightAnchor.constraint(equalToConstant: 615),
            
            pageImageView.topAnchor.constraint(equalTo: pageView.topAnchor, constant: 0),
            pageImageView.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 0),
            pageImageView.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: 0),
            //pageImageView.heightAnchor.constraint(equalToConstant: 300),
            
            pageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            pageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            pageLabel.topAnchor.constraint(equalTo: pageImageView.bottomAnchor, constant: 30),
            pageLabel.heightAnchor.constraint(equalToConstant: 80),
            
            pageDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            pageDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            pageDescription.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 16),
            pageDescription.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -30),
            

        ])
    }
    
}
