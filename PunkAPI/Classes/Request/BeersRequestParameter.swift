//
//  BeersRequestParameter.swift
//  PunkAPI
//
//  Created by Andrea Altea on 02/03/2019.
//

import Foundation

extension BeersRequest {
    
   public enum Parameter {
        
        case abv(condition: Condition, value: Float)
        case ibu(condition: Condition, value: Float)
        case ebc(condition: Condition, value: Float)
        
        case beerName(value: String)
        case yeast(value: String)
        
        case brewed(condition: Condition, value: Date)
    
    case hops(value: String)
        case malt(value: String)
        case food(value: String)
    
    case ids(value: [Int])
    
        internal var parameter: RequestParameter {
            switch self {
            case let .abv(condition, value):
                return FloatParameter(key: "abv", condition: condition, value: value)
            case let .ibu(condition, value):
                return FloatParameter(key: "ibu", condition: condition, value: value)
            case let .ebc(condition, value):
                return FloatParameter(key: "ebc", condition: condition, value: value)
                
            case let .beerName(value):
                return StringParameter(key: "beer_name", value: value)
            case let .yeast(value):
                return StringParameter(key: "yeast", value: value)
                
            case let .brewed(condition, value):
                return DateParameter(type: "brewed", condition: condition, dateValue: value)
                
            case let .hops(value):
                return StringParameter(key: "hops", value: value)
            case let .malt(value):
                return StringParameter(key: "malt", value: value)
            case let .food(value):
                return StringParameter(key: "food", value: value)
                
            case let .ids(value):
                let ids = value.map { "\($0)" }.reduce("", { $0.isEmpty ? $1 : $0 + "|" + $1 })
                return StringParameter(key: "ids", value: ids)
            }
        }
    }
}

enum Condition {
    case greater
    case lower
    
    var literal: String {
        switch self {
        case .greater: return "gt"
        case .lower: return "lt"
        }
    }
}

struct FloatParameter: RequestParameter {
    
    var type: String
    var condition: Condition
    var value: Any
    init(key: String, condition: Condition, value: Float) {
        self.type = key
        self.condition = condition
        self.value = value
    }
    var key: String {
        return "\(type)_\(condition.literal)"
    }
    
}

struct StringParameter: RequestParameter {
    
    var key: String
    var value: Any
    
    init(key: String, value: String) {
        self.key = key
        self.value = value.replacingOccurrences(of: " ", with: "_")
    }
}

struct DateParameter: RequestParameter {

    var type: String
    var condition: Condition
    var dateValue: Date
    
    var key: String {
        return "\(type)_\(condition.literal)"
    }
    
    var value: Any {
        return dateValue.parameterFormat
    }
}

extension Date {
    
    static let parameterFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm-yyyy"
        return formatter
    }()
    
    var parameterFormat: String {
        return Date.parameterFormatter.string(from: self)
    }
}
