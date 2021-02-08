//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Tatyana Korotkova on 06.02.2021.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
