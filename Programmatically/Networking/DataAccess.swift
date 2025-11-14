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
class DataAccess {
    
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
    
    private func showHideLoading(isShow: Bool, isForce: Bool = false, message: String = "", delay: TimeInterval = 0.25) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            isShow ? Loading.shared.showLoading() : (isForce ? Loading.shared.hideLoading() : Loading.shared.delayBeforeHide(after: delay))
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
                    //no internet connection
                    if errorCode == -1009 {
                        //let outputErrorMessage = self.getErrorMessage(apiName: id, errorCode: "\(errorCode)", errorMessage: self.noInternetMessage)
                        let noInternetError = NSError(domain: "no_internet_connection", code: errorCode, userInfo: [NSLocalizedDescriptionKey: self.noInternetMessage])
                        completion(.failure(noInternetError))
                        return
                    } else {
                        //let outputErrorMessage = self.getErrorMessage(apiName: id, errorCode: "\(errorCode)", errorMessage: error!.localizedDescription)
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
                //let outputErrorMessage = self.getErrorMessage(apiName: id, errorCode: "오류", errorMessage: self.globalErrorMessage)
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
                //let outputErrorMessage = self.getErrorMessage(apiName: id, errorCode: "오류", errorMessage: self.decodeJsonErrorMessage)
                let error = NSError(domain: "ClientError", code: -1, userInfo: [NSLocalizedDescriptionKey: self.decodeJsonErrorMessage])
                self.showHideLoading(isShow: false, isForce: true)
               
                
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    /** Request data task with API and response data & error as completion */
    @MainActor func fetch<I: Encodable , O : Decodable>(api: String,
                             body: I,
                             responseType : O.Type,
                             shouldShowLoading: Bool = true,
                             messageLoading: String = "",
                             delayDuration: TimeInterval = 0.25,
                             completion: @escaping (Result<O,NSError>) -> Void) {
        
        let request = self.request(urlApi: api , body: body)
        
        if shouldShowLoading {
            showHideLoading(isShow: shouldShowLoading, message: messageLoading)
        }
        
        DataAccess.session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("🔵🔵🔵🔵 HTTP Response Code: \(httpResponse.statusCode) 🔵🔵🔵🔵")
                } else {
                    print("🔴🔴🔴🔴 HTTP Response Code: \(httpResponse.statusCode) 🔴🔴🔴🔴")
                }
            }
            
            if error != nil {
                self.showHideLoading(isShow: false, isForce: true)
                if let errorCode = (error as NSError?)?.code {
                    //no internet connection
                    if errorCode == -1009 {
                        //let outputErrorMessage = self.getErrorMessage(apiName: api, errorCode: "\(errorCode)", errorMessage: self.noInternetMessage)
                        let noInternetError = NSError(domain: "no_internet_connection", code: errorCode, userInfo: [NSLocalizedDescriptionKey: self.noInternetMessage])
                        completion(.failure(noInternetError))
                        return
                    } else {
                        //let outputErrorMessage = self.getErrorMessage(apiName: api, errorCode: "\(errorCode)", errorMessage: error!.localizedDescription)
                        let unknownError = NSError(domain: "오류", code: errorCode, userInfo: [NSLocalizedDescriptionKey: error!.localizedDescription])
                        completion(.failure(unknownError))
                        return
                    }
                }
                completion(.failure(error! as NSError))
                return
            }
            
            guard let data = data else {
                self.showHideLoading(isShow: false, isForce: true)
                //let outputErrorMessage = self.getErrorMessage(apiName: api, errorCode: "오류", errorMessage: self.globalErrorMessage)
                let time_out_error = NSError(domain: "정상적으로 로그아웃 되었습니다.", code: 1004, userInfo: [NSLocalizedDescriptionKey: self.globalErrorMessage])
                completion(.failure(time_out_error))
                
                return
            }
            
            guard let dataString = String(data: data, encoding: .utf8) else { return }
            #if DEBUG
            print("\n\nAPI name:", api)
            #endif

//            let responseDictionary = ShareMethod.shared.convertToDictionary(jsonString: dataString)
            var responseDictionary: [String: Any]?
            DispatchQueue.main.sync {
//                responseDictionary = ShareMethod.shared.convertToDictionary(jsonString: dataString)
            }
            
