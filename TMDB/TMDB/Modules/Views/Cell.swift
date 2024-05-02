//
//  Cell.swift
//  TMDB
//
//  Created by Пащенко Иван on 25.04.2024.
//

import UIKit

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vote_countLabel: UILabel!
    @IBOutlet weak var vote_averageLabel: UILabel!
    
}
