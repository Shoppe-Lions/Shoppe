//
//  OnboardingViewController.swift
//  Shoppe
//
//  Created by Дарья on 04.03.2025.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    
    var didFinishOnboarding: (() -> Void)?
    
    // создаем листалку
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()
    
    // создаем кружочки снизу
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.pageIndicatorTintColor = UIColor(named: "CustomLightGray")
        pageControl.currentPageIndicatorTintColor = UIColor(named: "CustomBlue")
        pageControl.transform = CGAffineTransform(scaleX: 3, y: 3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "BubblesBackground"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // массив для нашей вью
    private var slides = [OnboardingView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setDeligates()
        
        slides = createSlides()
        setupSlidesScrollView(slides: slides)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for slide in slides {
            slide.applyButtonCornerRadius()
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
    }
    
    private func setDeligates() {
        scrollView.delegate = self
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
    }
    
    // возвращаем массив каждый элемент которого - это OnboardingView
    private func createSlides() -> [OnboardingView] {
        let firstOnboardingView = OnboardingView()
        firstOnboardingView.setPageLabeltext(text: "Welcome!")
        firstOnboardingView.setPageDescriptiontext(text: "Discover a fast and easy way to shop online.")
        firstOnboardingView.setImage(image: UIImage(named: "OnboardingOne")!)
        firstOnboardingView.hideButton(true)
        
        let secondOnboardingView = OnboardingView()
        secondOnboardingView.setPageLabeltext(text: "SmartSearch & Favorites")
        secondOnboardingView.setPageDescriptiontext(text: "Find products instatnly and save favorites for later.")
        secondOnboardingView.setImage(image: UIImage(named: "OnboardingTwo")!)
        secondOnboardingView.hideButton(true)
        
        let thirdOnboardingView = OnboardingView()
        thirdOnboardingView.setPageLabeltext(text: "Easy Checkout")
        thirdOnboardingView.setPageDescriptiontext(text: "Add to cart, choose payment, and order in seconds.")
        thirdOnboardingView.setImage(image: UIImage(named: "OnboardingThree")!)
        thirdOnboardingView.hideButton(true)
        
        let fourthOnboardingView = OnboardingView()
        fourthOnboardingView.setPageLabeltext(text: "Manage Your Store")
        fourthOnboardingView.setPageDescriptiontext(text: "Become a manager, add products, and control your catalog!")
        fourthOnboardingView.setImage(image: UIImage(named: "OnboardingFour")!)
        fourthOnboardingView.setButton(text: "Начать", target: self, action: #selector(startButtonTapped))

        return [firstOnboardingView, secondOnboardingView, thirdOnboardingView, fourthOnboardingView]
    }
    
    private func setupSlidesScrollView(slides: [OnboardingView]) {
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        
        for i in 0..<slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i),
                                     y: 0, width: view.frame.width,
                                     height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    @objc func startButtonTapped() {
        print("Кнопка 'Начать' нажата!")
        didFinishOnboarding?()
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let pageIndex = sender.currentPage
        let offsetX = view.frame.width * CGFloat(pageIndex)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        pageControl.currentPage = pageIndex
    }
}

//MARK: - Set Constraints
extension OnboardingViewController {
    
    private func setupConstraints() {
        let horizontalPadding = UIScreen.main.bounds.width * 0.05
        let verticalPadding = UIScreen.main.bounds.height * 0.05
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(verticalPadding * 1)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding * 2)
            make.height.equalTo(UIScreen.main.bounds.height * 0.06)
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
