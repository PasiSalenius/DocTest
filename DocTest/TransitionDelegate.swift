//
//  TransitionDelegate.swift
//  DocTest
//
//  Created by Pasi Salenius on 13.4.2022.
//

import UIKit

final class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let transitionController: UIDocumentBrowserTransitionController
    
    init(withTransitionController transitionController: UIDocumentBrowserTransitionController) {
        self.transitionController = transitionController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionController
    }
}
