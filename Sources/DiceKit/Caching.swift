/// An object that caches the results of intensive computations.
///
/// In DiceKit, the only cached values are probability computations,
///   which can be very intensive.
///
/// The results of rolling are **NOT** cached.
///
/// **Implemented By**
/// * `Dice`
///
/// See `ENABLE_CACHING` for configuring caching of all `Caching` types.
///
/// - Since: 0.22.0
/// - Author: Samasaur
public protocol Caching {
    /// Whether or not caching is enabled.
    static var enableCaching: Bool { get set }
}

/// Whether or not DiceKit types should cache the results of probability computations across objects.
/// 
/// The results of rolling are **NOT** cached.
///
/// Every type that supports caching has its own `enableCaching` property.
/// Setting this property overwrites each type's configuration.
/// This property returns `true` when *every* supported type has caching enabled,
///   and `false` when *any* supported type has caching disabled.
///
/// **Types that currently support caching:**
/// * `Dice`
///
/// - Since: 0.22.0
public var ENABLE_CACHING: Bool {
    get {
        return Dice.enableCaching
    }
    set {
        Dice.enableCaching = newValue
    }
}
