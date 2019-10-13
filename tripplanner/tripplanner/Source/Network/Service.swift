//
//  Service.swift
//  tripplanner
//
 // Created by Sundus Abrar on 12.10.19.
//  Copyright © 2019 Sundus Abrar. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import HTTPStatusCodes

class Service : SessionManager {
    static let instance = Service()
    
    var baseURL = URL(string: "https://demo6487883.mockable.io/")!
    
    init() {
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 30
        super.init(configuration: conf)
        print("initialized API with URL: \(baseURL)")
        //startRequestsImmediately = false
    }
    
    func enrichHeaders(_ headers: [String: String]?) -> [String: String]{
        var headers = headers ?? [String: String]()
        
        //add user auth information here
        
        headers["Accept-Language"] = Locale.preferredLanguages.first!
        
        return headers
    }
    
    func request(_ method: Alamofire.HTTPMethod, _ URLString: URLConvertible, parameters: [String : AnyObject]? = nil, encoding: ParameterEncoding = Alamofire.JSONEncoding.default, headers: [String : String]? = nil) -> DataRequest {
        let encoding: ParameterEncoding = method == .get ? Alamofire.URLEncoding.default : Alamofire.JSONEncoding.default
        
        let URLString = absoluteUrlWithString(URLString as! String)
        
        let headers = enrichHeaders(headers)
        
        let req = super.request(URLString, method: method, parameters: parameters, encoding: encoding, headers: headers)
        
        return req
    }
    
    
    var logAllResponseStrings = false
    
    func start(_ request: DataRequest, logResponseString: Bool=false) -> DataRequest {

        request.validate { req, resp, data in
            guard let status = resp.statusCodeValue else {
             //   log.debug("did not receive any error code. failing with network error")
                
                let msg = "errorAlertMessage" //.localized
                let err = NSError(domain: "tripplanner", code: 0, userInfo: [ NSLocalizedDescriptionKey: msg])
                return .failure(err)
            }
            
            if status.isSuccess {
                return .success
            } else {
                var errorDetails = resp.allHeaderFields["X-Error-Message"] as? String
                errorDetails = errorDetails?.removingPercentEncoding
                let err = NSError(domain: "tripplanner", code: 0, userInfo: [ NSLocalizedDescriptionKey: errorDetails ?? status.localizedReasonPhrase ])
                
                return .failure(err)
            }
        }

        if logResponseString || logAllResponseStrings {
            request.responseString { resp in
                if let val = resp.result.value {
                    let str = val as NSString
                    print("response string for \(String(describing: resp.request!.url?.absoluteString)):\n\(str)")
                } else if let error = resp.result.error {
                   print("error logging response string for \(String(describing: resp.request!.url?.absoluteString)): \(error). status: \(String(describing: resp.response?.statusCode))")
                }
            }
        }
        
        request.resume()
        return request
    }
    
    func absoluteUrlWithString(_ urlString: String) -> URL {
        var absoluteUrl = URL(string: urlString)
        
        let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        if absoluteUrl == nil {
            absoluteUrl = URL(string: escapedString)
        }
        
        if absoluteUrl!.host == nil {
            absoluteUrl = URL(string: urlString, relativeTo: baseURL)
            
            if absoluteUrl == nil {
                absoluteUrl = URL(string: escapedString, relativeTo: baseURL)!
            }
        }
        
        return absoluteUrl!
    }
}

class ServiceDateFormatter: NSObject {
    static let shared = ServiceDateFormatter()
    var formatter: DateFormatter
    let apiFormatSpecified = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let userProfileFormat = "yyyy-MM-dd"
    
    fileprivate override init() {
        formatter = DateFormatter()
        formatter.dateFormat = apiFormatSpecified
    }
    
    func initWithFormat() {
        formatter.dateFormat = userProfileFormat
    }
}

extension Service {
    func createOrUpdateTrips(newTrip: Trip, completion: @escaping(DataResponse<TripsResponse>) -> Void) -> Request {
        let localValue = Trip(value: newTrip)
        let params = Mapper<Trip>().toJSON(localValue)
        let req = request(.post, "addTrips", parameters: params as [String : AnyObject])
        return start(req, logResponseString: true).responseObject(completionHandler: completion)
    }

    func fetchAllTrips(completion: @escaping(DataResponse<TripsResponse>) -> Void) {
        let req = request(.get, "fetchAllTrips", parameters: nil)
        start(req, logResponseString: true).responseObject(completionHandler: completion)
    }

}
