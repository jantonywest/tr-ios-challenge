//
//  RecomandViewController.swift
//  TradeDev
//
//  Created by Jinto Antony on 2021-01-05.
//  Copyright © 2021 JA. All rights reserved.
//

import UIKit

private let reuseIdentifier = "detail"

class RecomandViewController: UIViewController ,UICollectionViewDataSource {
    var recomandMovieManager = MovieManager()
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "CollectionViewCel", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        self.connectRecommandApi()
    }

    // MARK: UICollectionViewDataSource

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.recomandMovieManager.movies?.count ?? 0
    }
    func connectRecommandApi(){
        HttpService().connectMoviesList("/details/recommended/1.json") { (data,err) in
            if let data = data{
                print(data)
                self.recomandMovieManager = MovieManager(data)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                 
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.recomandMovieManager.movies?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCel{
            myCell.imgView.getImage(url: self.recomandMovieManager.getImgUrl(atIndex: indexPath.row))
            
            myCell.backgroundColor = UIColor.clear
         return myCell
        }
        return UICollectionViewCell()
    }

}
