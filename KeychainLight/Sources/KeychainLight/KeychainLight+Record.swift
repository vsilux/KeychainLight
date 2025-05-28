//
//  Keychain+Record.swift
//  Wallet
//
//  Created by Illia Suvorov on 28.05.2025.
//

import Foundation

extension KeychainLight {
    struct Record<T: Codable> {
        var key: String
        var recordClass: RecordClass
        var value: T?
    }
}

