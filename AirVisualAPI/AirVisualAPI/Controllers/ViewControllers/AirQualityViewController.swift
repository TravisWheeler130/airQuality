//
//  AirQualityViewController.swift
//  AirVisualAPI
//
//  Created by Travis Wheeler on 11/20/19.
//  Copyright © 2019 Travis Wheeler. All rights reserved.
//

import UIKit

class AirQualityViewController: UIViewController {
    
    var sourceOfTruth: AirQualityData? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var atmosphericPressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var getWeatherButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherButton.layer.cornerRadius = getWeatherButton.frame.height/2
        getWeatherButton.layer.borderColor = UIColor.white.cgColor
        getWeatherButton.layer.borderWidth = 3
    }
    
    @IBAction func fetchDataButtonTapped(_ sender: Any) {
        guard let cityQueryText = cityTextField.text else {return}
        guard let stateQueryText = stateTextField.text else {return}
        AirQualityController.getAirQuality(state: stateQueryText, city: cityQueryText) { (result) in
            switch result {
            case .success(let airQualityData):
                self.sourceOfTruth = airQualityData
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func presentErrorAlertToUser(for error: LocalizedError) {
        let alert = UIAlertController(title: "UH OH", message: error.errorDescription, preferredStyle: .actionSheet)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    func updateViews() {
        guard let airData = sourceOfTruth else { return }
        DispatchQueue.main.async {
            self.cityLabel.text = airData.city
            self.stateLabel.text = airData.state
            self.temperatureLabel.text = "\(airData.current.weather.tp)"
            self.atmosphericPressureLabel.text = "\(airData.current.weather.pr)"
            self.humidityLabel.text = "\(airData.current.weather.hu)"
            self.windSpeedLabel.text = "\(airData.current.weather.ws)"
            self.weatherIconImage.image = UIImage (named: "\(airData.current.weather.ic)")
        }
    }
}
