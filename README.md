# Weather Demo

> UPDATE: I have replaced Alamofire (see WeatherService.swift) with Combine and URLSession. 

The app in this repository is a complete SwiftUI iOS app. I wrote this app to show you a little bit of everything, a small soup-to-nuts app that has examples of the most common things you'll find in an app. Plus, this is a good way to get started understanding SwiftUI. Its one thing to read the documentation and even to do the tutorials, but having a working app to actually see things in practice can really help make sense of it all.

> This app was built entirely with SwiftUI 2.0 without any customized or wrapped UIKit components.

The WeatherDemo app displays weather information for a specific location. If the user has allowed the app to track their location, the app will automatically use the current location to get the first forecast. Otherwise, the app presents the user with a button to select their location. The user enters the name of a place (eg, London) and picks from the search results. The Forecast screen displays various elements of weather data including a 10-hour forecast of temperature and percipitation and a week+ forecast. The user can search for new locations. 

## Installation

1. Clone (or download) this repository.
2. The weather data displayed by WeatherDemo comes from [openweathermap.org](https://openweathermap.org). You will need to sign up for their free service to get your own API key. Once you have the key, open the `WeatherService.swift` file and set your API key as directed in the file.
3. Build the app with Xcode 12.0.1 or higher; the target iOS must be at least iOS 14. The build will download and install Alamofire.
4. Run the app on a simulator or real device.

## Overview

I picked weather as the focus of the app for two reasons: I knew it would be small and I knew there were plenty of weather API services from which to choose. I picked [openweathermap.org](https://openweathermap.org) because its free service offers a convenient API with plenty of good documentation. While the WeatherDemo only makes a single request to openweathermap.org, you can use it as a template for handling other types of requests your own apps may need.

To make the API requests to openweathermap.org I chose Alamofire which is a popular kit for handling HTTP calls and responses. I've used Alamofire in the past and its quite simple to use. The request made by WeatherDemo does not begin to touch upon all Alamofire can do, but its a good starting place. I could have gone with native `URLSession` but Alamofire is just so easy to use.

This app shows you the following (in no particular order)

- Shows how to request permission to track the device's location.
- Uses the Core Location to search for places and to reverse geocode locations.
- Core Data is used to preserve the search history.
- Uses URLSession along with Combine to decode the REST API request responses from openweathermap.org
- Shows how to use the Decodable protocol to handle JSON data.
- Shows a simple technique to localize strings to support multiple languages.
- Demonstrates creating custom SwiftUI components.
- Shows how to create Extensions to classes.
- Demonstrates the use of size trait classes to lay out the screen for device independence.
- Uses SVG images

## Services

WeatherDemo uses two services: `LocationService` and `WeatherService`. These services provide the interface from the app to the outside. Each service focuses on a specific thing: `LocationService` is interested in the device location and, if obtained, uses a reverse geocoder (`CLGeocoder` from Core Location) to get the place name for the current location. The `WeatherService` is the interface to openweathermap.org. When the request for weather information about a particular location returns, `WeatherService` decodes the response into a `WeatherData` structure and creates an `HourlyData` array for presentation (more on this later).

The important thing here is that each service is focused and does not depend on each other. They get their data and that's it.

## Model (AppController)

WeatherDemo has a data model called `AppController` and its job is to coordinate the services and provide the data for display by the UI. `AppController` uses Combine to make the UI aware of the data which it can then response to when that data changes. This is part of what makes SwiftUI so fun to work with.

The `AppController` takes location data and invokes the `WeatherService` to get `WeatherData` which it then publishes. If the user wants the weather for a different location, `AppController` again uses `WeatherService` and updates it published data. The UI then refreshes showing the weather for the new location.

## Location Tracking

In order for an app to track the user's location - or even to simply get the user's current location - the user must give the app permission. You do this by adding some lines to the `Info.plist` file. If you open that file you will see two entries: one for "Privacy - Location Always Usage Description" and one for "Privacy - Location When In Use Usage Description." These are simply strings presented to user by iOS when the app wants the location.

If you open the `LocationService.swift` file, you will see in the `start()` function the request to the `CLLocationManager` to request when-in-use authorization. Without those strings present in `Info.plist` your app will never ask the user for their permission nor will it ever get the user's location.

One thing to bear in mind is that the user's location is not necessarily immediately available. If that information is not ready once permission has been granted, the app waits for the location to be determined. This is an asynchronous event that any app needing to use the device location must handle. WeatherDemo simply holds the user on the welcome screen until the data is available. 

## Views

There are two main views, depending on the user's choice to allow WeatherDemo to have access to the device's location or not. If the user chooses to not allow automatic location tracking, WeatherDemo display a simple screen with a "Selection Location" button. 

If the user has allowed WeatherDemo access to the location, once that has been determined, the `AppController` will get the `WeatherData` and having that will trigger the UI to show the `ForecastView`. 

### Forecast View

The primary view of WeatherDemo is `ForecastView`. This shows the location's current conditions (a swipable area of three panels), the hourly forecast for the next ten hours (temperature and rain in a swipable panel) and the forecast for the next eight days. 

The project has the `ForecastView` at the top level and all of the custom SwiftUI components it uses in a folder, `ForecastView Helpers`. 

#### Size Traits

The layout of the `ForecastView` differs from portrait to landscape for the iPhone; the iPad uses the landscape layout for both orientations. This is done by using the "Size Trait Classes" provided by Apple. Rather than looking at the screen's actual orientation or, worse, looking at the screen's actual size, you can use the Size Trait Classes to make your layout based on the amount of space available both horizontally and vertically. On the iPhone, for example, potrait orientation has a vertical size class of `Regular` while its horizontal size class is `Compact`. Rotate the phone and those traits reverse. The iPad, on the other hand, has `Regular` size classes for both dimensions in both orientations. Now while size traits won't solve all of your layout issues or questions, its a great, and easy to use way, to get primary layouts working.

For portrait orientation, the UI in `ForecastView` is displayed vertically with the entire interface scrolling. In landscape orientation, the current conditions are displayed on the left and the forecasts are displayed in a scrollable area on the right. 

#### SVG Images

Being able to use SVG images with iOS apps is relatively new and very handy. All of the graphics for the forecasts were hand-drawn by me (so they are a bit cartoonish) using an SVG editor. All I had to do was import them, as is, into the Assets catalog in Xcode.

To use an SVG image, use the SwiftUI `Image` component with the asset's name: `Image("Clear-Day")` for example. Because these are scalable vector graphics, they can be shown at any size and look good. No more need to have `@2x` and `@3x` PNG files.

In WeatherDemo, the `WeatherData.swift` file contains a map of weather codes (from openweathermap.org) to image names, minus their `-Day` or `-Night` suffixes. Once the weather data for the location is known, the `CurrentConditionsView` uses a function on `WeatherData` to get the correct image given the time of day at the location.

#### Colors

The background color for the app is prepared by the `WeatherDemoApp` which sets its background based on the time of day at the weather location. You'll see that the `ContentView` has a `background` modifier which is just the color which ignores the safe areas, allowing it to fill the entire screen. The rest of the app adheres to the safe areas. This is a nice technique to use to have a full screen app yet pay attention to the safe areas.

The other colors used by the app are set in the Assets and are named colors. This gives you the opportunity to adjust the colors for LightMode and DarkMode without having to worry about it in code. If you look at the `Extensions.swift` file you will see that Color has been extended to provide convenience names for those colors, too.

### Location Search View

The third screen for WeatherDemo is the `LocationSearchView`. This View provides a search input field and one of two views: either a list of previous search selections or the result of searching for a location.

>`LocationSearchView` is a simple example of showing a model sheet and dismissing it programmatically with SwiftUI

`LocationSearchView` is presented as a "sheet" which means it slides up from the bottom of the screen when activated. You'll find the activate code in the `ContentView` file. It is placed at this high level in the app because location searching is available from both the welcome screen and the `ForecastView` screen. Display of sheets is controlled by a simple `Bool` toggle.

Core Data is used to store the search history. For example, if you entered "Boston" and the results included "Boston, MA, United States", and you selected that, it will be stored using Core Data and presented the next time the `LocationSearchView` was shown.

As the user types their search term, the app uses the `LocationSearchModel` to find matches. The model itself uses Apple's `MKLocationSearch` API and presents the results in a `@Published` variable which is being observed by the `SearchResultsView`.

When the user taps on a search result, the `AppController` is told to update its location data which triggers the `WeatherService` etc. etc. 

## Localization

Every app should always remove its hard-coded strings - at least the ones presented to users - from the code and localize them. This is basically making it possible to have the app presented in multiple languages. For this example, WeatherDemo, only has English strings, but its easy enough to add more languages.

> You can do much more than localize strings with Xcode. You can localize colors and images, too.

In the code you'll find user visible strings used in one of two ways:

- As arguments to a SwiftUI component such as `Text("Hello World")`
- Set into a variable (which might be changed in the code before presentation) as `var label = "Hello World".localized()"

In the first case, SwiftUI has initializers for its components that take localization keys as parameters (`LocalizedStringKey`). In other words, you can put in a string as a parameter and if it has been localized, it will use the string associated with the key. Or if not, it will use the string as you gave it.

In the second case, I wrote an extention to the `String` class with a `localized()` function which uses `NSLocalizedString()` to look up the string as a key. It says a little typing and looks clearer. 

You will find the localized string data in the file, `en.lproj/Localizable.string`. The `en` part of the folder means its the English language file. If you create a set of French strings it would be in the `fr.lproj` directory.

If you open Xcode and click on the `Localizable.strings` file in the Project panel then look at the File Inspector panel, you'll see that there is a `Localization` section with English checked. To add more languages, open the project file itself, make sure the Project (not the Target) is selected, then under the `Info` tab you will see the `Localizations` section. Use the + (plus) button to add more languages.

## Summary

Well there you have it: WeatherDemo. A little app with whole lot of ideas and examples in it. I hope you find it useful.
