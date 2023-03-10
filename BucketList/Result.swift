//
//  Result.swift
//  BucketList
//
//  Created by Arthur Sh on 24.12.2022.
//

import Foundation


struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No further infrmation"
    }
    
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    
    static let example = Page(pageid: 1, title: "test", terms: ["test": ["test"]])
}
