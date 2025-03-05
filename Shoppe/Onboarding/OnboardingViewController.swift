//
//  OnboardingViewController.swift
//  Shoppe
//
//  Created by Дарья on 04.03.2025.
//

import UIKit

// здесь в перспективе не будет никакой логики, только отображение того что на экранчике

class OnboardingViewController: UIViewController {
    
   // создаем листалку
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        return scrollView
    }()
    
    // создаем кружочки снизу
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.pageIndicatorTintColor = .systemGray
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.transform = CGAffineTransform(scaleX: 3, y: 3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // массив для нашей вью
    private var slides = [OnboardingView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCostraints()
        setDeligates()
        
        slides = createSlides()
        setupSlidesScrollView(slides: slides)
    }
    private func setupView() {
        // здесь собираем элементы вью
        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(pageControl)

    }
    
    private func setDeligates() {
        scrollView.delegate = self
    }
    
    // возвращаем массив каждый элемент которого - это OnboardingView
    private func createSlides() -> [OnboardingView] {
        let firstOnboardingView = OnboardingView()
        firstOnboardingView.setPageLabeltext(text: "Welcome!")
        firstOnboardingView.setPageDescriptiontext(text: "Discover a fast and easy way to shop online.")
        firstOnboardingView.setImage(image: UIImage(named: "OnboardingOne")!)

        
        let secondOnboardingView = OnboardingView()
        secondOnboardingView.setPageLabeltext(text: "SmartSearch & Favorites")
        secondOnboardingView.setPageDescriptiontext(text: "Find products instatnly and save favorites for later.")
        
        let thirdOnboardingView = OnboardingView()
        thirdOnboardingView.setPageLabeltext(text: "Easy Checkout")
        thirdOnboardingView.setPageDescriptiontext(text: "Add to cart, choose payment, and order in seconds.")
        
        let fourthOnboardingView = OnboardingView()
        fourthOnboardingView.setPageLabeltext(text: "Manage Your Store")
        fourthOnboardingView.setPageDescriptiontext(text: "Become a manager, add products, and control your catalog!")
        
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
    
}

//MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        pageControl.currentPage = Int(pageIndex)
    }
}

//MARK: - Set Constraints
extension OnboardingViewController {
 
    
    private func setupCostraints() {
        NSLayoutConstraint.activate ([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            pageControl.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

