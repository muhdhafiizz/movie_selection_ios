//
//  Extensions.swift
//  Movie Selection
//
//  Created by Hafiz on 22/09/2024.
//

import Foundation


extension String {
    func capitalizedFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
