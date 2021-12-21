//
//  UIColorExtenstion.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/2.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

extension UIColor {
    var toImage : UIImage {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return render.image { (context) in
            context.cgContext.setFillColor(self.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }
}
