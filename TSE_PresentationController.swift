//
//  TSE_PresentationController.swift
//  MobileEmbrace
//
//  Created by HeYilei on 4/03/2016.
//  Copyright © 2016 Omni Market Tide. All rights reserved.
//

import UIKit


class TSE_PresentationController: UIPresentationController {
    weak var wrapperView:UIView? = nil
    weak var dimmingView:UIView? = nil
    weak var helper:TSE_TransitionHelper!
    
    init(presentedViewController: UIViewController, presentingViewController: UIViewController, helper:TSE_TransitionHelper){
        super.init(presentedViewController:presentedViewController, presentingViewController:presentingViewController)
        presentedViewController.modalPresentationStyle = .Custom
        self.helper = helper
    }
    
    override func presentedView() -> UIView? {
        return self.wrapperView
    }
    
    override func presentationTransitionWillBegin() {
        /* add a dimming overlay to the container view */
        let dimmingView = UIView(frame: (self.containerView?.bounds)!)
        dimmingView.backgroundColor = UIColor.blackColor()
        dimmingView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        #if swift(>=2.2)
            dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dimmingViewTapped(_:))))
        #else
            dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dimmingViewTapped:")))
        #endif
        dimmingView.alpha = 0
        containerView?.addSubview(dimmingView)
        self.dimmingView = dimmingView
        /* wrap the presentedView */
        setupPresentedView()
        
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ [unowned self](context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.dimmingView?.alpha = 0.5
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        if !completed {
            dimmingView?.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ [unowned self](context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.dimmingView?.alpha = 0
            }, completion: nil)
        
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            dimmingView?.removeFromSuperview()
            wrapperView?.removeFromSuperview()
        }
    }
    
    func setupPresentedView(){
        guard let presentedView = super.presentedView() else {
            return
        }
        presentedView.autoresizingMask = [.None]
        presentedView.frame.origin = CGPointMake(0, 0)
        presentedView.frame.size = helper.finalFrameInContainerView(containerView!).size
        let wrapperView = UIView(frame:presentedView.frame)
        wrapperView.clipsToBounds = true
        wrapperView.addSubview(presentedView)
        containerView?.addSubview(wrapperView)
        self.wrapperView = wrapperView
    }
    
    func dimmingViewTapped(sender: UITapGestureRecognizer) {
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}

