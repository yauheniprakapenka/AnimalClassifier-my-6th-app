//
//  SearchResultModel.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 16.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import Foundation

struct SearchResultModel: Decodable {
    let total: Int
    let results: [Unsplashphoto]
}

struct Unsplashphoto: Decodable {
    let urls: [URLKind.RawValue: String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
