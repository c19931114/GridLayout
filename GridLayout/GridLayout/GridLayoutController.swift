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
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let lineSpace: CGFloat = 5

    var timer: Timer?

//    var pastTime: Int? {
//
//        didSet {
//
//        }
//    }

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

        startRandom()

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

    func startRandom() {

        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (_) in

            let now = Date()
            let formatter = DateFormatter()
            //"yyyy/MMM/dd E HH:mm:ss "
            formatter.dateFormat = "HH:mm:ss"
            let currentTime = formatter.string(from: now)
            print(currentTime)

            self.handleRandom()

        })

    }

    func handleRandom() {

        print("random")

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

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: colorCellID,
                for: indexPath) as? ColorCell else {

                    return UICollectionViewCell()
            }

            var row = indexPath.row / Int(columnCount)

            if row > 2 {
                row = row % 3
            }

            switch row {

            case 0:

                cell.topView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
                cell.bottomView.backgroundColor = #colorLiteral(red: 0.6705882353, green: 0.2117647059, blue: 0.1882352941, alpha: 1)

            case 1:

                cell.topView.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.9607843137, blue: 0.9058823529, alpha: 1)
                cell.bottomView.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.6117647059, blue: 0.1882352941, alpha: 1)

            default:

                cell.topView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9294117647, blue: 0.9176470588, alpha: 1)
                cell.bottomView.backgroundColor = #colorLiteral(red: 0.7529411765, green: 0.3529411765, blue: 0.2274509804, alpha: 1)

            }

            return cell

        default:

            guard let confirmCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: confirmCellID,
                for: indexPath) as? ConfirmCell else {

                    return UICollectionViewCell()
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
