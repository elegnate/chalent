//
//  FileIO.swift
//  trada
//
//  Created by jwan on 2018. 9. 4..
//  Copyright © 2018년 jwan. All rights reserved.
//

import Foundation


class FileIO {
    
    
    private let fileManager = FileManager.default
    private var path: URL?
    private var dateFormatter: DateFormatter = DateFormatter()
    private let recodeDateFormat: String = "yyyy.MM.dd_HH:mm"
    
    
    init(_ name: String, directory: String? = nil) {
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard var document = urls.first else {
            print("openDocument Fail")
            return
        }
        
        if let directory = directory {
            document = openDirectory(directory, topPath: document)
        }
        
        path = document.appendingPathComponent(name)
        dateFormatter.dateFormat = recodeDateFormat
    }
    
    
    private func openFile(_ name: String, topPath: URL) -> URL {
        let filePath = topPath.appendingPathComponent(name)
        
        if !isExist(filePath.path) {
            if !fileManager.createFile(atPath: filePath.path, contents: nil, attributes: nil) {
                print("createFile Fail")
                return topPath
            }
        }
        
        return filePath
    }
    
    
    private func openDirectory(_ name: String, topPath: URL) -> URL {
        let directoryPath = topPath.appendingPathComponent(name, isDirectory: true)
        
        if !isExist(directoryPath.path, isDirectory: true) {
            do {
                try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes:nil)
            } catch {
                print("createDirectory Fail")
                return topPath
            }
        }
        
        return directoryPath
    }
    
    
    private func isExist(_ path: String, isDirectory: Bool = false) -> Bool {
        var ret = false
        
        if isDirectory {
            var objcBool = ObjCBool(true)
            let exists = fileManager.fileExists(atPath: path, isDirectory: &objcBool)
            ret = exists && objcBool.boolValue
        } else {
            ret = fileManager.fileExists(atPath: path)
        }
        
        return ret
    }
    
    
    func clear() {
        guard let path = path else { return }
        do {
            try "".write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("clear Fail")
        }
    }
    
    
    func write(_ text: String) -> String? {
        if let timestamp = write(text, timestamp: dateFormatter.string(from: Date())) {
            return timestamp
        }
        return nil
    }
    
    
    func write(_ text: String, timestamp: String) -> String? {
        guard let path = path else { return nil }
        do {
            let input = timestamp + " " + (text + "\n" + read())
            try input.write(to: path, atomically: true, encoding: .utf8)
            return timestamp
        } catch {
            print("writeText Fail")
        }
        return nil
    }
    
    
    func getTimestamp(to: String) -> Date? {
        return dateFormatter.date(from: to)
    }
    
    
    func read() -> String {
        guard let path = path else { return "" }
        do {
            return try String(contentsOf: path, encoding: .utf8)
        } catch {
            print("readText Fail")
        }
        return ""
    }
    
    
    func readLines() -> [String] {
        guard let path = path else { return [] }
        do {
            let data = try String(contentsOf: path, encoding: .utf8)
            return data.components(separatedBy: .newlines)
        } catch {
            print("readText Fail")
        }
        return []
    }
}
