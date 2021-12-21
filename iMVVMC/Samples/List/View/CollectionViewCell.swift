//
//  ListCollectionViewCell.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/8/20.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

protocol ListCellViewModeler: AnyObject {
    
}

class ListCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private final func setupViews() {
        
    }
}
