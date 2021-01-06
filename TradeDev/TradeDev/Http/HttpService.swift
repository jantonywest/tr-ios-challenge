//
//  HttpService.swift
//  TradeDev
//
//  Created by Jinto Antony on 2021-01-05.
//  Copyright © 2021 JA. All rights reserved.
//

import Foundation
class HttpService {
    
    let baseUrl = "https://raw.githubusercontent.com/TradeRev/tr-ios-challenge/master"
    static let imageCache = NSCache<AnyObject, AnyObject>()
    func connectMoviesList(_ defaultUrl:String = "/list.json", _ completionHandler: @escaping(_ data:Movies?,  _ error:Error?) -> Void) ->Void{
        let listUrl = baseUrl + defaultUrl
        guard let url = URL(string: listUrl) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let data = data{
                print(data)
               do{
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                                          data, options: [])
                    print(jsonResponse)
                
                
                    let modeldata:Movies = try! JSONDecoder().decode(Movies.self, from: data)
                    print(modeldata)
                    completionHandler(modeldata,err);

                } catch let parsingError {
                    print("Error", parsingError)
                    completionHandler(nil,nil);
                }
            }
            if let res = res{
                print(res)
            }
            if let err = err{
                print(err)
            }
            completionHandler(nil,err);
        }.resume()

    }
    func connectMovieDetails(_ id:Int,_ completionHandler: @escaping(_ data:MovieDetails?,  _ error:Error?) -> Void) ->Void{
        let detailUrl = baseUrl + "/details/\(id).json"
        guard let url = URL(string: detailUrl) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let data = data{
                print(data)
                do{
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                                                             data, options: [])

                    print(jsonResponse)
                 
                   let modeldata:MovieDetails = try! JSONDecoder().decode(MovieDetails.self, from: data)
                    print(modeldata)
                    completionHandler(modeldata,err);
                
                  } catch let parsingError {
                     print("Error", parsingError)
                    completionHandler(nil,nil);
                }
            }
            if let res = res{
                print(res)
            }
            if let err = err{
                print(err)
            }
            completionHandler(nil,err);
        }.resume()

    }
    
    fileprivate func baseUrlRequestApi(url: URL,
                                _ completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    static func getCacheImage(_ strUrl:String) -> Data?{
        return HttpService.imageCache.object(forKey: strUrl as AnyObject) as? Data
    }
    func setCacheImage(_ data:Data?, strUrl:String){
        HttpService.imageCache.setObject(data as AnyObject, forKey: strUrl as AnyObject)
    }
    func getImage(url:URL,_ completionHandler: @escaping(_ data:Data?) -> Void) ->Void{
        if let imageFromCache = HttpService.getCacheImage(url.absoluteString){
            completionHandler(imageFromCache)
            return
        }
        self.baseUrlRequestApi(url: url) { (data, response, error) in
            if let data = data{
                self.setCacheImage(data, strUrl: url.absoluteString)
                completionHandler(data)
            }else{
                self.setCacheImage(Data(), strUrl: url.absoluteString)
            }
            completionHandler(nil)
        }
    }
   
}
