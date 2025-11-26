//
//  DataAccess.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/11/25.
//

import Foundation
import UIKit

enum RequestMethod: String {
    case get  = "GET"
    case post = "POST"
}
final class DataAccess {
    
    @MainActor private static var sharedInstance   = DataAccess()
    @MainActor private static var session          = URLSession(configuration: .default)
    @MainActor private static var sessionConfig    : URLSessionConfiguration!
    
    private let noInternetMessage                  = Network_Message.internetConnectUnstable
    private let globalErrorMessage                 = Network_Message.connectionTimeoutTryAgainLater
    private let decodeJsonErrorMessage             = Network_Message.errorOccurredWhileCommunicaiton
    
    /** Return the singleton DataAccess instance */
    @MainActor static var shared: DataAccess = {

        // set user agent
        setUserAgent()
        
        sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache?.removeAllCachedResponses() // clear URL cache
        // Timeout Configuration
        if ShareConstant.shared.mg001Data != nil {
            let timeInterval = TimeInterval(ShareConstant.shared.mg001Data.c_network_timeout/1000)
            sessionConfig.timeoutIntervalForRequest = timeInterval
            sessionConfig.timeoutIntervalForResource = timeInterval
        }
        session = URLSession(configuration: sessionConfig)
        return sharedInstance
    }()
    
    @MainActor private static func setUserAgent() {
        let userAgent = ShareConstant.shared.userAgent
        let userAgentData = ["UserAgent" : userAgent]
        UserDefaults.standard.register(defaults: userAgentData)
    }
    
    private func queryString<T:Encodable>(body:T) -> String {
        let request = body
        guard let str = request.asJSONString() else {
            return ""
        }
        return str
    }
    
    @MainActor private func request<T: Encodable>(urlApi: String, body: T) -> URLRequest {
        var url: URL!
        var request: URLRequest!

        var baseServerURL = API.serverURL
    
        if urlApi == API.MG001 {
            url = URL(string: API.MG001URL)
            request = URLRequest(url: url)
            request.httpMethod = "GET"
        }else{
            //if api contain http or https ==> remove baseUrl
            if urlApi.contains("http://") || urlApi.contains("https://") {
                baseServerURL = ""
            }
            
            let reqURL = baseServerURL + urlApi
            url = URL(string: reqURL)
            request = URLRequest(url: url)
            request.httpMethod = "POST"
        }
        request.setValue(ShareConstant.shared.userAgent, forHTTPHeaderField: "User-Agent")

        #if DEBUG
        let strQuery = queryString(body: body)
        let encodeDataString = strQuery.removingPercentEncoding
        let replaceString = encodeDataString?.replacingOccurrences(of: "+", with: " ") ?? ""
        let dataResult = replaceString.data(using: .utf8)
        Log.r("""
        \(request.url!) | \(urlApi)
        \(dataResult?.prettyPrinted ?? "")
        """)
        #endif
        return request
    }

    @MainActor
    private func makeRequest<I: Encodable>(api: String, body: I) -> URLRequest {
        return request(urlApi: api, body: body)
    }
    
    
    private func handleCommonHeadAPI<O: Decodable>(
        api: String,
        common: [String: Any],
        dataString: String,
        shouldShowLoading: Bool,
        delay: TimeInterval,
        responseType: O.Type,
        completion: @escaping (Result<O, NSError>) -> Void
    ) {
        let isError = common["ERROR"] as? Bool ?? false

        if !isError {
            decodeObject(
                api: api,
                jsonString: dataString,
                responseType: responseType,
                shouldShowLoading: shouldShowLoading,
                delay: delay,
                completion: completion
            )
            return
        }

        let code = common["CODE"] as? String ?? "1002"
        let message = common["MESSAGE"] as? String ?? ""

        let mapped = mapErrorCode(code: code, message: message)
        completion(.failure(mapped))
    }

    private func handleBrandVoucherAPI<O: Decodable>(
        api: String,
        json: [String: Any],
        dataString: String,
        shouldShowLoading: Bool,
        delay: TimeInterval,
        responseType: O.Type,
        completion: @escaping (Result<O, NSError>) -> Void
    ) {
        if json["CODE"] as? String == "0000" {
            decodeObject(
                api: api,
                jsonString: dataString,
                responseType: responseType,
                shouldShowLoading: shouldShowLoading,
                delay: delay,
                completion: completion
            )
        } else {
            let msg = json["MSG"] as? String ?? ""
            completion(.failure(makeError(domain: "voucher", code: 1002, message: msg)))
        }
    }

