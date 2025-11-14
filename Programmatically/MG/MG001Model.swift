//
//  MG001Model.swift
//  Programmatically
//
//  Created by Nin Sreynuth on 14/11/25.
//

import CoreFoundation

struct CCommonHead: Decodable {
    var c_available_service :Bool = false
    var c_update_act        :String = ""
    var c_available_act     :String = ""
    var c_appstore_url      :String = ""
    var c_program_ver       :String = ""
    var c_minimum_ver       :String = ""
    var c_master_id         :String = ""
    var c_update_close      :Bool = false
    var c_update_date       :String = ""
    var c_register_yn       :Bool = false
    var c_remote_config_version : String?
    var c_remote_config_yn  : Bool?
}
struct MG001Model {
    
    //Request
    struct Request : Encodable {}
    
    //Response
    struct MGResponse: Decodable {
        let _tran_res_data: [TranResData]
    }
    
    struct TranResData: Decodable {
        var c_session_time      :Int = 0
        var c_network_timeout   :Int = 0
        var c_web_url           :CWebUrl
        var c_act_yn            :Bool = false
        var c_act_list          :[CActList] = []
        var c_crypto_key        :String = ""
        var c_locale            :String = ""
        var c_common_head       : CCommonHead
        var is_check_appiron    : Bool?
        var tele_corp_list      : [CareerList] = []
        var widget              : widget?
    }
    struct widget : Decodable {
        let c_available_service    : Bool?
        let c_available_act        : String?
    }
    
    struct CareerList: Decodable {
        let code    : String
        let name    : String
    }
    
    struct CWebUrl: Decodable {
        let c_site_url                  : String
        let INTRO_URL                   : String
        let ZERO_CMPL_URL               : String
        let PHONE_CERT_URL              : String
        let NOTI_URL                    : String
        let ZERO_APPROVE_URL            : String
        let ZERO_CORP_APPROVE_URL       : String
        let ZERO_GIFT_AUTH_URL          : String
        let ZERO_GIFT_BUY_URL           : String
        let CS_URL                      : String
        let NOTI_BOARD_URL              : String
        let SMALL_BIZ_GIFT_RECERT_URL   : String
        let QR_CHECK_IN_URL             : String
        let SLEEP_USER_VERIFY_URL       : String
        let UNTACT_PAY_URL              : String
        let UNTACT_PAY_TERMS_YN_URL     : String
        let UNTACT_PAY_MINOR_PAGE_URL   : String
        let UNTACT_PAY_PAYMENT_URL      : String
        let BRD_SEARCH                  : String
        let BRD_LIST                    : String
        let BRD_GIFT_LIST               : String
        let BRD_HISTORY                 : String
        let COIN_APPROVE_URL            : String
        
        enum CodingKeys: String, CodingKey {
            case c_site_url                 = "c_site_url"
            case INTRO_URL                  = "INTRO_URL"
            case ZERO_CMPL_URL              = "ZERO_CMPL_URL"
            case PHONE_CERT_URL             = "PHONE_CERT_URL"
            case NOTI_URL                   = "NOTI_URL"
            case ZERO_APPROVE_URL           = "ZERO_APPROVE_URL"
            case ZERO_CORP_APPROVE_URL      = "ZERO_CORP_APPROVE_URL"
            case ZERO_GIFT_AUTH_URL         = "ZERO_GIFT_AUTH_URL"
            case ZERO_GIFT_BUY_URL          = "ZERO_GIFT_BUY_URL"
            case CS_URL                     = "CS_URL"
            case NOTI_BOARD_URL             = "NOTI_BOARD_URL"
            case SMALL_BIZ_GIFT_RECERT_URL  = "SMALL_BIZ_GIFT_RECERT_URL"
            case QR_CHECK_IN_URL            = "QR_CHECK_IN_URL"
            case SLEEP_USER_VERIFY_URL      = "SLEEP_USER_VERIFY_URL"
            case UNTACT_PAY_URL             = "UNTACT_PAY_URL"
            case UNTACT_PAY_TERMS_YN_URL    = "UNTACT_PAY_TERMS_YN_URL"
            case UNTACT_PAY_MINOR_PAGE_URL  = "UNTACT_PAY_MINOR_PAGE_URL"
            case UNTACT_PAY_PAYMENT_URL     = "UNTACT_PAY_PAYMENT_URL"
            case BRD_SEARCH                 = "BRD_SEARCH"
            case BRD_LIST                   = "BRD_LIST"
            case BRD_GIFT_LIST              = "BRD_GIFT_LIST"
            case BRD_HISTORY                = "BRD_HISTORY"
            case COIN_APPROVE_URL           = "COIN_APPROVE_URL"
        }

