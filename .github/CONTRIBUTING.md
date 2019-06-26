# Contributing to DiceKit

First off, thanks for taking the time to contribute!

This document is a set of guidelines for contributing to DiceKit. Feel free to propose changes if you disagree.

## Table of Contents

* [Code of Conduct](#code-of-conduct)
* [General Guidelines](#general-guidelines)
  * [Issues](#issues)
  * [Pull Requests](#pull-requests)
* [Getting Started](#getting-started)
* [How Can I Contribute?](#how-can-i-contribute)
  * [Reporting Bugs](#reporting-bugs)
  * [Fixing Bugs](#fixing-bugs)
  * [Fixing Formatting](#fixing-formatting)
  * [Adding New Features](#adding-new-features)
  * [Adding Documentation](#adding-documentation)
  * [Labeled Issues](#labeled-issues)
* [Styleguide](#styleguide)
  * [Git Commit Messages](#git-commit-messages)
  * [Swift](#swift)
* [Attribution](#attribution)



## Code of Conduct

This project and everyone participating in it is governed by the [DiceKit Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [30577766+Samasaur1@users.noreply.github.com](mailto:30577766+Samasaur1@users.noreply.github.com).

## General Guidelines

These are some general guidelines to contributing. Read below if you need more information.

### Issues

* If there is an issue template that matches what you are trying to do, use it
* You can always make issues before pull requests
* Feel free to help others in issues, but you should still follow the Code of Conduct (obviously)

### Pull Requests

* **Please make all pull requests against the `development` branch.**
* If you want to fix an issue, say so on the issue
* Don't attempt to fix issues that others have claimed
  * If they don't appear to be working on it, ask them on the issue. If they say you can take over or they don't respond, go ahead.
  * When in doubt, **@mention** me by including `@Samasaur1` in your message.

## Getting Started

Do the following:

```bash
$ git clone https://github.com/Samasaur1/DiceKit.git
$ cd DiceKit
$ swift package update
$ swift build
$ swift package generate-xcodeproj
$ open DiceKit.xcodeproj
```

This will open an Xcode project consisting of DiceKit. We suggest you then build the project using ⌘B (command-B) or Product→Build.

To see what you should do, head on down to [How Can I Contribute?](#how-can-i-contribute)

## How Can I Contribute?

There are a bunch of ways you can contribute to DiceKit—and you don't even need to write any code if you don't want to.

### Reporting Bugs

* **Ensure the bug was not already reported** by searching on GitHub under [Issues](https://github.com/Samasaur1/DiceKit/issues).
* If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/Samasaur1/DiceKit/issues/new). Be sure to include a **title and clear description**, as much relevant information as possible, and a **code sample** or an **executable test case** demonstrating the expected behavior that is not occurring.
* **Use a clear and descriptive title** for the issue to identify the problem.
* **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
* **Explain which behavior you expected to see instead and why.**
* **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.
* **Which version of DiceKit are you using?** If you are using the Swift Package Manager, you might need to check what the latest version is (please don't say "latest"). If you are using a specific commit, give that hash. If you are using a branch, find the hash of the latest commit on that branch and use that.
* **What's the name and version of the OS you're using**?

### Fixing Bugs

1. Open a new GitHub pull request with the patch.
2. Ensure the PR description clearly describes the problem and solution. Include the relevant issue number if applicable.

### Fixing Formatting

Please make this clear by prefixing your PR title with `Formatting:`. For example, `Fix example formatting` would become `Formatting: Fix example formatting`.

### Adding New Features

We recommend creating a new issue to propose your feature before you create a pull request. That way, if we don't feel it fits the spirit of the project, you haven't spent time on it.

#### Writing the Code

- Please follow the [Styleguide](#styleguide)
- Don't unnecessarily reinvent the wheel. If it makes sense to use a feature already included in DiceKit in your new feature, go ahead. (For an example, see [here](https://github.com/Samasaur1/DiceKit/blob/ba343930afba59e0a18afa013bee521cc413e60d/Sources/DiceKit/Die.swift#L126-L139), where the `canReach` function is used inside the `chance` function).
- Write test cases for your new feature. Take a look at the `Tests/DiceKitTests` directory to see some examples.

We recommend that you test your code locally so that you aren't surprised if the PR tests fail. As of 2019-06-26, here are the tests we run:
- `swift test`. Make sure that you have run `swift test --generate-linuxmain` before doing this, to make sure that you run them all. You can also run the tests with `⌘+U` in Xcode.
- `swiftlint`. [SwiftLint](https://github.com/realm/SwiftLint) is a third-party tool. If you have it installed, just run `swiftlint`, there is a configuration file in the repository already. If you don't have it installed, don't worry, it automatically comments on your pull request and you can address it then.
- Some code analysis tools. They will comment on the PR, but you can't run them locally.
- We check for any added `TODO`s, just to make sure you don't forget anything. This shouldn't be a problem

#### Creating the PR

Use the "PR to development" template. If the PR has a corresponding issue, say `closes #5` (except the actual issue number) after the item in the list of new things.

You will need to update the changelog, and please don't check the checkbox until you have done so.

### Adding Documentation

If you decide to do this, thank you. Keep in mind that we may request changes in order to ensure that the documentation is up to our standards, but we will never refuse a docuementation pull request outright.

### Labeled Issues

Unsure where to begin contributing to DiceKit? You can start by looking through these `good first issue` and `help wanted` issues:

- [Beginner issues](https://github.com/Samasaur1/DiceKit/issues?utf8=✓&q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22) - issues which should only require a few lines of code, and a test or two.
- [Help wanted issues](https://github.com/Samasaur1/DiceKit/issues?utf8=✓&q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22) - issues that we're finding a more difficult than normal, but that you may find easy.

## Styleguide

What follows is a list of styles that you should follow.

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line

### Swift

* Use an indent of 4 spaces (Xcode automatically replaces tabs with 4 spaces)

* Whenever you have a code block surrounded by braces, even if it's one line, format it like this,:

  ```swift
  if condition {
      print(true)
  }
  ```

  instead of like this:

  ```swift
  if condition { print(true) }
  ```

* Don't do this:

  ```swift
  let num1: Int              = 0
  let num2: Double           = 0
  let numberNumberThree: Int = 0
  let _4                     = 0
  ```

* Please use `if-let`/`guard-let` instead of force-unwrapping (i.e. `!`). So do this:

  ```swift
  if let value = optional {
      print(value)
  }
  
  // or
  
  guard let value = optional else {
      return
  }
  print(value)
  ```

  instead of this:

  ```swift
  print(value!)
  ```

* Please use uppercase class/struct/protocol/enum names, along with lowercase method and property names

* Use upper/lower camel case, not snake case. For example:

  ```swift
  // Good:
  let someConstant = SomeClass()
  
  // Bad:
  let some_constant = Some_class()
  ```

* Use argument labels liberally

* If you have any questions, do your best and ask in your PR (or in some other way)

## Attribution

This contributing guide was adapted from both the [Atom contributing guide](https://github.com/atom/atom/blob/master/CONTRIBUTING.md) and the [Ruby on Rails contributing guide](https://github.com/rails/rails/blob/master/CONTRIBUTING.md).

***

If you read down to here, you've gotta be very determined. We hope you decide to contribute!
