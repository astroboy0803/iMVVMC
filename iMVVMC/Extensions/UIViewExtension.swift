//
//  UIViewExtension.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/8/20.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

extension UIView {
    // MARK: AutoresizingMask不要轉成Constraints
    static func translateConstraints(isAuto: Bool) -> ([UIView]) -> Void {
        return { views in
            views.forEach({ $0.translatesAutoresizingMaskIntoConstraints = isAuto })
        }
    }
    
    // MARK: 加入subviews
    static func addSubViews(superView: UIView) -> ([UIView]) -> Void {
        return { subviews in
            subviews.forEach({ superView.addSubview($0) })
        }
    }
}
