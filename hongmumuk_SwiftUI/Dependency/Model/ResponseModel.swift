//
//  ResponseModel.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import Foundation

struct ResponseModel<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let data: T?
}
