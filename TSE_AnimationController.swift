//
//  TSE_AnimationController.swift
//  MobileEmbrace
//
//  Created by HeYilei on 4/03/2016.
//  Copyright © 2016 Omni Market Tide. All rights reserved.
//

import UIKit

class TSE_AnimationController: NSObject, UIViewControllerAnimatedTransitioning, PresentDismissAnimation {
    var cachedFrameBeforePresenting:CGRect?
    var isPresenting:Bool = true
    weak var helper:TSE_TransitionHelper!
    init(helper:TSE_TransitionHelper){
        super.init()
        self.helper = helper
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresenting {
            performPresentAnimation(transitionContext)
        }else{
            performDismissAnimation(transitionContext)
        }
        
    }
    
    private func performPresentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        /* prepare parameters */
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        var toViewInitialFrame = transitionContext.initialFrameForViewController(toViewController!)
        var toViewFinalFrame = transitionContext.finalFrameForViewController(toViewController!)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        let containerView = transitionContext.containerView()!
        
        /* define initial status */
        toViewInitialFrame = helper.initialFrameInContainerView(containerView)
        toView?.frame = toViewInitialFrame
        
        /* define final status */
        toViewFinalFrame = helper.finalFrameInContainerView(containerView)
        
        /* start animation */
        let transitionDuration = self.transitionDuration(transitionContext)
        let completionClosure:(Bool)->Void = { (finished) -> Void in
            let wasCancelled = transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(!wasCancelled)
        }
        
        
       
        UIView.animateWithDuration(transitionDuration / 2, animations: { () -> Void in
            /* step 1 */
            toView?.frame.size.width = toViewFinalFrame.size.width
            
            }, completion: {(finished) -> Void in
                UIView.animateWithDuration(transitionDuration * 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
                    /* step 2 */
                    toView?.frame = toViewFinalFrame
                    }, completion: completionClosure)
        })
        
    }
    
    private func performDismissAnimation(transitionContext: UIViewControllerContextTransitioning) {

        /* prepare parameters */
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var fromViewFinalFrame = transitionContext.finalFrameForViewController(fromViewController!)
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let containerView = transitionContext.containerView()!
        
        /* define final status */
        fromViewFinalFrame = helper.initialFrameInContainerView(containerView)
        
        /* start animation */
        let transitionDuration = self.transitionDuration(transitionContext)
        let completionClosure:(Bool)->Void = { (finished) -> Void in
            let wasCancelled = transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(!wasCancelled)
        }
        UIView.animateWithDuration(transitionDuration / 2, animations: { () -> Void in
            fromView?.frame.size.height = fromViewFinalFrame.size.height
            fromView?.frame.origin = fromViewFinalFrame.origin
            }, completion: {(finished) -> Void in
                UIView.animateWithDuration(transitionDuration, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
                    fromView?.frame = fromViewFinalFrame
                    }, completion: completionClosure)
        })

    }
    
}
