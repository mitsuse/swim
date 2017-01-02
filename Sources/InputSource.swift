public struct InputSource: Entity {
    public let identifier: Id
    public let name: Name

    public struct Id: Identifier, WrappedValue {
        public let value: String

        init(_ value: String) {
            self.value = value
        }
    }

    public struct Name: WrappedValue {
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
                    identifier: InputSource.Id(extractRawIdentifier(of: source)),
                    name: InputSource.Name(extractName(of: source))
                )
            }
        )
    }

    public static var current: InputSource {
        let rawInputSource = currentRawInputSource

        return InputSource(
            identifier: InputSource.Id(extractRawIdentifier(of: rawInputSource)),
            name: InputSource.Name(extractName(of: rawInputSource))
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
