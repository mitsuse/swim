public struct InputSource: Entity {
    public let identifier: Id

    public struct Id: Identifier, WrappedValue {
        public let value: String

        init(_ value: String) {
            self.value = value
        }
    }

    public struct Unavaiable: Error {
        public let identifier: Id
    }
}

extension InputSource {
    public static var available: Set<InputSource> {
        let list = listRawInputSources()

        return Set(
            list.map { source in
                InputSource(
                    identifier: InputSource.Id(extractRawIdentifier(of: source))
                )
            }
        )
    }

    public static var current: InputSource {
        return InputSource(
            identifier: InputSource.Id(extractRawIdentifier(of: currentRawInputSource))
        )
    }
}

public func use(inputSource identifier: InputSource.Id) -> InputSource.Unavaiable? {
    let list = listRawInputSources()

    guard let source = list.first(
        where: { identifier.value == extractRawIdentifier(of: $0) }
    ) else {
        return InputSource.Unavaiable(identifier: identifier)
    }

    guard selectRawInputSource(source) else {
        return InputSource.Unavaiable(identifier: identifier)
    }

    return nil
}
