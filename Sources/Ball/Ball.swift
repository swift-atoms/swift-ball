@_exported public import Magnitude

public struct Ball<Point, Radius: Magnitude::Scalar> {
    public var center: Point
    public var radius: Magnitude<Radius>

    public init(center: Point, radius: Magnitude<Radius>) {
        self.center = center
        self.radius = radius
    }

    public func contains<Failure: Swift.Error>(
        _ point: Point,
        using distance: (Point, Point) throws(Failure) -> Magnitude<Radius>
    ) throws(Failure) -> Bool {
        try distance(center, point).value <= radius.value
    }

    public func containsInterior<Failure: Swift.Error>(
        _ point: Point,
        using distance: (Point, Point) throws(Failure) -> Magnitude<Radius>
    ) throws(Failure) -> Bool {
        try distance(center, point).value < radius.value
    }

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
