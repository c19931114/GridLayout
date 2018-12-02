//
//  AlertController.swift
//  GridLayout
//
//  Created by Crystal on 2018/12/1.
//  Copyright © 2018 Crystal. All rights reserved.
//

import UIKit

class AlertManager {

    static let shared = AlertManager()

    private init() {

    }

    func showAlertWith(
        title: String,
        message: String) -> UIAlertController {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default)

        alertController.addAction(action)

        return alertController
    }


}

