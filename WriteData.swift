//
//  WriteData.swift
//  BucketList
//
//  Created by Arthur Sh on 22.12.2022.
//

import Foundation

extension FileManager {
    func getUserDirectory() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        return url [0]
    }
    
     func writeData (string: String, url: URL) throws {
            try string.write(to: url, atomically: true, encoding: .utf8)
      
    }
    
    func readHaHa(url: URL?) -> String {
        do {
            let input = try String(contentsOf: url!)
            return input
        } catch {
            return "No data"
        }
    }
}
