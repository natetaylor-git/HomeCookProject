//
//  PushAnimator.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 04/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        toViewController?.view.transform = CGAffineTransform.identity
        fromViewController?.view.transform = CGAffineTransform.identity
        
        containerView.insertSubview(toViewController!.view, belowSubview: fromViewController!.view)
        
        toViewController?.view.alpha = 0.0
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6, animations: {
                fromViewController?.view.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
                fromViewController?.view.alpha = 0.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                toViewController?.view.alpha = 1.0
            })
        }, completion: { finished in
            fromViewController?.view.transform = CGAffineTransform.identity
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        })
        
    }
    
}
