//
//  ConfimCell.swift
//  GridLayout
//
//  Created by Crystal on 2018/12/1.
//  Copyright © 2018 Crystal. All rights reserved.
//

import UIKit

protocol ConfirmCellDelegate: AnyObject {

    func confirmToStopRandom()
}

class ConfirmCell: UICollectionViewCell {

    let lineSpace: CGFloat = 5

    weak var delegate: ConfirmCellDelegate?

    var selectable: Bool? {

        didSet {

            if let selectable = selectable {

                if selectable {

                    highlightView.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.8156862745, blue: 0.8274509804, alpha: 1)
                    highlightView.isUserInteractionEnabled = true
                    
                } else {

                    highlightView.backgroundColor = .lightGray
                    highlightView.isUserInteractionEnabled = false

                }

            }

        }
    }

    lazy var highlightView: UIView = {

        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false

        view.isUserInteractionEnabled = false // default is true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stopRandom)))
        // lazy var 才抓得到 self
        // You cannot initialize the gesture recognizer with a reference to self because the initialization is not completed at that point.

        return view
    }()

    let confirmLabel: UILabel = {

        let label = UILabel()
        label.textAlignment = .center
        label.text = "確定"
        label.backgroundColor = .clear
        label.textColor = .white
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

    @objc func stopRandom(tapGesture: UITapGestureRecognizer) {

        print("tap")
        delegate?.confirmToStopRandom()

    }

    private func setupView() {

        contentView.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)

        contentView.addSubview(highlightView)
        highlightView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        highlightView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        highlightView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -lineSpace).isActive = true
        highlightView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -lineSpace) .isActive = true

        highlightView.addSubview(confirmLabel)
        confirmLabel.leftAnchor.constraint(equalTo: highlightView.leftAnchor).isActive = true
        confirmLabel.bottomAnchor.constraint(equalTo: highlightView.bottomAnchor).isActive = true
        confirmLabel.rightAnchor.constraint(equalTo: highlightView.rightAnchor).isActive = true
        confirmLabel.heightAnchor.constraint(equalTo: highlightView.heightAnchor, multiplier: 1 / lineSpace) .isActive = true

    }

}
