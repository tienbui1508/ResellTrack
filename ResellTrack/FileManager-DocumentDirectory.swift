//
//  FileManager-DocumentDirectory.swift
//  ResellTrack
//
//  Created by Tien Bui on 10/7/2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
