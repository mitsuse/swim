import Darwin
import Commandant
import Result

extension CommandRegistry {
    public func run(arguments: [String]) -> Result<(), CommandantError<ClientError>> {
        let parameters = arguments.dropFirst()

        guard let verb = parameters.first else {
            return .failure(.usageError(description: "Sub-command is not given."))
        }

        guard let result = run(
            command: verb,
            arguments: Array(parameters.dropFirst())
        ) else {
            return .failure(
                .usageError(
                    description: "The given sub-command `\(verb)` is invalid."
                )
            )
        }

        return result
    }
}

let commands = CommandRegistry<CommandError>()

commands.register(UseCommand())
commands.register(ListCommand())

if case let .failure(error) = commands.run(arguments: CommandLine.arguments) {
    print(error: error)
    switch error {
    case .usageError:
        Darwin.exit(usageErrorCode)
    case let .commandError(commandError):
        Darwin.exit(commandError.code)
    }
}
