public typealias Value = Equatable

public protocol WrappedValue: Value {
    associatedtype RawValue: Value

    var value: RawValue { get }
}

extension WrappedValue where Self: Hashable, Self.RawValue: Hashable {
    public var hashValue: Int {
        return value.hashValue
    }
}

public func == <V: WrappedValue>(x: V, y: V) -> Bool {
    return x.value == y.value
}

public protocol Identifier: Value, Hashable {
}

public protocol Entity: Hashable {
    associatedtype Id: Identifier

    var identifier: Id { get }
}

extension Entity {
    public var hashValue: Int {
        return identifier.hashValue
    }
}

public func == <E: Entity>(x: E, y: E) -> Bool {
    return x.identifier == y.identifier
}
