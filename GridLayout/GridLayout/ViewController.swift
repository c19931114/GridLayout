//
//  ViewController.swift
//  GridLayout
//
//  Created by Crystal on 2018/11/30.
//  Copyright © 2018 Crystal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var columnCount: CGFloat = 0
    var rowCount: CGFloat = 0

    let columnTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Column"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let rowTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Row"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let setButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(handleCheck),
            for: .touchUpInside
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

    }

    private func setupView() {

        view.addSubview(rowTextField)
        rowTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rowTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -64).isActive = true

        view.addSubview(columnTextField)
        columnTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        columnTextField.bottomAnchor.constraint(equalTo: rowTextField.topAnchor, constant: -16).isActive = true

        view.addSubview(setButton)
        setButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setButton.topAnchor.constraint(equalTo: rowTextField.bottomAnchor, constant: +16).isActive = true

    }

    @objc func handleCheck() {

        guard let columnText = columnTextField.text,
            let rowText = rowTextField.text else {

            print("fail to unwrap")

            return
        }

        guard columnText.trimmingCharacters(in: .whitespaces).isEmpty == false,
            rowText.trimmingCharacters(in: .whitespaces).isEmpty == false else {

            print("emptyText")

            let emptyAlertVC = AlertManager.shared.showAlertWith(
                title: "Opps!",
                message: "請勿留空"
            )
                
            present(emptyAlertVC, animated: true, completion: nil)

            return
        }

        guard let column = Int(columnText), let row = Int(rowText)
            , column > 0, row > 0 else {

            let intAlertVC = AlertManager.shared.showAlertWith(
                title: "Opps!",
                message: "請輸入正整數"
            )

            present(intAlertVC, animated: true, completion: nil)

            return
        }

        columnCount = CGFloat(column)
        rowCount = CGFloat(row)

        print("column: \(column)")
        print("row: \(row)")

        createGridLayout()
    }

    func createGridLayout() {

        let gridLayoutVC = GridLayoutController()
        gridLayoutVC.delegate = self

        present(gridLayoutVC, animated: true, completion: nil)
    }
}

extension ViewController: GridLayoutDelegate {
    
    func numberOfColumn() -> CGFloat {

        return columnCount
    }

    func numberOfRow() -> CGFloat {

        return rowCount
    }

}

