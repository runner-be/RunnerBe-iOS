//
//  Log.swift
//  Runner-be
//
//  Created by 김신우 on 2022/05/21.
//

import UIKit

enum Log {
    enum Tag {
        case lifeCycle
        case network
        case warning
        case info
        case error
        case custom(String)

        var mark: String {
            switch self {
            case .lifeCycle:
                return "❤️"
            case .network:
                return "📡"
            case .warning:
                return "⚠️"
            case .error:
                return "❌"
            case .info:
                return "🔎"
            case let .custom(string):
                return string
            }
        }
    }

    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    static func e(_ contents: String, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        Log.log(tag: .error, contents, fileName: fileName, line: line, functionName: functionName)
    }

    static func d(tag: Tag = .custom(""), _ contents: String, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        #if DEBUG
            Log.log(tag: tag, contents, fileName: fileName, line: line, functionName: functionName)
        #endif
    }

    private static func log(tag: Tag = .custom(""), _ contents: String, fileName: String = #file, line: Int = #line, functionName: String = #function) {
        let date = Date()
        let dateString = Self.dateFormatter.string(from: date)

        var file = URL(fileURLWithPath: fileName)
        file.deletePathExtension()

        let message = "🐝 [\(dateString)] \(tag.mark) \(file.lastPathComponent) #\(line) \(functionName): \(contents)"

        print(message)
    }
}
