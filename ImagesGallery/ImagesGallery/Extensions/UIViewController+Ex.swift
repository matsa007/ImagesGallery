//
//  UIViewController+Ex.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 20.03.24.
//

import UIKit

extension UIViewController {
    func alertForError(for error: Error, with alertTitle: ErrorTitles, with actionTitle: ErrorTitles) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: alertTitle.rawValue,
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            
            alert.addAction(
                UIAlertAction(
                    title: actionTitle.rawValue,
                    style: .cancel,
                    handler: nil
                )
            )
            
            self.present(
                alert,
                animated: true,
                completion: nil
            )
        }
    }
}