    private func decodeObject<O: Decodable>(
        api: String,
        jsonString: String,
        responseType: O.Type,
        shouldShowLoading: Bool,
        delay: TimeInterval,
        completion: @escaping (Result<O, NSError>) -> Void
    ) {
        guard let data = jsonString.data(using: .utf8) else {
            completion(.failure(makeError(domain: "json", code: -1, message: decodeJsonErrorMessage)))
            return
        }

        do {
            let obj = try JSONDecoder().decode(responseType, from: data)
            if shouldShowLoading {
                showHideLoading(isShow: false, delay: delay)
            }
            completion(.success(obj))

        } catch {
            completion(.failure(makeError(domain: "decode", code: -1, message: decodeJsonErrorMessage)))
        }
    }

    private func mapErrorCode(code: String, message: String) -> NSError {

        switch code {
        case "0000":
            return makeError(domain: "success", code: 0, message: message)

        case "1001": // Invalid token / login expired
            return makeError(domain: "auth", code: 1001, message: message)

        case "1002": // General API error
            return makeError(domain: "api", code: 1002, message: message)

        case "1003": // System overload
            return makeError(domain: "system", code: 1003, message: message)

        case "1004": // Timeout
            return makeError(domain: "timeout", code: 1004, message: message)

        default:
            // Unknown error code → fall back to your global error message
            return makeError(domain: "unknown", code: Int(code) ?? -1, message: message)
        }
    }


    @MainActor func fetchGateWay<I: Encodable, O: Decodable>(id: String, body: I, responseType: O.Type, shouldShowLoading: Bool = true, completion: @escaping (Result<O,NSError>) -> Void)  {
        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
        
        let request = self.request(urlApi: id, body: body)
        if shouldShowLoading {
            self.showHideLoading(isShow: shouldShowLoading)
        }
        
        // Timeout Configuration
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache?.removeAllCachedResponses()
        let webcashSession = URLSession(configuration: sessionConfig)
        
        webcashSession.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if (200...299).contains(httpResponse.statusCode) {
                    #if DEBUG
                    print("🔵🔵🔵🔵 HTTP Response Code: \(httpResponse.statusCode) 🔵🔵🔵🔵")
                    #endif
                } else {
                    #if DEBUG
                    print("🔴🔴🔴🔴 HTTP Response Code: \(httpResponse.statusCode) 🔴🔴🔴🔴")
                    #endif
                    
                }
            }
             
            // avoid ERRROR ❌❌❌------------------------------------------
            if error != nil {
                self.showHideLoading(isShow: false, isForce: true)
                if let errorCode = (error as NSError?)?.code {
                    // no internet connection
                    if errorCode == -1009 {
                        // let outputErrorMessage = self.getErrorMessage(apiName: id, errorCode: "\(errorCode)", errorMessage: self.noInternetMessage)
                        let noInternetError = NSError(domain: "no_internet_connection", code: errorCode, userInfo: [NSLocalizedDescriptionKey: self.noInternetMessage])
                        completion(.failure(noInternetError))
                        return
                    } else {
                        // let outputErrorMessage = self.getErrorMessage(apiName: id, errorCode: "\(errorCode)", errorMessage: error!.localizedDescription)
                        let unknownError = NSError(domain: "Unknow_Error", code: errorCode, userInfo: [NSLocalizedDescriptionKey: error!.localizedDescription])
                        completion(.failure(unknownError))
                        return
                    }
                }
                completion(.failure(error! as NSError))
                return
            }
            
            // avoid ERROR ❌❌❌------------------------------------------
            guard let data = data else {
                self.showHideLoading(isShow: false, isForce: true)
                // let outputErrorMessage = self.getErrorMessage(apiName: id, errorCode: "오류", errorMessage: self.globalErrorMessage)
                let time_out_error = NSError(domain: "정상적으로 로그아웃 되었습니다.", code: 1004, userInfo: [NSLocalizedDescriptionKey: self.globalErrorMessage])
                completion(.failure(time_out_error))
                return
            }
            
            guard let dataString = String(data: data, encoding: String.Encoding.utf8) else { return }
            guard let decodedDataString = dataString.removingPercentEncoding else { return }
            let replaceString = decodedDataString.replacingOccurrences(of: "+", with: " ")
            
//            #if DEBUG
//            print(id + " Data : \n", replaceString)
//            #endif

            guard let dataResult = replaceString.data(using: .utf8) else { return }
            
