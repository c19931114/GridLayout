//
//  CustomCell.swift
//  GridLayout
//
//  Created by Crystal on 2018/12/1.
//  Copyright © 2018 Crystal. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {

    let topView: UIView = {

        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    let bottomView: UIView = {

        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var randomLabel: UILabel = {

        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    // 沒有 xib 走這邊
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .black

        setupView()

    }

    private func setupView() {

        contentView.addSubview(bottomView)
        bottomView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 12).isActive = true

        contentView.addSubview(topView)
        topView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true

    }

    // 有 xib 走這邊
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
