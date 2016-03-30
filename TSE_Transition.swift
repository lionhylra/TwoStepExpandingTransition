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
    /**
     Use this funcion to define the initial position of presented view in the containerView coordination.
     
     - parameter containerView: The container view
     
     - returns: A frame describing the initial position of the presented view when transition begins
     */
    func initialFrameInContainerView(containerView:UIView) -> CGRect
    
    
    
    /**
     Use this finction to define the final position of presented view in the containerView coordination.
     
     - parameter containerView: The container view
     
     - returns: A frame describing the final position of the presented view when transition ends
     */
    func finalFrameInContainerView(containerView:UIView) -> CGRect
    
}

/* The default implemenation of the TSE_TransitionHelper */
extension TSE_TransitionHelper{
    
    
    
    func initialFrameInContainerView(containerView:UIView) -> CGRect {
        return CGRectMake(0, 0, 0, 44+UIApplication.sharedApplication().statusBarFrame.height)
    }
    
    
    
    func finalFrameInContainerView(containerView:UIView) -> CGRect{
        return containerView.frame
    }
    
    
    
}


/**
    This class conforms to UIViewControllerTransitioningDelegate, defining a customised transition.
 
    The presented view start from a given positon and given size, which is defined in the helper protocol. 
 
    The animation consists of two steps:
    1. The presented view expands its width to the final width
    2. The presented view expands its height to the final height
 */
public class TSE_Transition: NSObject {
    
    
    private let presentationController:UIPresentationController
    private let animationController:PresentDismissAnimation
    
    
    
    /* Initializer */
    public init(presentedViewController: UIViewController, presentingViewController: UIViewController, helper:TSE_TransitionHelper){
        self.presentationController = TSE_PresentationController(presentedViewController: presentedViewController, presentingViewController: presentingViewController, helper: helper)
        self.animationController = TSE_AnimationController(helper: helper)
    }
    
    
    
}


// MARK: - UIViewControllerTransitioningDelegate
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
