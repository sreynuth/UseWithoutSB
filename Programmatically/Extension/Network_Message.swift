//
//  NetWork_Message.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 13/11/25.
//

import Foundation

class Network_Message {
    private init(){}
    
    static var internetConnectUnstable: String { return "인터넷 연결이 불안정합니다. 잠시 후 이용하시기 바랍니다."}
    
    static var connectionTimeoutTryAgainLater: String {return "통신중 시간 만료되었습니다. 잠시 후 다시 확인하여 주시기 바랍니다."}
    
    static var errorOccurredWhileCommunicaiton: String { return "통신 중 오류가 발생하였습니다."}

    static var errorOccurredWhileProcessing: String {return "처리중 오류가 발생하였습니다."}
}
