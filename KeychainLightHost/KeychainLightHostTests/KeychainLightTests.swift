//
//  KeychainLightHostTests.swift
//  KeychainLightHostTests
//
//  Created by Illia Suvorov on 28.05.2025.
//

import XCTest
@testable import KeychainLight

final class KeychainLightHostTests: XCTestCase {

    let defaultKey = "TestKey"
    let defaultValue = "test string"
    
    override func setUpWithError() throws {
        do {
            try KeychainLight().removeAll()
        } catch {
            print(error)
        }
    }
    
    func testKeychainAddRecord() throws {
        let sut = KeychainLight()
        try sut.save(record: defaultValue, recordClass: .generic, key: defaultKey)
    }
    
    func testKeychainLoadRecord() throws {
        let sut = KeychainLight()
        try sut.save(record: defaultValue, recordClass: .generic, key: defaultKey)
        let record: String = try sut.load(recordClass: .generic, key: defaultKey)
        XCTAssertEqual(record, defaultValue, "Loaded item should match the saved value")
    }
    
    func testKeychainUpdateRecord() throws {
        let sut = KeychainLight()
        try sut.save(record: defaultValue, recordClass: .generic, key: defaultKey)
        let recordToUpdate = "updated string"
        try sut.update(record: recordToUpdate, recordClass: .generic, key: defaultKey)
        
        let record: String = try sut.load(recordClass: .generic, key: defaultKey)
        XCTAssertEqual(record, recordToUpdate, "Loaded item should match the saved value")
    }
    
    func testKeychainDeleteRecord() throws {
        let sut = KeychainLight()
        try sut.save(record: defaultValue, recordClass: .generic, key: defaultKey)
        
        try sut.delete(recordClass: .generic, key: defaultKey)
        
        do {
            let _: String = try sut.load(recordClass: .generic, key: defaultKey)
        } catch {
            XCTAssertEqual(error as? KeychainLight.Error, KeychainLight.Error.recordNotFound, "Should throw record not found error")
        }

    }

}
