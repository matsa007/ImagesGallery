//
//  String+Ex.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 21.03.24.
//

import Foundation

extension String {
    func getClientID() -> String {
        URLRequestValues.clientID + self
    }
}
