//
//  HomeViewController.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/2.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let pushButton = UIButton()
    
    let presentButton = UIButton()
    
    let tabButton = UIButton()
    
    private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTargets()
    }
    
    final private func setupTargets() {
        self.presentButton.addTarget(self, action: #selector(self.doPresent(_:)), for: .touchUpInside)
        self.pushButton.addTarget(self, action: #selector(self.doPush(_:)), for: .touchUpInside)
        self.tabButton.addTarget(self, action: #selector(self.doTab(_:)), for: .touchUpInside)
    }
    
    final private func setupUI() {
        
        self.view.backgroundColor = UIColor(displayP3Red: 224.0/255.0, green: 216.0/255.0, blue: 200.0/255.0, alpha: 1)
        
        self.tabButton.setTitle("Tab", for: .normal)
        self.pushButton.setTitle("Push", for: .normal)
        self.presentButton.setTitle("Present", for: .normal)
        
        [self.tabButton, self.pushButton, self.presentButton].forEach({
            $0.titleLabel?.font = .systemFont(ofSize: 36, weight: .semibold)
            $0.setTitleColor(.white, for: .normal)
            
            $0.setBackgroundImage(UIColor.systemBlue.toImage, for: .normal)
            $0.setTitleColor(.white, for: .highlighted)
            $0.setBackgroundImage(UIColor.black.toImage, for: .highlighted)
        })
        
        let contentView = UIStackView(arrangedSubviews: [self.tabButton, self.presentButton, self.pushButton])
        contentView.axis = .vertical
        contentView.spacing = 5
        contentView.distribution = .fillEqually
        
        self.view.addSubview(contentView)
        
        UIView.translateConstraints(isAuto: false)([
            contentView, self.tabButton, self.pushButton, self.presentButton
        ])
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2),
            contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3),
        ])
    }
    
    @objc
    final private func doTab(_ sender: UIButton) {
        self.viewModel.inputs.tabAction()
    }
    
    @objc
    final private func doPresent(_ sender: UIButton) {
        self.viewModel.inputs.presentAction()
    }
    
    @objc
    final private func doPush(_ sender: UIButton) {
        self.viewModel.inputs.pushAction()
    }
}
