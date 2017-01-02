# Swim

[![License][badge-license]][license]
[![Release][release-badge]][release]

Switch the current input method by identifier.


## Installation

Prebuild binary is not provided. Please build from source:

```
git clone -b 0.1.0 git@github.com:mitsuse/swim.git && cd swim
swift build -c release
cp .build/release/swim ${YOUR_EXECUTABLE_PATH}
```


## Usage

`swim` has two sub-commands: `list` and `use`.

### `list`

This sub-command lists identifiers of available input sources on the standard output.
Identifiers are separated by new line.
You can filter them to present the current input source with `--current` option.


### `use`

This sub-comman switch to the input method specified with the given identifier.
For example, `swim use com.apple.inputmethod.Kotoeri` switches the current input source to
Japanese.
If the given identifier is invalid or unavailable,
the command exits with `unavailableSource` (exit code: 65).


## License

The content of this repository are licensed under the MIT License unless otherwise noted.
Please read [LICENSE][license] for the detail.


[badge-license]: https://img.shields.io/badge/license-MIT-yellowgreen.svg?style=flat-square
[license]: LICENSE
[release-badge]: https://img.shields.io/github/tag/mitsuse/swim.svg?style=flat-square
[release]: https://github.com/mitsuse/swim/releases
