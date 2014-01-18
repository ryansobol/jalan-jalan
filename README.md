Jalan Jalan
===========

"Jalan jalan" means "Walking, walking" in Indonesian.


#### Research

I used https://developer.apple.com and http://stackoverflow.com for all the research into this project.


#### CoreLocation

First, I need a location service that retreives the device's current location over time. At first glance, the significant-change location service seems ideal for this app. The service is a low-power way to get a device's current location and be notified of location changes even if the app isn't running.

Upon further investigation, the signfication-change location service emits notifications when the device moves 500 meters or more from its previous notification. And those notifications are emitted once every five minutes at best.

For a fitness-style app like Strava or RunKeeper, these trade-offs would diminish the user experience. That leaves only one option -- the standard location service.

The standard location service will allow the app to specify a high level of accuracy and timely updates for location changes. When moved to the background, the app can also defer location updates (if supported by the device) to avoid draining the battery.

If this was a production app, I would ensure location services were enabled and unrestricted by the user for all use cases and experiment with battery-efficient location updates for all targetted devices.


#### MapKit

Next, I moved on to visualizing the data retreived by the location service. Within an iPhone-only storyboard, I built an initial view controller, positioned a map view and two buttons using auto layout, and connected the views to outlets and actions.

On launch, the map view centers its region and automatically tracks the device's current location over time. Tapping the "Start" button starts another stream of location data (via my location service) which is captured by a journey model object. The captured data is used to visualize the device's journey as a map view overlay. Tapping the "Stop" button stops this stream.

The app leverages a polyline, map view overlay introduced in iOS 7 that inherits from `NSObject` instead of `UIView`. This new overlay consumes less resources and draws to the screen faster compared to it's previous counterpart.

Profiling the app with Instruments reveiled that updating the journey model with new location data and then subsequently preparing the map view's overlay is the most CPU intesive operation in my code. So I decided to dispatch this work as a single task on the main queue. Now it won't block the main thread when the UI wants to handle events from the user while preserving the order of location updates.
