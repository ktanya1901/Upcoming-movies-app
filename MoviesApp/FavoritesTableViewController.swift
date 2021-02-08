//
//  FavoritesTableViewController.swift
//  MoviesApp
//
//  Created by Tatyana Korotkova on 07.02.2021.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var favMovies: [String] = []
    private let current: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favMovies = UserDefaults.standard.stringArray(forKey: "Favorites") ?? []
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favMovies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! FavoritesTableViewCell
        
        cell.titleLabel.text = favMovies[indexPath.row]
        cell.deleteButton.setTitleColor(.gray, for: .normal)
        cell.deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        cell.deleteButton.tag = indexPath.row
        
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteButtonPressed(sender: UIButton){
        let movieName = favMovies[sender.tag]
        if let ind = favMovies.firstIndex(of: movieName){
            favMovies.remove(at: ind)
            UserDefaults.standard.setValue(favMovies, forKey: "Favorites")
            self.tableView.reloadData()
        } else{
            return
        }
    }
        
        
}


