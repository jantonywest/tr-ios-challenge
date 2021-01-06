//
//  MovieManager.swift
//  TradeDev
//
//  Created by Jinto Antony on 2021-01-05.
//  Copyright © 2021 JA. All rights reserved.
//

import Foundation

class MovieManager: NSObject {
    var movies:[Movie]?
    
    override init(){
        
    }
    init(_ data: Movies?) {
        if let item = data?.movies{
            self.movies = item
        }
    }
    func getMovieName(atIndex:Int) -> String{
        if let name = self.movies?[atIndex].name{
            return name
        }
        return ""
    }
    func getImgUrl(atIndex:Int) -> URL?{
        if let strUrl = self.movies?[atIndex].thumbnail{
            if let Url = URL(string: strUrl) {
               return Url
            }
        }
        return nil
    }
    func getMovieYear(atIndex:Int) -> String{
        if let year = self.movies?[atIndex].year{
            return "\(year)"
        }
        return ""
    }
    func getMovie(atIndex:Int) -> Movie?{
        return self.movies?[atIndex]
    }

}
