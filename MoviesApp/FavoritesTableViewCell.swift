//
//  FavoritesTableViewCell.swift
//  MoviesApp
//
//  Created by Tatyana Korotkova on 07.02.2021.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
