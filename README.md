# PubNubExample
A simple iOS app to demonstrate the PubNub Arduino Bridge

## Installation
- Download a zip file of this project. Libraries should already be installed
  - If they are not, install Cocoapods and run `pod install`
- Replace the `publish_key` and `subscribe_key` parameters with your own keys
- Ensure the team signing settings under  "Project Settings" matches your Apple ID

## Notes
- Some very basic understanding of Swift constructs is necessary - look through the example and ask me if you have any questions
- Most of the work is handled by `PubNubCoordinator` - feel free to copy the `.swift` file into your own project and implement the delegate functions
