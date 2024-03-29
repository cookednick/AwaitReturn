Sometimes, within a concurrent context, you need data that is only accessible via asynchronous code. For example, actors work by requiring `await` statements before their data can be accessed.
There is no easy one-line way to do this in Swift as of Swift 5.9.2. **AwaitReturn is one easy way to do this.**

## Usage

```swift
func getName() {
    // Within the awaitReturn block, you can write async code and return it normally.
    let name = awaitReturn { await someActor.name }
    // We now have a "name" constant of type String in our concurrent context.
    print(name)
}
```

## Installation

Include `AwaitReturn.swift` in your project. That's it.
