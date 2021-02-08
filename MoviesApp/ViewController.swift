//
//  ViewController.swift
//  MoviesApp
//
//  Created by Tatyana Korotkova on 06.02.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var movies: [Movie] = []
    var actInd = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming movies"
        self.tableView.separatorColor = .white
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            actInd.frame = CGRect(x: window.frame.width/2, y: window.frame.height/2, width: 0, height: 0)
            actInd.hidesWhenStopped = true
            actInd.style = .large
            window.addSubview(actInd)
        }

        getMovies()
    }
    
    func getMovies(){
    
        actInd.startAnimating()
        let api_token = "6c78da2cf41529284dc65d510d302bca"
        let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(api_token)&language=en-US")
        
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "cache-control": "no-cache"
        ]
        
        let session = URLSession.shared
        session.dataTask(with: request){ rawdata,response,error in
            if let error = error{
                print(#function, "error", error.localizedDescription)
                self.tableView.setEmptyMessage("Error loading movies")
                return
            }
            
            guard let data = rawdata, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
                print(#function, "error", "\(String(describing: rawdata))")
                return
            }
            
            guard let moviesJson = json["results"] as? [[String : Any]] else{
                return
            }
            
            for movie in moviesJson{
                do{
                    let parsedMovie = try Movie(json: movie)
                    self.movies.append(parsedMovie)
                }
                catch{
                    print("error")
                }
            }
            
            //MARK: UNCOMMENT TO CHECK THE EMPTY MOVIES CASE
            //self.movies = []
            
            DispatchQueue.main.async {
                if(self.tableView != nil){
                    if self.movies.count == 0 {
                        self.tableView.setEmptyMessage("Error loading movies")
                    }
                    self.actInd.stopAnimating()
                    self.tableView.separatorColor = .gray
                    self.tableView.reloadData()
                }
            }
            
        }.resume()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
        let row = indexPath.row
        
        cell.dateLabel.text = movies[row].date
        cell.movieLabel.font = UIFont.boldSystemFont(ofSize: 17)
        cell.movieLabel.text = movies[row].name
        
        let posterPath = URL(string: "https://image.tmdb.org/t/p/w500" + self.movies[row].path)
        
        var task: URLSessionTask? = nil
        if let url = posterPath{
            task = URLSession.shared.dataTask(with: url, completionHandler: { (data, respose, error) in
                if data != nil{
                    var image: UIImage? = nil
                    if let data = data{
                        image = UIImage(data: data)
                    }
                    if image != nil{
                        DispatchQueue.main.async(execute: {
                            let updateCell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell
                            if updateCell != nil{
                                updateCell?.movieImageView.image = image
                            }
                        })
                    }
                }
            })
        }
        
        task?.resume()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let detailedVC = main.instantiateViewController(identifier: "detailVC") as? DetailViewController else {return}
        
        detailedVC.movieName = movies[indexPath.row].name
        detailedVC.movieID = movies[indexPath.row].id
        detailedVC.movieDescription = movies[indexPath.row].overview
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }


}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 17)
        messageLabel.sizeToFit()

        self.separatorColor = .white
        self.backgroundView = messageLabel
    }

    func restore() {
        self.backgroundView = nil
    }
}

