//
//  DetailViewController.swift
//  MoviesApp
//
//  Created by Tatyana Korotkova on 06.02.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var videoWebView: WKWebView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var movieID: Int = 0
    var movieName: String = ""
    var movieDescription: String = ""
    var favMovies: [String] = []
    
    var actInd = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            actInd.frame = CGRect(x: window.frame.width/2, y: window.frame.height/2, width: 0, height: 0)
            actInd.hidesWhenStopped = true
            actInd.style = .large
            window.addSubview(actInd)
        }
        
        getMovieDetails()
        descriptionLabel.text = movieDescription
        videoWebView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        descriptionLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nameLabel.text = movieName
        
        if favMovies.count == 0{
            setSimpleStarButton()
        }
        
        let favMovies = UserDefaults.standard.stringArray(forKey: "Favorites") ?? []
        if favMovies.contains(movieName){
            setFilledStarButton()
        }
        else{
            setSimpleStarButton()
        }
    
    }
    
    @objc func starButtonPressed(){
        if(self.navigationItem.rightBarButtonItem?.image == UIImage(systemName: "star.fill")){
            favMovies = UserDefaults.standard.stringArray(forKey: "Favorites") ?? []
            if let ind = favMovies.firstIndex(of: self.movieName){
                favMovies.remove(at: ind)
                UserDefaults.standard.setValue(favMovies, forKey: "Favorites")
            }
            setSimpleStarButton()
            
        }
        else{
            favMovies = UserDefaults.standard.stringArray(forKey: "Favorites") ?? []
            favMovies.append(movieName)
            UserDefaults.standard.setValue(favMovies, forKey: "Favorites")
            setFilledStarButton()
            print(favMovies)
        }
    }
    
    func setSimpleStarButton(){
        let button = UIBarButtonItem(image: UIImage(systemName: "star"), style:.plain, target: self, action: #selector(starButtonPressed))
        self.navigationItem.rightBarButtonItem = button
    }
    
    func setFilledStarButton(){
        let button = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style:.plain, target: self, action: #selector(starButtonPressed))
        self.navigationItem.rightBarButtonItem = button
    }
    
    func getMovieDetails(){
        actInd.startAnimating()
        
        let api_token = "6c78da2cf41529284dc65d510d302bca"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(self.movieID)/videos?api_key=\(api_token)&language=en-US")
        
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "cache-control": "no-cache"
        ]
        
        let session = URLSession.shared
        session.dataTask(with: request){ rawdata,response,error in
            if let error = error{
                print(#function, "error", error.localizedDescription)
                return
            }
            
            guard let data = rawdata, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
                print(#function, "error", "\(String(describing: rawdata))")
                return
            }
            
            guard let detaisJson = json["results"] as? [[String : Any]], let key = detaisJson[0]["key"] as? String else{
                return
            }
            
            DispatchQueue.main.async {
                self.actInd.stopAnimating()
                self.playVideo(key: key)
            }
            
        }.resume()
    }
    
    func playVideo(key: String){
        let url = URL(string: "https://www.youtube.com/embed/\(key)?playsinline=1?autoplay=1")
        let request = URLRequest(url: url!)
        
        self.videoWebView.load(request)
        
    }
    

}
