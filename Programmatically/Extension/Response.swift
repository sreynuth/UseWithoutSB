//
//  Response.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 14/11/25.
//


struct Response<T: Decodable> : Decodable {
    let RSLT_CD : String?
    let RSLT_MSG : String?
    let RESP_DATA : T?
}

struct CommonHeader : Decodable {
    var ERROR : Bool = false// 에러여부 - false:정상, true:에러
    var MESSAGE : String = ""// 에러메세지
    var CODE : String = ""// 에러코드
}
