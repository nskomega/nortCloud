//
//  NetworkDateFormatter.swift
//  NordCloud
//
//  Created by Mikhail Danilov on 26.01.2022.
//

import Foundation

final class NetworkDateFormatter: DateFormatter {

    // MARK: - Constructor
    override init() {
        super.init()
        self.locale = Locale(identifier: "en_US_POSIX")
        self.timeZone = TimeZone(secondsFromGMT: 0)
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.locale = Locale(identifier: "en_US_POSIX")
        self.timeZone = TimeZone(secondsFromGMT: 0)
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
}
