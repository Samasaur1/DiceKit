# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Upcoming]

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
[0.16.1]: https://github.com/Samasaur1/DiceKit/compare/v0.16.0...v0.16.1
[0.16.0]: https://github.com/Samasaur1/DiceKit/compare/v0.15.0...v0.16.0
[0.15.0]: https://github.com/Samasaur1/DiceKit/compare/v0.14.0...v0.15.0
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
