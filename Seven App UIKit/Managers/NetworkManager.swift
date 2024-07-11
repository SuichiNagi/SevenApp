//
//  NetworkManager.swift
//  Seven App UIKit
//
//  Created by Aldrei Glenn Nuqui on 7/11/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared =  NetworkManager()
    
    private let baseURL = "https://mobiletest.1902dev1.com/"
    private let secret  = "70a0389a-d701-4d78-a325-e7f5da2ae9b0"
    private let contentType = "application/json"
    
    private var authResponse: AuthResponse?
    
    func setAuthResponse(_ token: AuthResponse) {
        self.authResponse = token
    }
    
    func loginUser(username: String, password: String, completion: @escaping (Result<AuthResponse, ErrorMessage>) -> Void) {
        let loginUrl = "\(baseURL)/api/user/login"
        
        let payload: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        let headers: HTTPHeaders = [
            "Secret": secret,
            "Content-Type": contentType
        ]
        
        AF.request(loginUrl, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: AuthResponse.self) { response in
                switch response.result {
                case .success(let authResponse):
                    completion(.success(authResponse))
                case .failure:
                    if let error = response.error, error.isResponseValidationError {
                        completion(.failure(.invalidCredentials))
                    } else if response.error != nil {
                        completion(.failure(.unableToComplete))
                    } else {
                        completion(.failure(.invalidData))
                    }
                }
            }
    }
    
    func logoutUser(token: String, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let logoutUrl = "\(baseURL)/api/user/logout"
        
        let headers: HTTPHeaders = [
            "Secret": secret,
            "TOKEN": token,
            "Content-Type": contentType
        ]
        
        AF.request(logoutUrl, method: .post, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(true))
                case .failure:
                    if let error = response.error, error.isResponseValidationError {
                        completion(.failure(.invalidData))
                    } else if response.error != nil {
                        completion(.failure(.unableToComplete))
                    } else {
                        completion(.failure(.invalidData))
                    }
                }
            }
    }
    
    func registerUser(username: String, password: String, email: String, name: String, completion: @escaping (Result<AuthResponse, ErrorMessage>) -> Void) {
        let registerUrl = "\(baseURL)/api/user/register"
        
        let payload: [String: Any] = [
            "username": username,
            "password": password,
            "email": email,
            "name": name
        ]
        
        let headers: HTTPHeaders = [
            "Secret": secret,
            "Content-Type": contentType
        ]
        
        AF.request(registerUrl, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: AuthResponse.self) { response in
                switch response.result {
                case .success(let authResponse):
                    completion(.success(authResponse))
                case .failure:
                    if let error = response.error, error.isResponseValidationError {
                        completion(.failure(.invalidRegister))
                    } else if response.error != nil {
                        completion(.failure(.unableToComplete))
                    } else {
                        completion(.failure(.invalidData))
                    }
                }
            }
    }
}
