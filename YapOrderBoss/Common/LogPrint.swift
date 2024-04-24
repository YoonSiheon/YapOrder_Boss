//
//  LogPrint.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/09.
//

import Foundation

private func getCurrentDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss.SSSSSS"
    return (formatter.string(from: Date()) as NSString) as String
}

func LogPrint(_ object: String) {
    print(object)
}
