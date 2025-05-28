//
//  Keychain.swift
//  Wallet
//
//  Created by Illia Suvorov on 28.05.2025.
//

import Foundation

class KeychainLight {
    typealias Dictionary = [CFString : AnyHashable]
    
    func save<T: Encodable>(
        record: Record<T>,
        attributes: Dictionary? = nil) throws {
            try save(
                record: record.value,
                recordClass: record.recordClass,
                key: record.key,
                attributes: attributes
            )
        }
        
    func save<T: Encodable>(
        record: T,
        recordClass: RecordClass,
        key: String,
        attributes: Dictionary? = nil
    ) throws {
        let recordData = try JSONEncoder().encode(record)
        
        var query: Dictionary = [
            kSecClass: recordClass.rawValue,
            kSecAttrAccount: key,
            kSecValueData: recordData
        ]
        
        if let attributes = attributes {
            for (key, value) in attributes {
                query[key] = value
            }
        }
        
        let result = SecItemAdd(query as CFDictionary, nil)
        
        if result != errSecSuccess {
            throw Error(result)
        }
    }
    
    func load<T: Decodable>(
        record: inout Record<T>,
        attributes: Dictionary? = nil
    ) throws {
        record.value = try load(
            recordClass: record.recordClass,
            key: record.key,
            attributes: attributes
        )
        
    }
    
    func load<T: Decodable>(
        recordClass: RecordClass,
        key: String,
        attributes: Dictionary? = nil
    ) throws -> T {
        var query: Dictionary = [
            kSecClass: recordClass.rawValue,
            kSecAttrAccount: key,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        if let attributes = attributes {
            for(key, value) in attributes {
                query[key] = value
            }
        }
        
        var item: CFTypeRef?
        let result = SecItemCopyMatching(query as CFDictionary, &item)
        
        if result != errSecSuccess {
            throw Error(result)
        }
        
        guard
            let item = item as? Dictionary,
            let data = item[kSecValueData] as? Data else {
            throw Error.invalidData
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func update<T: Encodable>(record: Record<T>, attributes: Dictionary? = nil) throws {
        try update(
            record: record.value,
            recordClass: record.recordClass,
            key: record.key,
            attributes: attributes
        )
    }
    
    func update<T: Encodable>(record: T, recordClass: RecordClass, key: String, attributes: Dictionary? = nil) throws {
        let recordData = try JSONEncoder().encode(record)
        
        var query: Dictionary = [
            kSecClass: recordClass.rawValue,
            kSecAttrAccount: key,
        ]
        
        if let attributes = attributes {
            for(key, value) in attributes {
                query[key] = value
            }
        }
        
        let attributesToUpdate: Dictionary = [
            kSecValueData: recordData
        ]
        
        let result = SecItemUpdate(
            query as CFDictionary,
            attributesToUpdate as CFDictionary
        )
        
        if result != errSecSuccess {
            throw Error(result)
        }
    }
    
    func delete<T>(record: inout Record<T>, attributes: Dictionary? = nil) throws {
        try delete(
            recordClass: record.recordClass,
            key: record.key,
            attributes: attributes
        )
        record.value = nil
    }
    
    func delete(recordClass: RecordClass, key: String, attributes: Dictionary? = nil) throws {
        var query: Dictionary = [
            kSecClass: recordClass.rawValue,
            kSecAttrAccount: key
        ]
        
        if let attributes = attributes {
            for (key, value) in attributes {
                query[key] = value
            }
        }
        
        let result = SecItemDelete(query as CFDictionary)
        if result != errSecSuccess && result != errSecItemNotFound {
            throw Error(result)
        }
    }
    
    func removeAll() throws {
        try RecordClass.allCases.forEach { recordClass in
            
            var query: Dictionary = [
                kSecClass: recordClass.rawValue
            ]
                    
            // Add kSecAttrSynchronizable only if supported
            if recordClass.supportsSynchronizable {
                query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
            }
            
            let status = SecItemDelete(query as CFDictionary)
            if status != errSecSuccess && status != errSecItemNotFound && status != errSecInvalidOwnerEdit{
                if (errSecWrPerm == status) {
                    print("wtf?")
                }
                throw Error.failedToRemoveAllRecords
            }
        }
    }
}
