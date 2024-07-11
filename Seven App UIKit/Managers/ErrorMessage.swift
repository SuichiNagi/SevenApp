//
//  ErrorMessage.swift
//  Seven App UIKit
//
//  Created by Aldrei Glenn Nuqui on 7/11/24.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidRegister        = "This username or email is already exist. Please try again"
    case unableToComplete       = "Unable to complete your request. Please check you internet connection"
    case invalidResponse        = "Invalid response from the server. Please try again."
    case invalidData            = "The data received from the server is invalid. Please try again"
    case invalidCredentials     = "You enter wrong username or password."
}
