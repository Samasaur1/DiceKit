# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Upcoming]

## [0.19.0] — 2019-12-25
### Added
- Scripts to hide/unhide dev dependencies

### Changed
- Documentation will no longer force-push; instead it will update
- Safety checks were removed from the release script

### Fixed
- Dev dependencies, such as Danger, are now only included, downloaded, and built on CI

## [0.18.1] - 2019-08-22
### Fixed
- The release script has been fixed (closes #67)
- The automatic documentation has been fixed

## [0.18.0] - 2019-08-04
### Added
- Add release.py and updateVersion.py scripts
- Add [Danger](https://github.com/danger/swift) integration
  - Checks that PRs to master have Version X.Y.Z: $DESCRIPTION as their title
  - Checks that there are changes to the CHANGELOG
  - Checks that the latest date is the date that the PR is merged (technically the date of the last Travis build)
  - Checks that there are changes in tests files when source files are changed
  - Checks that `swift test --generate-linuxmain` is run when new tests are written
- Ensure that all structs conform to a new type, `Describable` (`CustomStringConvertible & CustomDebugStringConvertible`)

### Changed
- All classes were converted to structs
- Moves everything to one pull request template so that it comes up by default

### Fixed
- The image on the generated documentation is no longer cut off
- Ensures that a pull request template is applied

### Removed
Update .travis.yml in case https://swiftenv.fuller.li/install.sh is down/has no SSL certificate

## [0.17.0] - 2019-07-26
### Added
- New feature guidelines
- Issue and pull request templates
- `Rollable`
  - `chance(of:_:)`
  - `probabilities` — property of type `Chances`
  - `chance(of:)` for rolling in ranges
- `CustomDie`
  - `chance(of:)` for a specific possibility
- `Chance`
  - `gcd(_:_:)` and `lcm(_:_:)`
  - `+`, `-`, and `+=` operators
  - `normalized` — proportionally scales every Chance until the sum is 1

### Changed
- `Chances`
  - No longer has entries in the dictionary for `Roll`s where the `Chance` is 0

### Fixed
- Latest compatible version links to refer to releases rather than the tree at the specified tag
- `Rollable`
  - `roll(times:_:)` would crash when called like so: `roll(times: 1, .dropOutsides)`

## [0.16.1] - 2019-06-24
### Added
- Testing on Swift 5.0.1 and Xcode 10.2

### Fixed
- Auto-deploying docs

## [0.16.0] - 2019-06-24
### Added
- `CustomDie`
- `DieSide`
- `Error`
- `WeightedDie`
- `Chances`
- `Chance`
- More documentation
- Hound support
- SwiftLint support

### Changed
- Changed failable initializers into throwing initializers
- Moved `roll(times:_:)` from the `Rollable` classed into an extension to the protocol; this makes it the default implementation. This has no impact on end users.
- Makes Swift 4.2 the minimum version of Swift

### Removed
- Support for Swift 4.0 through Swift 4.1.3

## [0.15.0] - 2018-12-02
### Added
- CODE_OF_CONDUCT.md
- CONTRIBUTING.md
- `Rollable`
  - `averageResult` by [@Taufi](https://github.com/Taufi)
  - `canReach(_:_:)`: determines whether the given rollable can reach the target, using the given roll comparison type
- `Die`
  - `doubleAverageResult` by [@Taufi](https://github.com/Taufi)
- `RollComparison`: denotes the comparison to use in `canReach(_:_:)

### Fixed
- Linux random on versions of Swift before 4.2
- `Dice`
  - Include modifiers in `Dice` addition functions
  - Properly multiply `Die`s in `Dice` multiplication functions.

## [0.14.1] - 2018-11-15
### Fixed
- `Die`
  - Die rolling bug (#44): All dice Swift 4.2+ were being treated as `d6`s by [@Taufi](https://github.com/Taufi)

## [0.14.0] - 2018-10-31
### Added
- `Die`
  - `init?(_ str: String)`: String parsing
- `Dice`
  - `init?(_ str: String)`: String parsing

## [0.13.0] - 2018-10-11
### Changed
- Changed LICENSE from MIT to AFL v3.0

## [0.12.0] - 2018-10-09
### Added
- Logo by [@richardbmx](https://github.com/richardbmx)

## [0.11.0] - 2018-10-1
### Added
- More documentation

## [0.10.0] - 2018-09-29
### Added
- Automatic documentation deployment for the latest version

## [0.9.0] - 2018-09-28
### Added
- Linux support

## [0.8.0] - 2018-09-22
### Changed
- Changed `Roll` to `Int` typealias

## [0.7.0] - 2018-09-22
### Added
- LICENSE
- Swift 4.2/Xcode 10 compatibility

## [0.6.0] - 2018-09-17
### Added
- `Dice`
  - `init(_ die: Die, count: Int)`
  - `init(_ dieIntTuples: (die: Die, count: Int)...)`
  - `init(_ die: Die, count: Int, withModifier modifier: Int)`
  - `init(_ dieIntTuples: (die: Die, count: Int)..., withModifier modifier: Int)`
  - Addition operators for `Dice` and `(Die, Int)`
  - `+=` for `Dice` and `(Die, Int)`
- `Die`
  - Addition operators for `Die` and `(Die, Int)` -> `Dice`

## [0.5.0] - 2018-09-13
### Added
- `Rollable`
  - `roll(times:_:)`: rolls a given number of times and performs the given operation on them.
- `MultipleRollResult`: denotes the operation to do on `roll(times:_:)`
- `public typealias DKMultipleRollResult = MultipleRollResult`

## [0.4.0] - 2018-09-12
### Added
- Typealiases
  - `public typealias DKDie = Die`
  - `public typealias DKDice = Dice`
  - `public typealias DKRoll = Roll`
  - `public typealias DKRollable = Rollable`

## [0.3.0] - 2018-09-11
### Added
- `Die`
  - multiplication operators for `Die` and `Int` that return `Dice`
- `Dice`
  - multiplication operators for `Dice` and `Int` that return `Dice`

## [0.2.0] - 2018-09-02
### Added
- `Dice`
  - `numberOfDice`: the number of `Die`s in the object
- `Rollable`
  - `minimumResult`: the lowest possible roll
  - `maximumResult`: the highest possible roll

## [0.1.0] - 2018-09-01
### Added
- `Die`: class; conforms to `Rollable`
- `Dice`: class; conforms to `Rollable`
- `Roll`: the result of rolling a `Rollable`
- `Rollable`: a protocol for anything that is rollable

[Upcoming]: https://github.com/Samasaur1/DiceKit/compare/development
[0.19.0]: https://github.com/Samasaur1/DiceKit/compare/v0.18.1...v0.19.0
[0.18.1]: https://github.com/Samasaur1/DiceKit/compare/v0.18.0...v0.18.1
[0.18.0]: https://github.com/Samasaur1/Dicekit/compare/v0.17.0...v0.18.0
[0.17.0]: https://github.com/Samasaur1/Dicekit/compare/v0.16.1...v0.17.0
[0.16.1]: https://github.com/Samasaur1/DiceKit/compare/v0.16.0...v0.16.1
[0.16.0]: https://github.com/Samasaur1/DiceKit/compare/v0.15.0...v0.16.0
[0.15.0]: https://github.com/Samasaur1/DiceKit/compare/v0.14.1...v0.15.0
[0.14.1]: https://github.com/Samasaur1/DiceKit/compare/v0.14.0...v0.14.1
[0.14.0]: https://github.com/Samasaur1/DiceKit/compare/v0.13.0...v0.14.0
[0.13.0]: https://github.com/Samasaur1/DiceKit/compare/v0.12.0...v0.13.0
[0.12.0]: https://github.com/Samasaur1/DiceKit/compare/v0.11.0...v0.12.0
[0.11.0]: https://github.com/Samasaur1/DiceKit/compare/v0.10.0...v0.11.0
[0.10.0]: https://github.com/Samasaur1/DiceKit/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/Samasaur1/DiceKit/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/Samasaur1/DiceKit/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/Samasaur1/DiceKit/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/Samasaur1/DiceKit/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/Samasaur1/DiceKit/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/Samasaur1/DiceKit/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/Samasaur1/DiceKit/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/Samasaur1/DiceKit/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/Samasaur1/DiceKit/releases/tag/v0.1.0
