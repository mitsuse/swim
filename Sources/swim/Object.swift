public typealias Value = Hashable

public protocol Identifier: Value {
}

public protocol Entity: Hashable {
    associatedtype Id: Identifier

    var identifier: Id { get }
}

extension Entity {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

public func == <E: Entity>(x: E, y: E) -> Bool {
    return x.identifier == y.identifier
}
