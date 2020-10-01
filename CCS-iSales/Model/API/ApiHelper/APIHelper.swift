//
//  APIHelper.swift
//  ImageFetchingAndDisplayingDemo
//
//  Created by NC2-28 on 13/02/18.
//  Copyright © 2018 NC2-28. All rights reserved.
//fc

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class APIHelper {
    static let shared : APIHelper = {
        let instance = APIHelper()
        return instance
    }()
    
    //MARK: - Get Request to be called
    func postJsonRequest(url:String,parameter: Parameters,headers: HTTPHeaders,completion: @escaping (Bool,String,[String:Any]) -> Void) {
        Alamofire.request(url,
                          method: .post,
                          parameters: parameter,
                          encoding: JSONEncoding.default,
                          headers: headers ).responseJSON
            { (response:DataResponse<Any>) in
               // print(response)
//                if let data = response.data
//                { let json = String(data: data, encoding: String.Encoding.utf8)
//                    print("Response: \(String(describing: json))")
//
//                }
                switch(response.result)
                {
                case .success( _):
                    if let result = response.result.value as? [String:Any]{
                        completion(true, "success", result)
                    }else{
                        completion(false, "Failed", [:])
                    }
                  //  print("response is success:  \(response)")
                    break
                case .failure( _):
                  //  print(error)
                    completion(false, response.result.error.debugDescription,[:])
                    break
                }
        }
    }
    
    func postMultipartJSONRequest(endpointurl:String, parameters:NSDictionary, encodingType:ParameterEncoding = JSONEncoding.default, responseData:@escaping (_ data: AnyObject?, _ error: NSError?, _ message: String?) -> Void)
    {
        //ShowNetworkIndicator(xx: true)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters
            {
                if value is UIImage {
//                    let imageData:Data = UIImage.jpegDatata(value as! UIImage, 0.3)!
                    let imageData:Data = (value as! UIImage).pngData()!
                    multipartFormData.append(imageData, withName: key as! String, fileName: "swift_file.png", mimeType: "image/png")
                }else if value is NSURL || value is URL {
                    let videoData:Data
                    do {
                        videoData = try Data (contentsOf: (value as! URL), options: .mappedIfSafe)
                        multipartFormData.append(videoData, withName: key as! String, fileName: "swift_file.mp4", mimeType: "video/*")
                    } catch {
                       // print(error)
                        return
                    }
                }else if value is NSArray || value is NSMutableArray {
                    for childValue in value as! NSArray
                    {
                        if childValue is UIImage {
                            
//                            let imageData:Data = UIImageJPEGRepresentation(childValue as! UIImage, 0.3)!
                            let imageData:Data = (childValue as! UIImage).pngData()!
                            multipartFormData.append(imageData, withName: key as! String, fileName: "swift_file.jpg", mimeType: "image/*")
                        }
                        else if childValue is NSURL || childValue is URL {
                            let videoData:Data
                            do {
                                videoData = try Data (contentsOf: (childValue as! URL), options: .mappedIfSafe)
                                multipartFormData.append(videoData, withName: key as! String, fileName: "swift_file.mp4", mimeType: "video/*")
                            } catch {
                               // print(error)
                                return
                            }
                        }
                    }
                }
                else {
                    let valueData:Data = (value as! NSString).data(using: String.Encoding.utf8.rawValue)!
                    multipartFormData.append(valueData, withName: key as! String)
                }
            }
            
        }, to: endpointurl) { encodingResult in
            
            //ShowNetworkIndicator(xx: false)
            
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //if isUploading && isForeground {
                    //self.delegate?.didReceivedProgress(progress: Float(progress.fractionCompleted))
                    //}
                })
                
                upload.responseString(completionHandler: { (resp) in
                    //print("RESP : \(resp)")
                })
                
                upload.responseJSON { response in
                    ////print(response)
//                    if let data = response.data
//                    { let json = String(data: data, encoding: String.Encoding.utf8)
//                        print("Response: \(String(describing: json))")
//                        
//                    }
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value
                        {
                            print(data)
                            
                            let Message = (data as! NSDictionary)[MESSAGE] as? String
                            //                            let responseStatus = (data as! NSDictionary)[WSSTATUS] as! NSString
                            //                            switch (responseStatus.integerValue) {
                            //
                            //                            case RESPONSE_STATUS.VALID.rawValue :
                            //                                self.resObjects = (data as! NSDictionary) as AnyObject!
                            //                                break
                            //
                            //                            case RESPONSE_STATUS.INVALID.rawValue :
                            //                                self.resObjects = (data as! NSDictionary) as AnyObject!
                            //                                break
                            //                            default :
                            //                                break
                            //                            }
                            responseData(data as AnyObject, nil, Message)
                            
                        }
                        break
                        
                    case .failure(_):
                        responseData(nil, response.result.error as NSError?,MESSAGE)
                        break
                        
                    }
                }
            case .failure( _):
                responseData(nil, nil, MESSAGE)
            }
        }
    }
    
    //MARK:- GET Request
    func getRequestWithoutParams(endpointurl:String,responseData:@escaping (_ data:AnyObject?, _ error: NSError?, _ message: String?) -> Void)
    {
        
        let  alamofireManager = Alamofire.SessionManager.default
        alamofireManager.request(endpointurl, method: .get).responseJSON { (response:DataResponse<Any>) in
            
//                        if let data = response.data
//                        { let json = String(data: data, encoding: String.Encoding.utf8)
//                            print("Response: \(String(describing: json))")
//
//                        }
            
            if let _ = response.result.error
            {
                responseData(nil, response.result.error as NSError?,MESSAGE)
            }
            else
            {
                switch(response.result)
                {
                case .success(_):
                    if let data = response.result.value
                    {
                        //let Message = (data as! NSDictionary)[MESSAGE] as! String
//                        let responseStatus = (data as! NSDictionary)[VSTATUS] as! NSString
//                        // if ( responseStatus .isEqual(to: RESPONSE_STATUS_message.success.rawValue as String))
//                        if ( responseStatus .isEqual(to:"success"))
//                        {
//                            self.resObjects = (data as! NSDictionary) as AnyObject!
//                        }
//                        else
//                        {
//                            self.resObjects = (data as! NSDictionary) as AnyObject!
//                        }
//
                        responseData(data as AnyObject, nil, "Sucess")
                    }
                    break
                case .failure(_):
                    responseData(nil, response.result.error as NSError?, MESSAGE)
                    break
                }
            }
        }
    }

}
