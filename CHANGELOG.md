# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Upcoming]

## [0.25.0] - 2022-06-04
### Added
- Releases are now auto-deployed from GitHub Actions
- Extra checks in Danger

### Changed
- Improve PR template and guidelines
- Danger now runs in GitHub Actions, not Travis CI
- Documentation is now auto-deployed from GitHub Actions, not Travis CI

### Fixed
- We now test on Swift 4.2–5.6, and use the current allowed versions of macOS and Ubuntu

### Removed
- Extra now-obsolete GitHub Actions
- All uses of Travis CI are now gone

## [0.24.1] - 2020-10-15
### Fixed
- Danger now reports tasks in the correct order

## [0.24.0] - 2020-07-13
### Added
- `Chance` objects can now be multiplied together (which, mathematically, represents the chance of both occurring)
- More test cases for `Chance`

### Changed
- `Dice` probabilities computation is now up to 1000x faster (in my tests). From the user's perspective, nothing else about this should have changed.
- The release script now links to the docs for the specific version (on the releases page), not just the main website.

### Fixed
- GitHub Actions can now deploy docs through the use of the GitHub token
- Typos

## [0.23.0] - 2020-07-09
### Added
- A `Package@swift-5.0.swift` file in order to be able to specify supported platforms
- Supported versions of Swift are listed in the package manifest file

### Changed
- Migrate from `Array.index(of:)` to `Array.firstIndex(of:)`
- Continue to define our own implementation of `count(where:)` until at least Swift 6, because (as I found out) the implementation in the standard library was removed because of its impact on type-checker performance.
- Makes the GitHub Actions workflow output nicer.

### Fixed
- Uses the correct Swift version in GitHub Actions tests (closes [#80](https://github.com/Samasaur1/DiceKit/issues/80))

## [0.22.0] — 2020-07-02
### Added
- More documentation on the `chances` property introduced in v0.21.0
- `Dice` caches the result of its computations for `probabilities` between objects (closes [#78](https://github.com/Samasaur1/DiceKit/issues/78)). See the issue (linked) or the pull request [here](https://github.com/Samasaur1/DiceKit/pull/79) for more information on caching.
- `Dice` now conforms to `Hashable` (adding for caching, but handy in general)

## [0.21.0] — 2020-07-01
### Added
- The internal `Chances` property formerly named `dict` (of type `[Roll: Chance]`) is now public and named `chances`.
- Adds GitHub Actions for testing

### Changed
- The GitHub pull request template now uses the `updateVersion.sh` and `release.sh` scripts that were added in PR #66 ([Version 0.18.0](https://github.com/Samasaur1/DiceKit/pull/66))
- The Travis CI configuration has had significant changes (none of which will impact users of the library):
  - Now runs on Ubuntu 16.04 "Xenial" instead of 14.04 "Trusty" (matching the Travis default, and allowing for Swift 5.2.x)
  - Tests on Swift 4.2.4, 5.0.3, 5.1.5, and 5.2.4 (Linux) and 4.2, 5.0.1, 5.1.3, and 5.2.4 (macOS). Previously, it tested on 4.2.4, 5.0.3, and 5.1.3 on both. I would have preferred to use versions tested on Linux on macOS as well, but the current versions are bundled with Xcode, noticeably speeding up builds
  - Prints the Swift version (mostly to help because of the above point)
- Updates the Dangerfile
  - The behavior around adding tests has become more lenient (warnings instead of errors, so that there is less need to change spacing on files to get past Danger)
  - Danger now checks the body of the PR for empty checkboxes, which should allow me to replace `task-list-completed`. It should also present better (failing the check instead of making it say "in progress")
- Updates the README to show the latest Swift versions

### Fixed
- Fixes the `remove_dev_dependencies` script. It turns out that this script had never worked (I don't think), but the place that it was running in CI meant that it didn't matter. It will now work when running on a local machine, though. _Note: this may be becoming irrelevant, as I believe some related feature is coming to a new version of Swift. However, as we currently support as old as 4.2.4, it'll probably be a while before we can drop these scripts completely._

## [0.20.2] — 2020-07-01
### Fixed
- Dice objects with no dice in them (i.e., modifiers only or empty objects) no longer crash when accessing their probabilities property (closes #75)

## [0.20.1] — 2020-06-30
### Added
- `DKError`/`Error`'s `localizedDescription` field now has a useful value (based off of the documentation for those fields).

### Changed
- \[internal\] Complies with best practices (not naming an untyped error in catch clauses; no effect for users).

### Fixed
- Documentation deployment is fixed.
- Errors thrown by `Die(sides:)` do *not* crash `Dice(_:String)`; instead, they are propagated up the call stack.

## [0.20.0] — 2020-02-16
### Changed
- The structure of the GitHub Pages site has changed. There is now a `docs` directory, with subdirectories for each version. The auto-deployment of documentation has been updated to support this.

## [0.19.0] - 2019-12-26
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

[Upcoming]: https://github.com/Samasaur1/DiceKit/compare/v0.25.0...master
[0.25.0]: https://github.com/Samasaur1/DiceKit/compare/v0.24.1...v0.25.0
[0.24.1]: https://github.com/Samasaur1/DiceKit/compare/v0.24.0...v0.24.1
[0.24.0]: https://github.com/Samasaur1/DiceKit/compare/v0.23.0...v0.24.0
[0.23.0]: https://github.com/Samasaur1/DiceKit/compare/v0.22.0...v0.23.0
[0.22.0]: https://github.com/Samasaur1/DiceKit/compare/v0.21.0...v0.22.0
[0.21.0]: https://github.com/Samasaur1/DiceKit/compare/v0.20.2...v0.21.0
[0.20.2]: https://github.com/Samasaur1/DiceKit/compare/v0.20.1...v0.20.2
[0.20.1]: https://github.com/Samasaur1/DiceKit/compare/v0.20.0...v0.20.1
[0.20.0]: https://github.com/Samasaur1/DiceKit/compare/v0.19.0...v0.20.0
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
