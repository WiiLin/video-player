//
//  Number+Extensions.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import Foundation

extension Float {
    var double: Double {
        return Double(self)
    }
}

extension Double {
    var int: Int {
        return Int(self)
    }

    var float: Float {
        return Float(self)
    }
}

extension Int {
    func secondsToHoursMinutesSeconds() -> (Int, Int, Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }

    var displayTime: String {
        let tuple = secondsToHoursMinutesSeconds()
        var array: [String] = []
        if tuple.0 > 0 {
            array.append(String(format: "%02d", tuple.0))
        }
        array.append(String(format: "%02d", tuple.1))
        array.append(String(format: "%02d", tuple.2))
        return array.joined(separator: ":")
    }
}
