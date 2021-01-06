//
//  ViewController.swift
//  TradeDev
//
//  Created by Jinto Antony on 2021-01-05.
//  Copyright © 2021 JA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
     var movieManager = MovieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Movie List"
        self.register()
        HttpService().connectMoviesList { (data,err) in
            if let data = data{
                self.movieManager = MovieManager(data)
                 DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieManager.movies?.count ?? 0
    }
          
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieList", for: indexPath) as! MovieListTableViewCell
        cell.lblMovieName.text = self.movieManager.getMovieName(atIndex: indexPath.row)
        cell.imgView.getImage(url: self.movieManager.getImgUrl(atIndex: indexPath.row))
        cell.lblYear.text = self.movieManager.getMovieYear(atIndex: indexPath.row)
        cell.selectionStyle = .none
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width / 2
        return cell;
    }

    func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
     
         return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailView = self.storyboard?.instantiateViewController(withIdentifier: "movieDetail") as? MovieDetailViewController {
            detailView.movie = self.movieManager.getMovie(atIndex: indexPath.row)
            self.navigationController?.pushViewController(detailView, animated: true)
        }
    }
    
     func register(){
         self.tableView.register(UINib(nibName: "MovieListTableViewCell", bundle: nil), forCellReuseIdentifier: "movieList");
     }

}
extension UIImageView {
    func getImage(url: URL? , isThumbNail:Bool = true) {
        if let url = url{
            DispatchQueue.global().async { [weak self] in
                HttpService().getImage(url: url) { (data) in
                    if let data = data{
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                if isThumbNail {
                                    self?.image = image
                                    self?.contentMode = .scaleToFill
                                }else{
                                    self?.image = image.scaleImageToSize(newSize: CGSize(width: (self?.frame.size.width)!,  height: 500))
                                    self?.contentMode = .scaleAspectFit
                                }
                                self?.clipsToBounds = true
                                self?.layoutSubviews()
                                self?.layoutIfNeeded()
                                 
                            }
                        }
                    }
                }
            }
        }
    }
}
