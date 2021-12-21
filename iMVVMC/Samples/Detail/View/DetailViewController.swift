//
//  DetailViewController.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/9/2.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("〈 回上頁", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26, weight: .bold)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.backgroundColor = UIColor(displayP3Red: 230.0 / 255.0, green: 82.0 / 255.0, blue: 18.0 / 255.0, alpha: 1)
        return label
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("Page", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(displayP3Red: 232.0 / 255.0, green: 222.0 / 255.0, blue: .zero, alpha: 1)
        button.setBackgroundImage(UIColor.black.withAlphaComponent(0.3).toImage, for: .highlighted)
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowColor = UIColor(displayP3Red: CGFloat(14 / 255), green: CGFloat(107 / 255), blue: CGFloat(43 / 255), alpha: 1).cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
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
                
        self.titleLabel.text = "Topic"
        self.countLabel.text = "D"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final private func setupTargets() {
        self.leftButton.addTarget(self, action: #selector(self.previousPage(_:)), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(self.goToPage(_:)), for: .touchUpInside)
    }
    
    final private func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let countEdge: CGFloat = 30
        self.countLabel.layer.masksToBounds = true
        self.countLabel.layer.cornerRadius = countEdge / 2
        
        self.view.backgroundColor = UIColor(displayP3Red: 224.0/255.0, green: 216.0/255.0, blue: 200.0/255.0, alpha: 1)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let barView = UIView()
        barView.backgroundColor = UIColor(displayP3Red: 26.0 / 255.0, green: 174.0 / 255.0, blue: 87.0 / 255.0, alpha: 1)
        
        [self.leftButton, self.titleLabel, self.countLabel, self.rightButton].forEach({
            barView.addSubview($0)
        })
        
        self.collectionView.backgroundColor = .systemGray
        let contentView = UIView()
        [self.collectionView].forEach({
            contentView.addSubview($0)
        })
        
        [barView, contentView].forEach({ [superView = self.view] in
            superView?.addSubview($0)
        })
        
        UIView.translateConstraints(isAuto: false)([
            barView,
            self.leftButton,
            self.titleLabel,
            self.countLabel,
            self.rightButton,
            contentView,
            self.collectionView
        ])
        
        let safeLeading: NSLayoutXAxisAnchor
        let safeTrailing: NSLayoutXAxisAnchor
        let safeBottom: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            safeLeading = self.view.safeAreaLayoutGuide.leadingAnchor
            safeTrailing = self.view.safeAreaLayoutGuide.trailingAnchor
            safeBottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            safeLeading = self.view.leadingAnchor
            safeTrailing = self.view.trailingAnchor
            safeBottom = self.bottomLayoutGuide.topAnchor
        }
        
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: self.view.topAnchor),
            barView.leadingAnchor.constraint(equalTo: safeLeading),
            barView.trailingAnchor.constraint(equalTo: safeTrailing),
            barView.heightAnchor.constraint(equalToConstant: 135),
            
            contentView.topAnchor.constraint(equalTo: barView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeBottom),
            contentView.leadingAnchor.constraint(equalTo: safeLeading),
            contentView.trailingAnchor.constraint(equalTo: safeTrailing),
            
            self.leftButton.leadingAnchor.constraint(equalTo: barView.leadingAnchor, constant: 15),
            self.leftButton.widthAnchor.constraint(equalToConstant: 120),
            self.leftButton.heightAnchor.constraint(equalToConstant: 40),
            self.leftButton.bottomAnchor.constraint(equalTo: barView.bottomAnchor, constant: -15),
            
            self.rightButton.widthAnchor.constraint(equalTo: self.leftButton.widthAnchor, multiplier: 1.2),
            self.rightButton.heightAnchor.constraint(equalTo: self.leftButton.heightAnchor, constant: 20),
            self.rightButton.bottomAnchor.constraint(equalTo: self.leftButton.bottomAnchor),
            self.rightButton.trailingAnchor.constraint(equalTo: barView.trailingAnchor, constant: -15),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.rightButton.topAnchor, constant: -5),
            self.titleLabel.widthAnchor.constraint(lessThanOrEqualTo: barView.widthAnchor, multiplier: 0.5),
            self.titleLabel.centerXAnchor.constraint(equalTo: barView.centerXAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.leftButton.bottomAnchor, constant: 5),
            
            self.countLabel.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 5),
            self.countLabel.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.countLabel.widthAnchor.constraint(equalToConstant: countEdge),
            self.countLabel.heightAnchor.constraint(equalToConstant: countEdge),
            
            self.collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            self.collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            self.collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            self.collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
        ])
    }
    
    @objc
    final private func previousPage(_ sender: UIButton) {
        self.viewModel.inputs.previousAction()
    }
    
    @objc
    final private func goToPage(_ sender: UIButton) {
        self.viewModel.inputs.goToPageAction()
    }
    
}
