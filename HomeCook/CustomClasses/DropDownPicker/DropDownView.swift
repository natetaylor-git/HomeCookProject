//
//  DropDownClasses.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 03/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol DropDownViewProtocol {
    func didSelectValue(named text: String)
}

class DropDownView: UIButton {
    var holderView: DropDownViewHolderProtocol?
    var dropMenu = DropDownMenu()
    var dropMenuHeight: CGFloat = 100
    var isVisible = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .darkGreen
        let buttonFrame = self.frame
        let dropMenuFrame = CGRect(origin: CGPoint(x: buttonFrame.minX, y: buttonFrame.maxY),
                           size: CGSize(width: buttonFrame.width, height: 0))
        dropMenu = DropDownMenu(frame: dropMenuFrame)
        dropMenu.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropMenu)
        self.superview?.bringSubviewToFront(dropMenu)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isVisible == false {
            isVisible = true
            guard let superview = self.superview else {
                return
            }
            
            self.holderView?.bringMenuHolderToFront()
            self.holderView?.updateSuperviewScroll()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropMenu.layoutIfNeeded()
                self.dropMenu.frame.size = CGSize(width: self.frame.width, height: self.dropMenuHeight)
               
                superview.frame.size = CGSize(width: superview.frame.width,
                                              height: superview.frame.height + self.dropMenuHeight)
            }, completion: nil)
        } else {
            dismissTableView()
        }
    }
    
    func dismissTableView() {
        isVisible = false
        guard let superview = self.superview else {
            return
        }
        
        self.holderView?.sendMenuHolderBack()
        self.holderView?.undoUpdateSuperViewScroll()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropMenu.frame.size = CGSize(width: self.frame.width, height: 0)
            self.dropMenu.layoutIfNeeded()
            superview.frame.size = CGSize(width: superview.frame.width,
                                          height: superview.frame.height - self.dropMenuHeight)
        }, completion: nil)
    }
}

extension DropDownView: DropDownViewProtocol {
    func didSelectValue(named text: String) {
        self.setTitle(text, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.dismissTableView()
    }
}
