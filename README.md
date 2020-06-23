# Forecast

## Description
This is a small test project that started as a weekend project.  It is still in the works in it's current form.  It is a weather app that will show you forecast data for any city that a user chooses.


I coded this using typical Apple/MVC conventions, mainly because it's a small project, and I think MVC is well suited for that.  There are 2 main services in the app: `CitiesProvider` which manages the list of cities the user has selected and `ForecastService` which handles getting the forecast for the cities.  These services are injected into the view controllers which depend on them simply by property assignment. There are a few business logic methods extracted out into a separate file (`PureFunctions`) for ease of testing. 

On the topic of testing - There is no testing in this app, although I wrote the code with that in mind.  Creating protocols for the injected services will make them easy to be mocked.  Separating out the business logic to pure functions make those easy to test as well. 

## Installation
Make sure you have the latest version of Xcode.  
Clone the repo, and launch Forecast.xcworkspace

This project uses Cocoapods for the Google Places library.  
The files should be included in this repo, and there should not be anything you have to do to install them.  
However, if there are issues, you may need to run `pod install` in the root directory of this app. (You will need to have [cocoapods](https://cocoapods.org) installed first.)


There are 2 main branches - `master` and `swiftUI`.
- `master` is more solid and uses UIKit.
- `swiftUI` is more experimental, and really a playground for me at this point.  It only runs on an actual device (SwiftUI bug)

## Future features / Nice to haves 
- Create better UI to make things look cooler.  Custom icons for buttons instead of just text.  Cool backgrounds depending on weather conditions, slick animations throughout the app, etc. 
- Robust error handling.  There is space for it in the code, I just didn't go down that road to far because of time constraints
- Reordering of Cities on the city screen.
- More details on the detail screen.
- Tests

## Dependencies
This app uses CocoaPods to add the `GooglePlaces` framework.
Make sure you open using the Forecast.xcworkspace file.  If there are issues, you may need to navigate to the root directory and run `pod install`

It also uses the [Open Weather map](https://openweathermap.org/current) API.





