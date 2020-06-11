# Forecast

<img src="resources/demo.gif" width="300">

## Description

This is a simple app that I am using to play around with SwiftUI.  It just shows weather forecast data for a list of cities. 
It's still a work in progress, but feel free to clone and play around with it as you will.  

There are 2 targets that you can choose from: Forecast and Forecast-SwiftUI.  The SwiftUI target will be the more up-to-date
target, so I would suggest running with that.


## Future features / Nice to haves 
- Create better UI to make things look cooler.  Custom icons for buttons instead of just text.  Cool backgrounds depending on weather conditions, slick animations throughout the app, etc. 
- Robust error handling.  There is space for it in the code, I just didn't go down that road to far because of time constraints
- Reordering of Cities on the city screen.
- More details on the detail screen / SwiftUI detail screen.
- Tests

## Dependencies
This app uses CocoaPods to add the `GooglePlaces` framework.
Make sure you open using the Forecast.xcworkspace file.  If there are issues, you may need to navigate to the root directory and run `pod install`

It also uses the [Open Weather map](https://openweathermap.org/current) API.





