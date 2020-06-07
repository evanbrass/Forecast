# Forecast

## Developer Thoughts
I coded this using typical Apple/MVC conventions, mainly because it's a small project, and I think MVC is well suited for that.  There are 2 main services in the app: `CitiesProvider` which manages the list of cities the user has selected and `ForecastService` which handles getting the forecast for the cities.  These services are injected into the view controllers which depend on them simply by property assignment. There are a few business logic methods extracted out into a separate file (`PureFunctions`) for ease of testing. 

On the topic of testing - There is no testing in this app, although I wrote the code with that in mind.  Creating protocols for the injected services will make them easy to be mocked.  Separating out the business logic to pure functions make those easy to test as well. 

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





