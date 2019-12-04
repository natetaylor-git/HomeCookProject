//
//  DropFilter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 03/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol DropDownViewHolderProtocol: UIView {
    func updateSuperviewScroll()
    func undoUpdateSuperViewScroll()
    func bringMenuHolderToFront()
    func sendMenuHolderBack()
}

class FilterViewOfDropType: UIView, DropDownViewHolderProtocol {
    let headerLabel = UILabel()
    let titleLabel = UILabel()
    let valueButton: DropDownView
    
    var needChangeScrollContentSize = false
    var needChangeScrollOffset = false
    
    var oldOffset: CGPoint = .zero
    var updatedOffset: CGPoint = .zero
    var extraDeltaForBeauty: CGFloat = .zero
    var dropMenuBottomPadding: CGFloat = 10
    var headerHeight: CGFloat = 0
    
    init(title: String, frame: CGRect, values: [String]) {
        self.headerLabel.frame = CGRect(origin: .zero,
                                        size:CGSize(width: frame.width, height: headerHeight))
        self.headerLabel.backgroundColor = UIColor.lightGreen
        
        self.titleLabel.frame = CGRect(origin: CGPoint(x: 0, y: self.headerLabel.frame.maxY),
                                       size: CGSize(width: frame.width,
                                                    height: (frame.height - headerHeight) / 2))
        
        let valueButtonFrame = CGRect(origin: CGPoint(x: 0, y:  self.titleLabel.frame.maxY),
                                      size: CGSize(width: frame.width,
                                                   height: self.titleLabel.frame.height))
        self.valueButton = DropDownView(frame: valueButtonFrame)
        
        super.init(frame: frame)
        
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.lightGreen.cgColor
        
        self.titleLabel.text = title
        self.titleLabel.textAlignment = .center
        self.titleLabel.backgroundColor = .white
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        self.valueButton.setTitle("All", for: .normal)
        self.valueButton.setTitleColor(.black, for: .normal)
        self.valueButton.dropMenu.dropDownValues = values
        let height = self.valueButton.dropMenu.cellHeight * CGFloat(values.count) + self.dropMenuBottomPadding
        self.valueButton.dropMenuHeight = height
        self.valueButton.holderView = self
        
        self.addSubview(headerLabel)
        self.addSubview(titleLabel)
        self.addSubview(valueButton)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAllFiltersUserInteractionTo(_ enabled: Bool) {
        if let scroll = self.superview as? FiltersView{
            for item in scroll.dropFilters {
                item.isUserInteractionEnabled = enabled
            }
        }
    }
    
    func updateSuperviewScroll() {
        if let scroll = self.superview as? UIScrollView {
            if self.frame.maxY + self.valueButton.dropMenuHeight > scroll.contentSize.height {
                scroll.contentSize = CGSize(width: scroll.contentSize.width,
                                            height: scroll.contentSize.height + self.valueButton.dropMenuHeight)
                self.needChangeScrollContentSize = true
            }
            
            let newFrameMaxY = self.frame.maxY + self.valueButton.dropMenuHeight
            let delta = newFrameMaxY - scroll.bounds.maxY
            
            if delta > 0 {
                let oldOffset = scroll.contentOffset
                let beautifulDelta = delta + extraDeltaForBeauty
                let newOffset = CGPoint(x: oldOffset.x, y: oldOffset.y + beautifulDelta)
                scroll.setContentOffset(newOffset, animated: true)
                self.oldOffset = oldOffset
                self.updatedOffset = newOffset
                self.needChangeScrollOffset = true
            }
        }
    }
    
    func undoUpdateSuperViewScroll() {
        if let scroll = self.superview as? UIScrollView {
            let notScrolledAfterUpdate = (abs(self.updatedOffset.y - scroll.contentOffset.y) < 1.0)
            
            if self.needChangeScrollOffset && !self.needChangeScrollContentSize && notScrolledAfterUpdate {
                scroll.setContentOffset(self.oldOffset, animated: true)
                self.needChangeScrollOffset = false
            }
            
            if self.needChangeScrollContentSize {
                self.needChangeScrollContentSize = false
                UIView.animate(withDuration: 0.5) {
                    scroll.contentSize = CGSize(width: scroll.contentSize.width,
                                                height: scroll.contentSize.height - self.valueButton.dropMenuHeight)
                }
            }
        }
    }
    
    func bringMenuHolderToFront() {
        setAllFiltersUserInteractionTo(false)
        self.isUserInteractionEnabled = true
        self.superview?.bringSubviewToFront(self)
    }
    
    func sendMenuHolderBack() {
        setAllFiltersUserInteractionTo(true)
        self.superview?.sendSubviewToBack(self)
    }
}
