//
//  ListViewController.swift
//  MyMVVMC
//
//  Created by astroboy0803 on 2020/8/20.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    private enum SegmentedKind: Int {
        case input = 0
        case toBeAdded = 1
    }
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("〈 離開", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26, weight: .bold)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        return button
    }()
    
    private let segmented: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Seg1", "Seg2"])
        let msgAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        segmented.setTitleTextAttributes(msgAttributes, for: .normal)
        segmented.setTitleTextAttributes(msgAttributes, for: .selected)
        
        segmented.layer.borderWidth = 1
        segmented.layer.borderColor = UIColor.darkGray.cgColor
        
        if #available(iOS 13.0, *) {
            segmented.selectedSegmentTintColor = UIColor(displayP3Red: .zero, green: 133.0 / 255.0, blue: 65.0 / 255.0, alpha: 1)
        } else {
            segmented.tintColor = UIColor(displayP3Red: .zero, green: 133.0 / 255.0, blue: 65.0 / 255.0, alpha: 1)
        }
        
        segmented.selectedSegmentIndex = 0
        return segmented
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        let plusAttribute = NSMutableAttributedString(string: "⊕\n", attributes: [.font: UIFont.systemFont(ofSize: 32)])
        let titleAttribute = NSAttributedString(string: "Detail", attributes: [.font: UIFont.systemFont(ofSize: 22)])
        plusAttribute.append(titleAttribute)
        button.setAttributedTitle(plusAttribute, for: .normal)
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
    
    private var viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.registers()
        self.addTargets()
        
        // 初始處理
        self.segmented.selectedSegmentIndex = 0
        self.substiudeConetent(self.segmented)
    }
    
    // MARK: 設定ui
    final private func setupUI() {
        self.view.backgroundColor = UIColor(displayP3Red: 224.0/255.0, green: 216.0/255.0, blue: 200.0/255.0, alpha: 1)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let barView = UIView()
        barView.backgroundColor = UIColor(displayP3Red: 26.0 / 255.0, green: 174.0 / 255.0, blue: 87.0 / 255.0, alpha: 1)
        
        [self.leftButton, self.segmented, self.rightButton].forEach({
            barView.addSubview($0)
        })
        
        self.collectionView.backgroundColor = .systemBlue
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
            self.segmented,
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
            
            self.segmented.bottomAnchor.constraint(equalTo: barView.bottomAnchor, constant: -15),
            self.segmented.widthAnchor.constraint(equalTo: barView.widthAnchor, multiplier: 0.5),
            self.segmented.heightAnchor.constraint(equalToConstant: 60),
            self.segmented.centerXAnchor.constraint(equalTo: barView.centerXAnchor),
            
            self.leftButton.leadingAnchor.constraint(equalTo: barView.leadingAnchor, constant: 15),
            self.leftButton.widthAnchor.constraint(equalToConstant: 120),
            self.leftButton.heightAnchor.constraint(equalToConstant: 40),
            self.leftButton.bottomAnchor.constraint(equalTo: self.segmented.bottomAnchor),
            
            self.rightButton.widthAnchor.constraint(equalTo: self.leftButton.widthAnchor, multiplier: 1.2),
            self.rightButton.topAnchor.constraint(equalTo: self.segmented.topAnchor),
            self.rightButton.bottomAnchor.constraint(equalTo: barView.bottomAnchor, constant: 10),
            self.rightButton.trailingAnchor.constraint(equalTo: barView.trailingAnchor, constant: -15),
            
            self.collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            self.collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            self.collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            self.collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
        ])
    }
    
    // TODO:
    // MARK: 註冊cell
    final private func registers() {
        
    }
    
    // MARK: 元件加入事件
    final private func addTargets() {
        self.segmented.addTarget(self, action: #selector(self.substiudeConetent(_:)), for: .valueChanged)
        self.leftButton.addTarget(self, action: #selector(self.leavePage(_:)), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(self.createCase(_:)), for: .touchUpInside)
    }
    
    @objc
    final private func createCase(_ sender: UIButton) {
        self.viewModel.inputs.createAction()
    }
    
    @objc
    final private func leavePage(_ sender: UIButton) {
        self.viewModel.inputs.closeAction()
    }
    
    @objc
    final private func substiudeConetent(_ sender: UISegmentedControl) {
//        guard let kind = SegmentedKind(rawValue: sender.selectedSegmentIndex) else {
//            return
//        }        
    }
}
