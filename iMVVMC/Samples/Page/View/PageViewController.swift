//
//  PageViewController.swift
//  CathayLifeATMI
//
//  Created by astroboy0803 on 2020/8/17.
//  Copyright © 2020 CathayLife. All rights reserved.
//

import UIKit

final class PageViewController: UIViewController {
    
    private let leftButton: UIButton
    
    private var viewModel: PageViewModel
    
    init(viewModel: PageViewModel) {
        self.leftButton = .init()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    private func setupUI() {
        
        self.view.backgroundColor = .systemTeal
        
        let barView = UIView()
        barView.backgroundColor = UIColor(displayP3Red: 26.0 / 255.0, green: 174.0 / 255.0, blue: 87.0 / 255.0, alpha: 1)
        
        leftButton.setTitle("〈 回上頁", for: .normal)
        leftButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .bold)
        leftButton.contentHorizontalAlignment = .left
        leftButton.setTitleColor(.white, for: .normal)
        leftButton.setTitleColor(.darkGray, for: .highlighted)
        
        barView.addSubview(leftButton)
        self.view.addSubview(barView)
        
        UIView.translateConstraints(isAuto: false)([
            barView,
            leftButton
        ])
        
        let safeLeading: NSLayoutXAxisAnchor
        let safeTrailing: NSLayoutXAxisAnchor
        if #available(iOS 11.0, *) {
            safeLeading = self.view.safeAreaLayoutGuide.leadingAnchor
            safeTrailing = self.view.safeAreaLayoutGuide.trailingAnchor
        } else {
            safeLeading = self.view.leadingAnchor
            safeTrailing = self.view.trailingAnchor
        }
        
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: self.view.topAnchor),
            barView.leadingAnchor.constraint(equalTo: safeLeading),
            barView.trailingAnchor.constraint(equalTo: safeTrailing),
            barView.heightAnchor.constraint(equalToConstant: 135),
            
            self.leftButton.leadingAnchor.constraint(equalTo: barView.leadingAnchor, constant: 15),
            self.leftButton.widthAnchor.constraint(equalToConstant: 120),
            self.leftButton.heightAnchor.constraint(equalToConstant: 40),
            self.leftButton.bottomAnchor.constraint(equalTo: barView.bottomAnchor, constant: -15),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTargets()
    }
    
    private func setupTargets() {
        self.leftButton.addTarget(self, action: #selector(self.previousPage(_:)), for: .touchUpInside)
    }
    
    @objc
    private func previousPage(_ sender: UIButton) {
        self.viewModel.inputs.previousAction()
    }
}
