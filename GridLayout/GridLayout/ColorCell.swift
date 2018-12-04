//
//  CustomCell.swift
//  GridLayout
//
//  Created by Crystal on 2018/12/1.
//  Copyright © 2018 Crystal. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {

    var row: Int? {
        
        didSet {
            
            switch row {

            case 0:

                topView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
                bottomView.backgroundColor = #colorLiteral(red: 0.6705882353, green: 0.2117647059, blue: 0.1882352941, alpha: 1)

            case 1:

                topView.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.9607843137, blue: 0.9058823529, alpha: 1)
                bottomView.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.6117647059, blue: 0.1882352941, alpha: 1)

            default:

                topView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9294117647, blue: 0.9176470588, alpha: 1)
                bottomView.backgroundColor = #colorLiteral(red: 0.7529411765, green: 0.3529411765, blue: 0.2274509804, alpha: 1)

            }
        }
    }

    var randomItemIsHidden: Bool? {
        
        didSet {

            if let isHidden = randomItemIsHidden {

                if isHidden {

                    randomLabel.text = nil

                } else {

                    randomLabel.text = "random"

                }
            }
        }
    }

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

        setupView()

    }

    // 有 xib 走這邊
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {

        contentView.backgroundColor = .black

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

        topView.addSubview(randomLabel)
        randomLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        randomLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true

    }

}
