//
//  DiscordReports.swift
//  KaobeiAPI
//
//  Created by horo on 2021/04/15.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

public class DiscordReports {
    public static func report(content: String) {
        let api = DiscordMeta()
        api.parameters["content"] = content
        api.parameters["muteHttpExceptions"] = true
        
        AF.request(api.url, method: api.method, parameters: api.parameters, headers: api.headers) {_ in
            
        }
        
    }
    
    static func getInfoPlistByKey(_ key: String) -> String {
        var url = "https://"
        url.append(((Bundle.main.infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "")) ?? "")
        
        return url
    }
}

class DiscordMeta {
    var url: String { DiscordReports.getInfoPlistByKey("Discord URL") }
    var method: HTTPMethod { .post }
    var headers: HTTPHeaders {
        var head = HTTPHeaders()
        head.add(name: "Content-Type", value: "application/x-www-form-urlencoded")
        return head
    }
    
    var parameters = [String: Any]()
}
