//
//  OnboardingView.swift
//  Shoppe
//
//  Created by Дарья on 04.03.2025.
//

import UIKit
import SnapKit

class OnboardingView: UIView {
    
    private let pageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
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
        let baseFont = UIFont(name: Fonts.NunitoSans.light, size: 19) ?? UIFont.systemFont(ofSize: 19)
        let scaledFont = UIFontMetrics.default.scaledFont(for: baseFont)
        
        label.textColor = .black
        label.font = scaledFont
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pageView)
        pageView.addSubview(imageContainer)
        imageContainer.addSubview(pageImageView)
        pageView.addSubview(pageLabel)
        pageView.addSubview(pageDescription)
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
    
    public func applyButtonCornerRadius() {
        pageButton.layer.cornerRadius = pageButton.frame.height * 0.25
    }
    
    public func hideButton(_ isHidden: Bool) {
        pageButton.isHidden = isHidden
    }
    
    //MARK: - Set Constraints
    private func setupConstraints() {
        
        // надо создать какое-нибудь небольшое число которое будет зависеть от размера экрана и его потом умножать
        let horizontalPadding = UIScreen.main.bounds.width * 0.05
        let verticalPadding = UIScreen.main.bounds.height * 0.05

        pageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(verticalPadding * 1)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding * 1.5)
            make.height.lessThanOrEqualTo(safeAreaLayoutGuide).multipliedBy(0.8)
            make.bottom.lessThanOrEqualToSuperview().offset(-verticalPadding * 2)
        }
        
        imageContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(pageView)
            make.height.equalTo(pageView).multipliedBy(0.55)
        }
        
        pageImageView.snp.makeConstraints { make in
            make.edges.equalTo(imageContainer)
        }
        
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(imageContainer.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalTo(pageView).inset(horizontalPadding)
        }
        
        pageDescription.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(verticalPadding / 2)
            make.leading.trailing.equalTo(pageView).inset(horizontalPadding * 1)
            make.bottom.lessThanOrEqualTo(pageButton.snp.top).offset(-verticalPadding)
        }

        pageButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(pageView).inset(horizontalPadding * 3)
            make.height.equalTo(UIScreen.main.bounds.height * 0.06)
            make.bottom.lessThanOrEqualTo(pageView).offset(-verticalPadding * 0.5)
        }
    }
    
    // MARK: - Corner Radius
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageView.layer.cornerRadius = pageView.frame.height * 0.05
        imageContainer.layer.cornerRadius = pageView.layer.cornerRadius
    }
    
}