            do {
                let responseObj = try JSONDecoder().decode(responseType, from: dataResult)
                #if DEBUG
                Log.s("""
                \(request.url!) | \(id)
                \(dataResult.prettyPrinted)
                """)
                print("Everything work fine. 😊😊😊")
                #endif
                if shouldShowLoading {
                    self.showHideLoading(isShow: false)
                }
                DispatchQueue.main.async {
                    completion(.success(responseObj))
                }
                
            } catch {
                #if DEBUG
                print("Everything is bad. ❌❌❌")
                print("Error pasing: \n", error.localizedDescription)
                Log.e("""
                Can't decode responseObject: \(id)
                \(dataResult.prettyPrinted)
                """)
                #endif
                // let outputErrorMessage = self.getErrorMessage(apiName: id, errorCode: "오류", errorMessage: self.decodeJsonErrorMessage)
                let error = NSError(domain: "ClientError", code: -1, userInfo: [NSLocalizedDescriptionKey: self.decodeJsonErrorMessage])
                self.showHideLoading(isShow: false, isForce: true)
               
                completion(
                    .failure(error)
                )
            }
        }.resume()
    }
}

extension DataAccess : Sendable {
    /** Request data task with API and response data & error as completion */@MainActor
    func requestDataTask<I: Encodable, O: Decodable>(
        api: String,
        body: I,
        responseType: O.Type,
        shouldShowLoading: Bool = true,
        messageLoading: String = "",
        delayDuration: TimeInterval = 0.25,
        completion: @escaping (Result<O, NSError>) -> Void
    ) {
        let request = makeRequest(api: api, body: body)

        if shouldShowLoading {
            showHideLoading(isShow: true, message: messageLoading)
        }

        DataAccess.session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                let handled = self.handleNetworkError(api: api, error: error)
                self.showHideLoading(isShow: false, isForce: true)
                completion(.failure(handled))
                return
            }

            guard let data = data else {
                let timeoutErr = self.makeError(
                    domain: "logout",
                    code: 1004,
                    message: self.globalErrorMessage
                )
                self.showHideLoading(isShow: false, isForce: true)
                completion(.failure(timeoutErr))
                return
            }

            self.handleResponse(
                api: api,
                dataString: String(decoding: data, as: UTF8.self),
                shouldShowLoading: shouldShowLoading,
                delay: delayDuration,
                responseType: responseType,
                completion: completion
            )

        }.resume()
    }
}

// DataAccess+Network.swift
extension DataAccess {
    private func makeError(domain: String, code: Int, message: String) -> NSError {
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    private func handleNetworkError(api: String, error: Error) -> NSError {
        let nsError = error as NSError
        let code = nsError.code

        if code == -1009 {
            return makeError(domain: "internet", code: code, message: noInternetMessage)
        }

        return makeError(domain: "unknown", code: code, message: nsError.localizedDescription)
    }
    
    private func handleResponse<O: Decodable>(
        api: String,
        dataString: String,
        shouldShowLoading: Bool,
        delay: TimeInterval,
        responseType: O.Type,
        completion: @escaping (Result<O, NSError>) -> Void
    ) {

        guard let json = ShareMethod.shared.convertToDictionary(jsonString: dataString) else {
            completion(.failure(makeError(domain: "json", code: 0, message: decodeJsonErrorMessage)))
            return
        }

        // 1. COMMON_HEAD style API
        if let common = json["COMMON_HEAD"] as? [String:Any] {
            handleCommonHeadAPI(
                api: api,
                common: common,
                dataString: dataString,
                shouldShowLoading: shouldShowLoading,
                delay: delay,
                responseType: responseType,
                completion: completion
            )
            return
        }

        // 2. special /api/bgc APIs
        if api.contains("/api/bgc/") {
            handleBrandVoucherAPI(
                api: api,
                json: json,
                dataString: dataString,
                shouldShowLoading: shouldShowLoading,
                delay: delay,
                responseType: responseType,
                completion: completion
            )
            return
        }

        // default
        completion(.failure(makeError(domain: "data", code: 0, message: decodeJsonErrorMessage)))
    }
}

// DataAccess+Helpers.swift
extension DataAccess {
    func showHideLoading(isShow: Bool, isForce: Bool = false, message: String = "", delay: TimeInterval = 0.25) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            isShow ? Loading.shared.showLoading() : (isForce ? Loading.shared.hideLoading() : Loading.shared.delayBeforeHide(after: delay))
        }
    }
}
