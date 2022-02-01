//
//  DayForcastTableViewCell.swift
//  Forecast
//
//  Created by Karl Pfister on 1/31/22.
//

import UIKit

class DayForcastTableViewCell: UITableViewCell {

    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var forcastedHighLabel: UILabel!
    
    func updateViews(day: Day) {
        // we are setting our outlets to their proper variable or image so they will display on our app.
        dayNameLabel.text = day.date
        iconImageView.image = UIImage(named: day.icon)
        forcastedHighLabel.text = "\(day.htemp)"
    }

} // End of class
