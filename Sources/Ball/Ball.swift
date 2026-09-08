@_exported public import Magnitude

/// A center and finite nonnegative radius, interpreted using an explicit metric.
/// Equality compares the representation. Zero radius is permitted.
public struct Ball<Point, Radius: Magnitude::Scalar> {
    public var center: Point
    public var radius: Magnitude<Radius>

    public init(center: Point, radius: Magnitude<Radius>) {
        self.center = center
        self.radius = radius
    }

    /// Closed-ball membership, including points on the boundary.
    /// The caller supplies a metric whose distances use the radius's units.
    public func contains<Failure: Swift.Error>(
        _ point: Point,
        using distance: (Point, Point) throws(Failure) -> Magnitude<Radius>
    ) throws(Failure) -> Bool {
        try distance(center, point).value <= radius.value
    }

    /// Strict interior membership; a zero-radius ball has no strict interior.
    public func containsInterior<Failure: Swift.Error>(
        _ point: Point,
        using distance: (Point, Point) throws(Failure) -> Magnitude<Radius>
    ) throws(Failure) -> Bool {
        try distance(center, point).value < radius.value
    }

    /// Exact metric boundary membership. No floating-point tolerance is implied.
    public func containsOnBoundary<Failure: Swift.Error>(
        _ point: Point,
        using distance: (Point, Point) throws(Failure) -> Magnitude<Radius>
    ) throws(Failure) -> Bool {
        try distance(center, point).value == radius.value
    }
}

extension Ball: Equatable where Point: Equatable {}
extension Ball: Hashable where Point: Hashable, Radius: Hashable {}
extension Ball: Sendable where Point: Sendable, Radius: Sendable {}

#if !hasFeature(Embedded)
extension Ball: Encodable where Point: Encodable, Radius: Encodable {}
extension Ball: Decodable where Point: Decodable, Radius: Decodable {}
#endif
