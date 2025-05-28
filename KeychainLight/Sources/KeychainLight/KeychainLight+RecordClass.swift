//
//  Keychain+RecordClass.swift
//  Wallet
//
//  Created by Illia Suvorov on 28.05.2025.
//

import Foundation

extension KeychainLight {
    enum RecordClass: RawRepresentable, CaseIterable {
        typealias RawValue = CFString
        
        case generic
        case password
        case certificate
        case cryptography
        case identity
        
        init?(rawValue: CFString) {
            switch rawValue {
            case kSecClassGenericPassword:
                self = .generic
            case kSecClassInternetPassword:
                self = .password
            case kSecClassCertificate:
                self = .certificate
            case kSecClassKey:
                self = .cryptography
            case kSecClassIdentity:
                self = .identity
            default:
                return nil
            }
        }
        
        var rawValue: CFString {
            switch self {
            case .generic:
                kSecClassGenericPassword
            case .password:
                kSecClassInternetPassword
            case .certificate:
                kSecClassCertificate
            case .cryptography:
                kSecClassKey
            case .identity:
                kSecClassIdentity
            }
        }
        
        var supportsSynchronizable: Bool {
                switch self {
                case .generic, .password:
                    return true
                default:
                    return false
                }
            }
    }
}
