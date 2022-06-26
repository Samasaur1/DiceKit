<img src="https://github.com/Samasaur1/DiceKit/raw/master/logo/logo-black-alone.png" height="150" align="left">

# DiceKit [![tests](https://github.com/Samasaur1/DiceKit/actions/workflows/test.yml/badge.svg?event=push)](https://github.com/Samasaur1/DiceKit/actions/workflows/test.yml)

A Swift framework for simulating dice both real and unreal.

---

**Documentation**: https://samasaur1.github.io/DiceKit/

| Swift Version | Latest DiceKit version |
| ------------- | ---------------------- |
| Below Swift 4 | Not supported |
| Swift 4.0.x | [v0.15.0](https://github.com/Samasaur1/DiceKit/releases/tag/v0.15.0) |
| Swift 4.1.x | [v0.15.0](https://github.com/Samasaur1/DiceKit/releases/tag/v0.15.0) |
| Swift 4.2.x | [Latest version](https://github.com/Samasaur1/DiceKit/releases/latest) |
| Swift 5.0.x | [Latest version](https://github.com/Samasaur1/DiceKit/releases/latest) |
| Swift 5.1.x | [Latest version](https://github.com/Samasaur1/DiceKit/releases/latest) |
| Swift 5.2.x | [Latest version](https://github.com/Samasaur1/DiceKit/releases/latest) |
| Swift 5.3.x | [Latest version](https://github.com/Samasaur1/DiceKit/releases/latest) |
| Swift 5.4.x | [Latest version](https://github.com/Samasaur1/DiceKit/releases/latest) |
| Swift 5.5.x | [Latest version](https://github.com/Samasaur1/DiceKit/releases/latest) |
| Swift 5.6.x | [Latest version](https://github.com/Samasaur1/DiceKit/releases/latest) |
| Swift 5.7.x | [Latest version](https://github.com/Samasaur1/DiceKit/releases/latest) |

---

## Quickstart

### Add DiceKit to your project using the Swift Package Manager

### Roll some dice

```swift
import DiceKit

let myDie = Die.d6
let result = myDie.roll()

let myAbilityScore = myDie.roll(times: 4, .dropLowest)

let damageRoll = Dice("3d6 + 5")
let probabilityDistribution = damageRoll.probabilities
let mightDoNoDamage = damageRoll.chance(of: ...0) != 0
```
