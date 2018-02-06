//
//  RootPageViewController.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/3/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    lazy var viewControllersList: [UIViewController] = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardScreen1 = storyboard.instantiateViewController(withIdentifier: "onboardScreen1")
        let onboardScreen2 = storyboard.instantiateViewController(withIdentifier: "onboardScreen2")
        let onboardScreen3 = storyboard.instantiateViewController(withIdentifier: "onboardScreen3")
        let onboardScreen4 = storyboard.instantiateViewController(withIdentifier: "onboardScreen4")
        return[onboardScreen1, onboardScreen2, onboardScreen3, onboardScreen4]
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let firstViewController = viewControllersList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllersList.index(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewControllersList.count > previousIndex else { return nil }
        return viewControllersList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllersList.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard viewControllersList.count != nextIndex else { return nil }
        guard viewControllersList.count > nextIndex else { return nil }
        return viewControllersList[nextIndex]
    }
    
}
