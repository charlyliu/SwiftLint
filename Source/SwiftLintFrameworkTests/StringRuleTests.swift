//
//  StringRuleTests.swift
//  SwiftLint
//
//  Created by JP Simard on 5/28/15.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import SwiftLintFramework
import XCTest

class StringRuleTests: XCTestCase {
    func testLineLengths() {
        let longLine = join("", Array(count: 100, repeatedValue: "/")) + "\n"
        XCTAssertEqual(violations(longLine), [])
        let testCases: [(String, Int, ViolationSeverity)] = [
            (join("", Array(count: 121, repeatedValue: "/")), 221, .Low),
            (join("", Array(count: 151, repeatedValue: "/")), 251, .Medium),
            (join("", Array(count: 201, repeatedValue: "/")), 301, .High),
            (join("", Array(count: 251, repeatedValue: "/")), 351, .VeryHigh)
        ]
        for testCase in testCases {
            XCTAssertEqual(violations(testCase.0 + longLine), [StyleViolation(type: .Length,
                location: Location(file: nil, line: 1),
                severity: testCase.2,
                reason: "Line should be 200 characters or less: " +
                "currently \(testCase.1) characters")])
        }
    }

    func testTrailingNewlineAtEndOfFile() {
        XCTAssertEqual(violations("//\n"), [])
        XCTAssertEqual(violations(""), [StyleViolation(type: .TrailingNewline,
            location: Location(file: nil, line: 1),
            severity: .Medium,
            reason: "File should have a single trailing newline: currently has 0")])
        XCTAssertEqual(violations("//\n\n"), [StyleViolation(type: .TrailingNewline,
            location: Location(file: nil, line: 3),
            severity: .Medium,
            reason: "File should have a single trailing newline: currently has 2")])
    }

    func testFileLengths() {
        XCTAssertEqual(violations(join("", Array(count: 400, repeatedValue: "//\n"))), [])
        let testCases: [(String, Int, ViolationSeverity)] = [
            (join("", Array(count: 401, repeatedValue: "//\n")), 401, .VeryLow),
            (join("", Array(count: 501, repeatedValue: "//\n")), 501, .Low),
            (join("", Array(count: 751, repeatedValue: "//\n")), 751, .Medium),
            (join("", Array(count: 1001, repeatedValue: "//\n")), 1001, .High),
            (join("", Array(count: 2001, repeatedValue: "//\n")), 2001, .VeryHigh)
        ]
        for testCase in testCases {
            XCTAssertEqual(violations(testCase.0), [StyleViolation(type: .Length,
                location: Location(file: nil, line: testCase.1),
                severity: testCase.2,
                reason: "File should contain 400 lines or less: currently contains \(testCase.1)")])
        }
    }


    func testTodoOrFIXME() {
        verifyRule(TodoRule().example, type: .TODO)
    }

    func testColon() {
//        verifyRule(ColonRule().example, type: .Colon)
    }
}