        init(from decoder: Decoder) throws {
            let container                   = try decoder.container(keyedBy: CodingKeys.self)
            c_site_url                      = try container.decodeIfPresent(String.self, forKey: .c_site_url) ?? ""
            INTRO_URL                       = try container.decodeIfPresent(String.self, forKey: .INTRO_URL) ?? ""
            ZERO_CMPL_URL                   = try container.decodeIfPresent(String.self, forKey: .ZERO_CMPL_URL) ?? ""
            PHONE_CERT_URL                  = try container.decodeIfPresent(String.self, forKey: .PHONE_CERT_URL) ?? ""
            NOTI_URL                        = try container.decodeIfPresent(String.self, forKey: .NOTI_URL) ?? ""
            ZERO_APPROVE_URL                = try container.decodeIfPresent(String.self, forKey: .ZERO_APPROVE_URL) ?? ""
            ZERO_CORP_APPROVE_URL           = try container.decodeIfPresent(String.self, forKey: .ZERO_CORP_APPROVE_URL) ?? ""
            ZERO_GIFT_AUTH_URL              = try container.decodeIfPresent(String.self, forKey: .ZERO_GIFT_AUTH_URL) ?? ""
            ZERO_GIFT_BUY_URL               = try container.decodeIfPresent(String.self, forKey: .ZERO_GIFT_BUY_URL) ?? ""
            CS_URL                          = try container.decodeIfPresent(String.self, forKey: .CS_URL) ?? ""
            NOTI_BOARD_URL                  = try container.decodeIfPresent(String.self, forKey: .NOTI_BOARD_URL) ?? ""
            SMALL_BIZ_GIFT_RECERT_URL       = try container.decodeIfPresent(String.self, forKey: .SMALL_BIZ_GIFT_RECERT_URL) ?? ""
            QR_CHECK_IN_URL                 = try container.decodeIfPresent(String.self, forKey: .QR_CHECK_IN_URL) ?? ""
            SLEEP_USER_VERIFY_URL           = try container.decodeIfPresent(String.self, forKey: .SLEEP_USER_VERIFY_URL) ?? ""
            UNTACT_PAY_URL                  = try container.decodeIfPresent(String.self, forKey: .UNTACT_PAY_URL) ?? ""
            UNTACT_PAY_TERMS_YN_URL         = try container.decodeIfPresent(String.self, forKey: .UNTACT_PAY_TERMS_YN_URL) ?? ""
            UNTACT_PAY_MINOR_PAGE_URL       = try container.decodeIfPresent(String.self, forKey: .UNTACT_PAY_MINOR_PAGE_URL) ?? ""
            UNTACT_PAY_PAYMENT_URL          = try container.decodeIfPresent(String.self, forKey: .UNTACT_PAY_PAYMENT_URL) ?? ""
            BRD_SEARCH                      = try container.decodeIfPresent(String.self, forKey: .BRD_SEARCH) ?? ""
            BRD_LIST                        = try container.decodeIfPresent(String.self, forKey: .BRD_LIST) ?? ""
            BRD_GIFT_LIST                   = try container.decodeIfPresent(String.self, forKey: .BRD_GIFT_LIST) ?? ""
            BRD_HISTORY                     = try container.decodeIfPresent(String.self, forKey: .BRD_HISTORY) ?? ""
            COIN_APPROVE_URL                = try container.decodeIfPresent(String.self, forKey: .COIN_APPROVE_URL) ?? ""
        }
    }
    
    struct CActList: Decodable {
        var c_act_id        : String = ""
        var c_act           : String = ""
        var c_act_url       : String = ""
        var c_act_close     : Bool = false
        var c_act_pos_cd    : String = ""
        
        var c_act_dspl_height_px    : CGFloat? = 0
        var c_act_dspl_width_px     : CGFloat? = 0
        var c_act_start_date        : String? = ""
        var c_act_end_date          : String? = ""
    }
}
