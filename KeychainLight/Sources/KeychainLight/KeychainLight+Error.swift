//
//  Keychain+Error.swift
//  Wallet
//
//  Created by Illia Suvorov on 28.05.2025.
//

import Foundation

extension KeychainLight {
    enum Error: Swift.Error, Equatable {
        case invalidData
        case recordNotFound
        case duplicateItem
        case incorrectAttributeForClass
        case failedToRemoveAllRecords
        case unexpected(OSStatus)
        
        init(_ status: OSStatus) {
            switch status {
            case errSecItemNotFound:
                self = .recordNotFound
            case errSecDataTooLarge:
                self = .invalidData
            case errSecDuplicateItem:
                self = .duplicateItem
            default:
                self = .unexpected(status)
            }
        }
        
        var localizedDescription: String {
            switch self {
            case .invalidData:
                return "Invalid data"
            case .recordNotFound:
                return "Item not found"
            case .duplicateItem:
                return "Duplicate Item"
            case .incorrectAttributeForClass:
                return "Incorrect Attribute for Class"
            case .unexpected(let oSStatus):
                return "Unexpected error - \(oSStatus)"
            case .failedToRemoveAllRecords:
                return "Failed to remove all records"
            }
        }
    }
}
