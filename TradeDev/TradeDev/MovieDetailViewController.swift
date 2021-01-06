//
//  MovieDetailViewController.swift
//  TradeDev
//
//  Created by Jinto Antony on 2021-01-05.
//  Copyright © 2021 JA. All rights reserved.
//

import UIKit
class MovieDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var desConstraintHeight: NSLayoutConstraint!
    var movie: Movie?
    var movieDetail:MovieDetails?
    var recomandMovieManager = MovieManager()
    override func viewDidLoad() {
        view.addSubview(scrollView)
        desConstraintHeight.constant = 1200
        if let id = movie?.id{
            HttpService().connectMovieDetails(id) { (data,err) in
                if let data = data{
                    print(data)
                    self.loadData(data)
                }
            }
        }
      
        scrollView.contentInset =  UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 7.0);
        self.scrollView.tag = 5
    }

    override func viewDidAppear(_ animated: Bool) {
        updateContentView()
    }
    override func viewWillLayoutSubviews(){
         super.viewWillLayoutSubviews()
         scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height:  800)
     }

    let imageView:UIImageView =  UIImageView()
    func addImageView(_ pic:String) ->UIImageView{
        self.contentView.addSubview(imageView)
        imageView.anchor(self.contentView.topAnchor, left: self.contentView.leftAnchor, bottom:nil, right: self.contentView.rightAnchor, topConstant: 100, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant:0)
        return imageView
       
    }
    
    let lblReleaseDate:UILabel =  UILabel()
    func addReleaseDate(_ date:String) {
        self.contentView.addSubview(lblReleaseDate)
        lblReleaseDate.anchor(self.imageView.bottomAnchor, left: self.contentView.leftAnchor, bottom:nil, right: self.contentView.rightAnchor, topConstant: 2, leftConstant: 20, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 22)
        lblReleaseDate.setConfig(fontSize:12)
        lblReleaseDate.textAlignment = .center
        lblReleaseDate.text = "Release Date : " + date
    }
    
    let lblDesc:UILabel =  UILabel()
    func addDescription(_ des:String?) {
        var description = "description: \n\n"
        if let des = des{
            description += des
        }
      
        self.contentView.addSubview(lblDesc)
        lblDesc.anchor(self.lblReleaseDate.bottomAnchor, left: self.contentView.leftAnchor, bottom:nil, right: self.contentView.rightAnchor, topConstant: 2, leftConstant: 20, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: self.heightForView(self.lblReleaseDate))
        lblDesc.setConfig(fontSize:12)
        lblDesc.textAlignment = .center
        lblDesc.text = description
        lblDesc.textAlignment = .left
    }
    
    let lblNotes:UILabel =  UILabel()
    func addPlot(_ note:String?) {
        var plot = "Plot: \n\n"
        if let note = note{
            plot += note
        }
      
        self.contentView.addSubview(lblNotes)
        lblNotes.anchor(self.lblDesc.bottomAnchor, left: self.contentView.leftAnchor, bottom:nil, right: self.contentView.rightAnchor, topConstant: 2, leftConstant: 20, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: self.heightForView(self.lblReleaseDate))
        lblNotes.setConfig(fontSize:12)
        lblNotes.textAlignment = .center
        lblNotes.text = plot
        lblNotes.textAlignment = .left
    }
    
    let lblRecomand:UILabel =  UILabel()
    func addRecomandLabel() {
        self.contentView.addSubview(lblRecomand)
        lblRecomand.anchor(self.lblNotes.bottomAnchor, left: self.contentView.leftAnchor, bottom:nil, right: self.contentView.rightAnchor, topConstant: 2, leftConstant: 20, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        lblRecomand.setConfig(fontSize:12)
        lblRecomand.text = "recommended:"
        lblRecomand.textAlignment = .left
    }
    
    let viewRecomand:UIScrollView =  UIScrollView()
    func addViewRecomand() {
        self.addRecomandLabel()
        self.contentView.addSubview(viewRecomand)
        viewRecomand.anchor(self.lblRecomand.bottomAnchor, left: self.contentView.leftAnchor, bottom:nil, right: self.contentView.rightAnchor, topConstant: 2, leftConstant: 20, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 100)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        self.addViewRecomand()
        let sView = viewController.view!
        self.viewRecomand.addSubview(sView)
        self.viewRecomand.isUserInteractionEnabled = true
        // Configure Child View
        sView.frame = view.bounds
        sView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewRecomand.contentSize.width = CGFloat(5 * 120)
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    func recomandViewController() {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "recomandView") as! RecomandViewController
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
    }
    
    func loadData(_ movieDetail:MovieDetails?){
        if let movieDetail = movieDetail{
             DispatchQueue.main.async {
                if movieDetail.picture != nil{
                    if let Url = URL(string: movieDetail.picture!) {
                        self.addImageView(movieDetail.picture!).getImage(url: Url, isThumbNail:false)
                        
                    }
                }
                self.addReleaseDate(self.convertTimeIntervalTodate(movieDetail.releaseDate))
                self.addDescription(movieDetail.description)
                self.addPlot(movieDetail.notes)
                self.updateContentView()
                self.recomandViewController()
            }
        }
    }
    
    func convertTimeIntervalTodate (_ int: Int?) -> String {
        let myNSDate = Date(timeIntervalSince1970: TimeInterval(int ?? 0))
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from:myNSDate)
    }
    
    func heightForView(_ lbl:UILabel) -> CGFloat{
        var currHeight:CGFloat!
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: lbl.frame.size.width - 40, height: CGFloat.greatestFiniteMagnitude))
        label.setConfig()
        label.text =  lbl.text!
        label.sizeToFit()
        currHeight = label.frame.height
        return currHeight + 10
    }
    
    func updateContentView() {
        if (self.viewRecomand.frame.maxY + 120) < desConstraintHeight.constant {
            self.scrollView.contentSize.height =  desConstraintHeight.constant + 200
        }else{
            self.scrollView.contentSize.height =  (self.viewRecomand.frame.maxY + 120) + 200
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 5{
            if scrollView.contentOffset.x != 0 {
                scrollView.contentOffset.x = 0
            }
        }
    }
     
}

extension UILabel{
    func setConfig(fontSize:CGFloat = 14){
        numberOfLines = 0
        lineBreakMode = NSLineBreakMode.byWordWrapping
        font = UIFont (name: "Helvetica Neue", size: fontSize)
    }
}
extension UIImage {


    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    /// Switch MIN to MAX for aspect fill instead of fit.
    ///
    /// - parameter newSize: newSize the size of the bounds the image must fit within.
    ///
    /// - returns: a new scaled image.
    func scaleImageToSize(newSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero

        let aspectWidth = newSize.width/size.width
        let aspectheight = newSize.height/size.height

        let aspectRatio = max(aspectWidth, aspectheight)

        scaledImageRect.size.width = size.width * aspectRatio;
        scaledImageRect.size.height = size.height * aspectRatio;
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;

        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
    }
}
