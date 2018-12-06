//
//  GridLayoutController.swift
//  GridLayout
//
//  Created by Crystal on 2018/12/1.
//  Copyright © 2018 Crystal. All rights reserved.
//

import UIKit

protocol GridLayoutDelegate: AnyObject {

    func numberOfColumn() -> CGFloat

    func numberOfRow() -> CGFloat

}

class GridLayoutController: UIViewController {

    let fullScreenSize = UIScreen.main.bounds.size
    let colorCellID = "colorCellID"
    let confirmCellID = "confirmCellID"

    var columnCount: CGFloat = 0
    var rowCount: CGFloat = 0

    var randomColumn: Int?
    var randomRow: Int?

    let lineSpace: CGFloat = 2
    var itemWidth: CGFloat = 0
    var itemHeight: CGFloat = 0


    var timer: Timer?

    weak var delegate: GridLayoutDelegate?

    lazy var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(
            frame: self.view.frame,
            collectionViewLayout: layout
        )
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    lazy var confirmButton: UIButton = {

        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(stopRandom), for: .touchUpInside)

        return button

    }()

    lazy var highlightRectangle: UIView = {

        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = lineSpace
        view.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8156862745, blue: 0.8274509804, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(confirmButton)
        confirmButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: itemHeight + lineSpace).isActive = true
        confirmButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        return view

    }()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        guard let delegate = delegate else { return }
        columnCount = delegate.numberOfColumn()
        rowCount = delegate.numberOfRow()

        setupCollectionView()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startRandomWith(Int(columnCount), Int(rowCount))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        timer?.invalidate()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        highlightRectangle.removeFromSuperview()

        collectionView.reloadData()

        view.addSubview(highlightRectangle)
    }

    private func setupCollectionView() {

        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: colorCellID)
        collectionView.register(ConfirmCell.self, forCellWithReuseIdentifier: confirmCellID)
        
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)

        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }

    func startRandomWith(_ column: Int, _ row: Int) {

        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (_) in

            let now = Date()
            let formatter = DateFormatter() // "yyyy/MMM/dd E HH:mm:ss "
            formatter.dateFormat = "HH:mm:ss"
            let currentTime = formatter.string(from: now)

            print(currentTime)

            self.highlightRectangle.removeFromSuperview()
            self.randomColumn = Int.random(in: 1...column)
            self.randomRow = Int.random(in: 1...row)

            self.collectionView.reloadData()

            print(self.randomColumn!)
            print("-----")
        })

    }

}

extension GridLayoutController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        switch section {
        case 0:
            return Int(columnCount * rowCount)
        default:
            return Int(columnCount)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {

        case 0:

            guard let colorCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: colorCellID,
                for: indexPath) as? ColorCell else {

                    return UICollectionViewCell()
            }

            var row = indexPath.item / Int(columnCount)

            if row > 2 {
                row = row % 3
            }

            colorCell.row = row

//            print("color: \(randomColumn) \(randomRow)")

            if let randomColumn = randomColumn, let randomRow = randomRow {

                let randomItem = Int(columnCount) * (randomRow - 1) + randomColumn - 1
                
                if indexPath.item == randomItem{
                    colorCell.randomItemIsHidden = false

                } else {
                    colorCell.randomItemIsHidden = true
                }

            } else {
                colorCell.randomItemIsHidden = true
            }

            return colorCell

        default:

            guard let confirmCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: confirmCellID,
                for: indexPath) as? ConfirmCell else {

                    return UICollectionViewCell()
            }

            confirmCell.delegate = self

//            print("confirm: \(randomColumn)")

            if let randomColumn = randomColumn {

                if indexPath.item == randomColumn - 1 {
                    confirmCell.selectable = true

                    view.addSubview(highlightRectangle)
                    highlightRectangle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: itemWidth * CGFloat(randomColumn - 1) + lineSpace * CGFloat(randomColumn) - 1).isActive = true
                    highlightRectangle.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                    print("randomColumn: \(randomColumn)")
                    print(">>>")
                    highlightRectangle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / columnCount).isActive = true
                    highlightRectangle.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true


                }
                else {
                    confirmCell.selectable = false
                }

            } else {
                // after tapping to stop random
                confirmCell.selectable = false
                highlightRectangle.removeFromSuperview()
            }

            return confirmCell
        }


    }

}

extension GridLayoutController: ConfirmCellDelegate { // 修改後不需要此 protocol

    @objc func stopRandom() {
        randomColumn = nil
        randomRow = nil
        collectionView.reloadData()
    }

}

extension GridLayoutController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: lineSpace, bottom: lineSpace, right: lineSpace)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return lineSpace // 上下
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpace // 左右
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width - lineSpace * (columnCount + 1)
        let height = collectionView.frame.height - lineSpace * (rowCount + 1)

        itemWidth = width / CGFloat(columnCount)
        itemHeight = height / CGFloat(rowCount + 1)

        return CGSize(
            width: itemWidth,
            height: itemHeight
        )

    }
}
