//
//  DayDetailsViewController.swift
//  Forecast
//
//  Created by Karl Pfister on 1/31/22.
//

import UIKit

class DayDetailsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var dayForcastTableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHighLabel: UILabel!
    @IBOutlet weak var currentLowLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    
    //MARK: - Properties
    //daeclaring a variable called days and setting it to type of an array of day whicvh is our model and initializing it
    var days = [Day]()
   
    //MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayForcastTableView.dataSource = self
        dayForcastTableView.delegate = self
        
        // calling our model controller and using . syntax to call our fetch so it will display all the information we created in the scope of fetch in our model controller.
        NetworkController.fetchDays { days in
            guard let days = days else {return}
            self.days = days
            
            DispatchQueue.main.async {
                self.updateViews(index: 0)
                self.dayForcastTableView.reloadData()
            }
        }
    }
    
    func updateViews(index: Int) {
        // setting that value of our outlets to their specified variable and making the double variables a string so they will display as a string when we load our app
        let currentDay = days[index]
        cityNameLabel.text = currentDay.cityName
        currentDescriptionLabel.text = currentDay.decsription
        currentLowLabel.text = "\(currentDay.ltemp) F"
        currentHighLabel.text = "\(currentDay.htemp) F"
        currentTempLabel.text = "\(currentDay.temp) F"
    }
    
}// End of class

//MARK: - Extenstions
extension DayDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // this line of codes means it will display the numbewr of cells as the same number of days we have in our api
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayForcastTableViewCell else {return UITableViewCell()}
        // using .syntax to call our updateviews we declared in our table view cell file.
        cell.updateViews(day: days[indexPath.row])
        
        return cell
    }
}// End of extension
