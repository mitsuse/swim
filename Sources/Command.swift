import Foundation
import Commandant
import Result

let usageErrorCode: Int32 = 64

enum CommandError: Error {
    case unavailableSource(InputSource.Id)

    var code: Int32 {
        switch self {
        case .unavailableSource: return 65
        }
    }
}

extension CommandError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .unavailableSource(identifier):
            return "unavalable input source: \(identifier.value)"
        }
    }
}

struct ErrorWriter: TextOutputStream {
    mutating func write(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            fatalError("Cannot write non-utf8 string.")
        }
        FileHandle.standardError.write(data)
    }
}

func print(error: Error) {
    var writer = ErrorWriter()
    print("error:", error, to: &writer)
}

struct ListCommand: CommandProtocol {
    typealias Options = ListOptions

    let verb = "list"
    let function = "list available input sources"

    func run(_ options: Options) -> Result<(), CommandError> {
        let sources = options.current ? [InputSource.current] : InputSource.available
        sources.forEach { source in
            if options.presentWithName {
                print("\(source.name.value) (\(source.identifier.value))")
            } else {
                print(source.identifier.value)
            }
        }
        return .success(())
    }
}

struct ListOptions: OptionsProtocol {
    let current: Bool
    let presentWithName: Bool

    static func evaluate(
        _ m: CommandMode
    ) -> Result<ListOptions, CommandantError<CommandError>> {
        return create
            <*> m <| Option(
                key: "current",
                defaultValue: false,
                usage: "if it is true, the identifier of the current input source is presented"
            )
            <*> m <| Option(
                key: "name",
                defaultValue: false,
                usage: "if it is true, the name and the identifier is presented"
            )
    }

    private static func create(_ current: Bool) -> (Bool) -> ListOptions {
        return { (name: Bool) in
            ListOptions(current: current, presentWithName: name)
        }
    }
}

struct UseCommand: CommandProtocol {
    typealias Options = UseOptions

    let verb = "use"
    let function = "use the input source specified with the given identifier"

    func run(_ options: Options) -> Result<(), CommandError> {
        switch use(inputSource: InputSource.Id(options.identifier)) {
        case let .some(error):
            return .failure(.unavailableSource(error.identifier))
        case .none:
            return .success(())
        }
    }
}

struct UseOptions: OptionsProtocol {
    let identifier: String

    static func evaluate(
        _ m: CommandMode
    ) -> Result<UseOptions, CommandantError<CommandError>> {
        return create
            <*> m <| Argument(usage: "the identifier of an avaiable input source")
    }

    private static func create(_ identifier: String) -> UseOptions {
        return UseOptions(identifier: identifier)
    }
}
