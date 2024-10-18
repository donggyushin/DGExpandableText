# DGExpandableText

SwiftUI expandable text with "more" button, iOS 16+, fully customizable, support line height.

## Installation

### Swift Package Manager

The [Swift Package Manager](https://www.swift.org/documentation/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding `DGExpandableText` as a dependency is as easy as adding it to the dependencies value of your Package.swift or the Package list in Xcode.

```
dependencies: [
   .package(url: "https://github.com/donggyushin/DGExpandableText.git", .upToNextMajor(from: "1.0.0"))
]
```

Normally you'll want to depend on the DGLineHeight target:

```
.product(name: "DGExpandableText", package: "DGExpandableText")
```

## Usage
```swift
    DGExpandableText(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut laborum",
        lineLimit: 3,
        lineHeight: 30,
        moreButtonText: " 더 보기",
        moreButtonFont: .boldSystemFont(ofSize: 15)
    )
    .foregroundStyle(.gray)
```