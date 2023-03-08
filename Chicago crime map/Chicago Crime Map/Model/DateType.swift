//
//  DateType.swift
//  Chicago crime map
//
//  Created by Ryoya Hashimoto on 2/23/23.
//

import Foundation

enum DateType: Int, Decodable {
    case week
    case weeks
    case month
    case all
    
    var displayString: String {
        switch self {
        case .week:
            return "1 week"
        case .weeks:
            return "2 weeks"
        case .month:
            return "Month"
        case .all:
            return "All"
        default:
            return "All"
        }
    }
    
    init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        switch label {
        case "1 week": self = .week
        case "2 weeks": self = .weeks
        case "Month": self = .month
        case "All": self = .all
        default: self = .all
        }
    }
}
