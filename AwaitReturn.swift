/// Returns a value from an asynchronous context into a concurrent one.
public func awaitReturn<V>(_ produceValue: @escaping () async -> V) -> V {
    let container = AsyncContainer<V>()
    
    Task {
        container.result = await produceValue()
        container.done = true
    }
    
    while !container.done { }
    
    return container.result
}


fileprivate final class AsyncContainer<V> {
    var done = false
    var result: V!
}
