import Mapper

extension Transform {
    /// Create money objects from top level currency and cents.
    ///
    /// - parameter currency: The currency to use.
    /// - parameter object:   The amount value to use.
    /// - throws:             MapperError if cents isn't an Int.
    ///
    /// - returns: A money object from the given currency and amount.
    static func toMoney(currencyCode: String?) -> (Any?) throws -> Money {
        return { object in
            guard let amount = object as? Int, let currencyCode = currencyCode else {
                throw MapperError.convertibleError(value: object, type: Int.self)
            }

            return Money(amount: amount, currencyCode: currencyCode)
        }
    }
}