            if let COMMON_HEAD = responseDictionary?["COMMON_HEAD"] as? [String:Any] {
                let ERROR = COMMON_HEAD["ERROR"] as? Bool ?? false
                if ERROR == false {
                    // ********************************** success **********************************
                    #if DEBUG
                    print("Everything work fine. 😊😊😊")
                    #endif
                    
                    //let _replaceString = replaceString.replacingOccurrences(of: "\r\n", with: "")
                    guard let dataResult = dataString.data(using: .utf8) else { return }
                    do {
                        let responseObj = try JSONDecoder().decode(responseType, from: dataResult)
                        #if DEBUG
//                        if api != API.YGYO_000001, api != API.YGYO_000002 {
//                        }
                        Log.s("""
                        \(request.url!) | \(api)
                        \(dataResult.prettyPrinted)
                        """)
                        #endif
                        
                        if shouldShowLoading {
                            self.showHideLoading(isShow: false, delay: delayDuration)
                        }
                        // Return SUCCESS **************************************
                        completion(.success(responseObj))
                    } catch (let decodedError ) {
                        let debugError = decodedError as NSError
                        #if DEBUG
                        Log.e("""
                        Can't decode: \(api)
                        \(debugError.code) \(debugError.debugDescription)
                        \(dataResult.prettyPrinted)
                        """)
                        #endif
                        //let outputErrorMessage = self.getErrorMessage(apiName: api, errorCode: "오류", errorMessage: self.decodeJsonErrorMessage)
                        let error = NSError(domain: "ClientError", code: -1, userInfo: [NSLocalizedDescriptionKey: self.decodeJsonErrorMessage])
                        self.showHideLoading(isShow: false, isForce: true)
                        completion(.failure(error))
                    }
                } else {
                    #if DEBUG
                    print("Everything is bad. ❌❌❌")
                    print("response Error data:===\(COMMON_HEAD)")
                    #endif
                    // error
                    let CODE = COMMON_HEAD["CODE"] as? String ?? "1002"
                    var MESSAGE = COMMON_HEAD["MESSAGE"] as? String ?? ""
                    if CODE.contains("JEX") { MESSAGE = Network_Message.errorOccurredWhileProcessing }
                    //Update don't use 2022.03.11
                   // var outputErrorMessage = self.getErrorMessage(apiName: api, errorCode: CODE, errorMessage: MESSAGE)
                    
                    self.showHideLoading(isShow: false, isForce: true)
                    //autologin && error_code_else
                    #if DEBUG
                    print("Everything is bad. ❌❌❌")
                    Log.e("""
                    \(CODE) | \(MESSAGE)
                    """)
                    #endif
                    if CODE == "E_S001" {
                        //completion(.failure(NSError(domain: CODE, code: 1168, userInfo: [NSLocalizedDescriptionKey: MESSAGE])))
                        //New code 22.11.24
                        completion(.failure(NSError(domain: CODE, code: 2022, userInfo: [NSLocalizedDescriptionKey: MESSAGE])))
                    } else if CODE == "E_S002" {
                        completion(.failure(NSError(domain: CODE, code: 1168, userInfo: [NSLocalizedDescriptionKey: MESSAGE])))
                    } else if CODE == "C001" {
                        completion(.failure(NSError(domain: CODE, code: 1007, userInfo: [NSLocalizedDescriptionKey: MESSAGE])))
                    } else if CODE.contains("JEX") {
                        completion(.failure(NSError(domain: "오류", code: 1002, userInfo: [NSLocalizedDescriptionKey: MESSAGE])))
                    } else if CODE == "L001" {
                        completion(.failure(NSError(domain: CODE, code: 1008, userInfo: [NSLocalizedDescriptionKey: MESSAGE])))
                    } else if CODE == "L0051" {
                       completion(.failure(NSError(domain: CODE, code: 10051, userInfo: [NSLocalizedDescriptionKey: MESSAGE])))
                    } else if CODE == "L0052" {
                        completion(.failure(NSError(domain: CODE, code: 10052, userInfo: [NSLocalizedDescriptionKey: MESSAGE])))
                    } else if CODE == "E_B001" {
                        //outputErrorMessage = self.getErrorMessage(apiName: api, errorCode: CODE, errorMessage: "올바르지 않은 접근경로입니다.")
                        completion(.failure(NSError(domain: CODE, code: 52001, userInfo: [NSLocalizedDescriptionKey: "올바르지 않은 접근경로입니다."])))
                    } else if CODE == "L006" {
                        completion(.failure(NSError(domain: CODE, code: 1006, userInfo: [NSLocalizedDescriptionKey: MESSAGE])))
                    } else {
                        completion(.failure(NSError(domain: CODE, code: 1002 , userInfo: [NSLocalizedDescriptionKey: MESSAGE])))
                    }
                    return
                }
            }
            
            //브랜드 상품권
            else if api.contains("/api/bgc/") {
                if let code = responseDictionary?["CODE"] as? String {
                    if code == "0000" {
                        // ********************************** success **********************************
                        #if DEBUG
                        print("Everything work fine. 😊😊😊")
                        #endif
                        
                        guard let dataResult = dataString.data(using: .utf8) else { return }
                        do {
                            let responseObj = try JSONDecoder().decode(responseType, from: dataResult)
                            #if DEBUG
                            Log.s("""
                            \(request.url!) | \(api)
                            \(dataResult.prettyPrinted)
                            """)
                            #endif
                            if shouldShowLoading {
                                self.showHideLoading(isShow: false, delay: delayDuration)
                            }
                            // Return SUCCESS **************************************
                            completion(.success(responseObj))
                        } catch (let decodedError ) {
                            let debugError = decodedError as NSError
                            #if DEBUG
                            Log.e("""
                            Can't decode: \(api)
                            \(debugError.code) \(debugError.debugDescription)
                            \(dataResult.prettyPrinted)
                            """)
                            #endif
                            //Update don't use 2022.03.11
                            //let outputErrorMessage = self.getErrorMessage(apiName: api, errorCode: "오류", errorMessage: self.decodeJsonErrorMessage)
                            
                            let error = NSError(domain: "ClientError", code: -1, userInfo: [NSLocalizedDescriptionKey: self.decodeJsonErrorMessage])
                            self.showHideLoading(isShow: false, isForce: true)
                            completion(.failure(error))
                        }
                    } else {
                        //Update 2022.02.16
                        let errorMessage = responseDictionary?["MSG"] as? String ?? ""
                        let responseErr = NSError(domain: code, code: 1002, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(responseErr))
                    }
                }
            }
            
            else {
                #if DEBUG
                print("Everything is bad. 데이터가 없습니다. ❌❌❌")
                #endif
                //Update don't use 2022.03.11
                //let outputErrorMessage = self.getErrorMessage(apiName: api, errorCode: "오류", errorMessage: self.decodeJsonErrorMessage)
                self.showHideLoading(isShow: false, isForce: true)
                return
            }
        }.resume()
    }
    
}
