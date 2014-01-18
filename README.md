Jalan Jalan
===========

This means "Walking, walking" in Indonesian.


#### Research

I used https://developer.apple.com exclusively for all research into this project.


#### CoreLocation

At first glance, the significant-change location service seems ideal for this app. The service is a low-power way to get a device's current location and be notified of location changes even if the app isn't running.

Upon further investigation, the signfication-change location service emits notifications when the device moves 500 meters or more from its previous notification. And those notifications are emitted once every five minutes at best.

For a fitness-style app like Strava or RunKeeper, these trade-offs would diminish the user experience. That leaves only one option -- the standard location service.

The standard location service will allow the app to specify a high level of accuracy and timely updates for location changes. When moved to the background, the app can also defer location updates (if supported by the device) to avoid draining the battery.

If this was a production app, I would ensure location services were enabled and unrestricted by the user for all use cases and that battery-efficient location updates was supported for all targetted devices.
