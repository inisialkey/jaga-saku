/// The date-range scope chosen on the Export screen. `custom` pairs with the
/// two picked bounds on [ExportOptions]; the other three resolve to a
/// `[start, end)` window (or the unbounded `[null, null)` for [all]) at export
/// time via `ExportOptions.toParams`.
enum ExportDatePreset { thisMonth, lastMonth, custom, all }
