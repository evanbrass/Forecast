//
//  HourlyForecastInfoView.swift
//  Forecast
//
//  Created by Evan Brass on 6/5/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import UIKit

// TODO:Evan document
class HourlyForecastInfoView: UIView {
    var timeLabel = UILabel(frame: .zero)
    var imageView = UIImageView(frame: .zero)
    var tempLabel = UILabel(frame: .zero)
    
    init(timeStamp: Int, temp: Double, image: UIImage?) {
        super.init(frame: .zero)
        
        // Time Label:
        timeLabel.text = timeTextForTimeStamp(timeStamp)
        timeLabel.font = .thin(.small)
        timeLabel.textAlignment = .center
        timeLabel.minimumScaleFactor = 0.5
        timeLabel.adjustsFontSizeToFitWidth = true
        
        // ImageView
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        // TempLabel
        tempLabel.text = "\(Int(temp))"
        tempLabel.font = .thin(.large)
        tempLabel.textAlignment = .center
        
        // Stack
        let stack = UIStackView(arrangedSubviews: [timeLabel, imageView, tempLabel])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        // Constraints
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
