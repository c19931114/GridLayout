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

    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let lineSpace: CGFloat = 5

    var timer: Timer?

    weak var delegate: GridLayoutDelegate?

    lazy var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(
            frame: view.frame,
            collectionViewLayout: layout
        )
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        guard let delegate = delegate else { return }
        columnCount = delegate.numberOfColumn()
        rowCount = delegate.numberOfRow()

        setupCollectionView()

        startRandomWith(Int(columnCount), Int(rowCount))

    }

    private func setupCollectionView() {

        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: colorCellID)
        collectionView.register(ConfirmCell.self, forCellWithReuseIdentifier: confirmCellID)
        
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
        collectionView.frame = CGRect(
            x: 0,
            y: statusBarHeight,
            width: fullScreenSize.width,
            height: fullScreenSize.height)

    }

    func startRandomWith(_ column: Int, _ row: Int) {

        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (_) in

            let now = Date()
            let formatter = DateFormatter() // "yyyy/MMM/dd E HH:mm:ss "
            formatter.dateFormat = "HH:mm:ss"
            let currentTime = formatter.string(from: now)
            print("-----")
            print(currentTime)

            self.randomColumn = Int.random(in: 1...column)
            self.randomRow = Int.random(in: 1...row)

            self.collectionView.reloadData()

            print(self.randomColumn!)
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

            return colorCell

        default:

            guard let confirmCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: confirmCellID,
                for: indexPath) as? ConfirmCell else {

                    return UICollectionViewCell()
            }

            if let randomColumn = randomColumn {

                if indexPath.item == randomColumn - 1 {
                    confirmCell.highlightView.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.8156862745, blue: 0.8274509804, alpha: 1)
                    confirmCell.highlightView.isUserInteractionEnabled = true

                } else {
                    confirmCell.highlightView.backgroundColor = .lightGray
                    confirmCell.highlightView.isUserInteractionEnabled = false
                }

            }

            return confirmCell
        }


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

//        let width = fullScreenSize.width - lineSpace * (columnCount + 1)
//        let height = fullScreenSize.height - statusBarHeight - lineSpace * (rowCount + 1)

        let width = view.frame.width - lineSpace * (columnCount + 1)
        let height = view.frame.height - statusBarHeight - lineSpace * (rowCount + 1)

        return CGSize(
            width: width / CGFloat(columnCount),
            height: height / CGFloat(rowCount + 1)
        )

    }
}
