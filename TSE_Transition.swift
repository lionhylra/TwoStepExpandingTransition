//
//  TSE_Transition.swift
//  MobileEmbrace
//
//  Created by HeYilei on 4/03/2016.
//  Copyright © 2016 Omni Market Tide. All rights reserved.
//

//TSE = Two Step Expanding

import UIKit

protocol PresentDismissAnimation:UIViewControllerAnimatedTransitioning{
    var isPresenting:Bool{get set}
}

public protocol TSE_TransitionHelper:class {
    func initialFrameInContainerView(containerView:UIView) -> CGRect
    func finalFrameInContainerView(containerView:UIView) -> CGRect
}

extension TSE_TransitionHelper{
    func initialFrameInContainerView(containerView:UIView) -> CGRect {
        return CGRectMake(0, 0, 0, 44+UIApplication.sharedApplication().statusBarFrame.height)
    }
    func finalFrameInContainerView(containerView:UIView) -> CGRect{
        return containerView.frame
    }
}

public class TSE_Transition: NSObject {
    private let presentationController:UIPresentationController
    private let animationController:PresentDismissAnimation
    
    public init(presentedViewController: UIViewController, presentingViewController: UIViewController, helper:TSE_TransitionHelper){
        self.presentationController = TSE_PresentationController(presentedViewController: presentedViewController, presentingViewController: presentingViewController, helper: helper)
        self.animationController = TSE_AnimationController(helper: helper)
    }
    
}

extension TSE_Transition:UIViewControllerTransitioningDelegate{
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return presentationController
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationController.isPresenting = true
        return animationController
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationController.isPresenting = false
        return animationController
    }
}
