//
//  FileManager-URLPATH.swift
//  BucketList
//
//  Created by Arthur Sh on 25.12.2022.
//

import Foundation


extension FileManager {
    static var directoryPath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
