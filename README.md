Jalan Jalan
===========

![Screenshot](http://i.imgur.com/q79MstI.png)

"Jalan jalan" means "Going for a walk" in Indonesian.  And coincidentally, it's the first bit of Indonesian I learned over 6 years ago.

Most Indonesian people really want to communicate with foreigners. But their English is extremely limited. However, that doesn't stop them from trying!

When you come across an Indonesian, they'll often ask, "Where are you going?!" It always brings a smile to their face when you reply "Jalan Jalan" in their native language.


#### Research

It's been some months since I've worked with Cocoa Touch. And for some of the required technologies for this project, it was my first time using them. So going into it, I knew research was necessary.

I thought about searching through the CocoaPods repository for libraries that would make my task easier. However, I decided it would better for me to learn and understand the Apple APIs before moving on to magic-performing libraries.  Plus, my projects as of late tend to depend on as few libraries as possible.

Anyway, I mostly used https://developer.apple.com and http://stackoverflow.com as references.


#### CoreLocation

First, I needed a location service that retreives the device's current location over time. At first glance, the significant-change location service seemed ideal for this app. The service is a low-power way to get a device's current location and be notified of location changes even if the app isn't running.

Upon further investigation, I learned the signfication-change location service emits notifications when the device moves 500 meters or more from its previous notification. And those notifications are emitted once every five minutes at best.

For a fitness-style app, like Strava or RunKeeper, these trade-offs would severly curtail the user experience. That left only one option -- the standard location service.

The standard location service allows an app to specify a high level of accuracy and timely updates for location changes. When moved to the background, an app can also defer location updates (if supported by the device) to avoid draining the battery.


#### MapKit

Next, I moved on to visualizing the data retreived by the location service. Within an iPhone-only storyboard, I built an initial view controller, positioned a map view and two buttons using auto layout, and connected the views to outlets and actions.

On launch, the map view centers its region and automatically tracks the device's current location over time. Tapping the "Start" button starts another stream of location data (via my location service) which is captured by a journey model object. The captured data is used to visualize the device's journey as a map view overlay. Tapping the "Stop" button stops this stream which then stops updating the map.

The app leverages the polyline, map view overlay introduced in iOS 7 that inherits from `NSObject` instead of `UIView`. This new overlay consumes less resources and draws to the screen faster compared to it's earlier counterpart.

Profiling the app with Instruments reveiled that updating the journey model with new location data and then subsequently preparing the map view's overlay are my logic's most CPU "intesive" operations (~2ms each on the simulator). For fun, I decided to dispatch this work as a single task on the main queue. Now the work won't block the main thread when the UI wants to handle user events all while preserving the order of location updates.


#### CoreData

Finally, I added the ability to persist the user's journey between launches. As is stands, the journey entity has just one attribute -- a transformable locations attribute that contains every location update received from the location service.

The standard CoreData boilerplate logic is encapsulated in an object I called a model service. On instantiation, it loads the managed object model, connects that to a persistant store, and then binds that to a managed object context.

When the app launches, the model service will either fetch an existing journey or insert a new journey into a managed object context. If an existing journey is found, an overlay of it's location data is sent to the map view for rendering.

There are 4 events that cause a managed object context to be saved.

1. When the user taps the "Stop" button.
2. When the app has moved to the background.
3. When the app will move to the foreground.
4. When the app will be terminated.


#### The Future

Here are some ideas I thought of while developing this project:

##### Possible features

- A button to reset the journey.
- A button to capture photos and annotate the map view so users can remember what their journey looked like.
- A way to save more than 1 journey and review past journeys.

##### Possible optimizations

- Only add locations to the journey that are more than 2-3 meters apart.
- Only draw the map overlay if the journey has changed.
- Only store longitude and latitude location data.

##### UX improvements

- Ensure location services are enabled and unrestricted by the user.
- Ensure multi-tasking is also enabled by the user.
- Experiment with battery-efficient location updates for devices that don't support deferred updates.
