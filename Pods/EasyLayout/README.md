#  EasyLayout

EasyLayout is a simple, lightweight Swift & Objective-C framework for incorporating AutoLayout. The core syntax is inspired by other frameworks, namely [SwiftAutoLayout](https://github.com/indragiek/SwiftAutoLayout), while incorporating utility functions and decorators that help to take care of AutoLayout's arduous nuances. Ultimately, this results in a streamlined, declarative, and type-safe way to use AutoLayout. Enjoy!

Much of this framework is still a work in progress. It's the culmination of years of projects and code snippets that helped speed up development and

##  Installation

EasyLayout can be installed using CocoaPods or by simply downloading and including a copy of the framework from the 'releases' tab.

##  Usage

### Swift

The syntax for a single constraint matches the analogous syntax used in the official AutoLayout documentation:
```
    view1.attribute == view2.attribute * multiplier + offset
```

This operation produces a NSLayoutConstraint object that can then be activated using the usual method:

```Swift
    view1.translatesAutoresizingMaskIntoConstraints = false
    view2.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
        view1.right == view2.left + 10
    ])

    view1.setNeedsLayout()
```

Or can be activated using a single helper function:

```Swift
    activate(view1.right == view2.left + 10)
```

At runtime, constraints can be replaced just as easily. For example, this is useful for animating the transition of a dynamic layout:

```Swift
    replace(&constraint, with: view1.top == view2.centerY)
```

Finally, there are an assortment of instance variables that can help with view transitions such as the `concreteFrame` property to find the frame of a view that is nested deep in a view hierarchy.

### Objective-C

The syntax for a single constraint in Objective-C is analogous to that in Swift but uses a more verbose definition:

```Objective-C
    [_view1.right equalTo: _view2.left offset: 10];
```

Constraints can then be activated and replaced using the same helper functions:

```Objective-C
    [self activate: @[
        [_view1.right equalTo: _view2.left offset: 10]
    ]];
```

##  Bonus

Constraints can also be constructed using AutoLayout's visual format directly using view objects, rather than a string. These group layouts can be used alongside standard layout objects:

```Swift
    activate([
        (|-view1-100-view2-|).horizontal,
        view1.top == view2,
        view1.height == view2
    ])
```

##  License

Licensed under the MIT License.
