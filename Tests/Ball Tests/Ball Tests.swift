import Ball
import Testing
import Foundation
import Point
import Tagged

@Suite struct `Ball metric contracts` {
    private func distance(_ a: Int, _ b: Int) throws -> Magnitude<Int> {
        try Magnitude(validating: abs(a - b))
    }

    @Test func `Closed membership distinguishes interior boundary and exterior`() throws {
        let ball = Ball(center: 10, radius: try Magnitude(validating: 3))
        #expect(try ball.contains(12, using: distance))
        #expect(try ball.containsInterior(12, using: distance))
        #expect(try ball.contains(13, using: distance))
        #expect(try ball.containsOnBoundary(13, using: distance))
        #expect(try !ball.containsInterior(13, using: distance))
        #expect(try !ball.contains(14, using: distance))
        #expect(try !ball.containsOnBoundary(14, using: distance))
    }

    @Test func `Zero radius contains its center but has no strict interior`() throws {
        let ball = Ball(center: 2, radius: Magnitude<Int>.zero)
        #expect(try ball.contains(2, using: distance))
        #expect(try ball.containsOnBoundary(2, using: distance))
        #expect(try !ball.containsInterior(2, using: distance))
        #expect(try !ball.contains(3, using: distance))
    }

    @Test func `Metric selection is explicit for noncoordinate points`() throws {
        let ball = Ball(center: "a", radius: Magnitude<Int>.zero)
        func discrete(_ a: String, _ b: String) throws -> Magnitude<Int> {
            try Magnitude(validating: a == b ? 0 : 1)
        }
        #expect(try ball.contains("a", using: discrete))
        #expect(try !ball.contains("b", using: discrete))
    }

    @Test func `Metric failures retain their error type`() throws {
        enum Failure: Error { case unavailable }
        let ball = Ball(center: 0, radius: Magnitude<Int>.zero)
        func metric(_ a: Int, _ b: Int) throws(Failure) -> Magnitude<Int> {
            throw .unavailable
        }
        #expect(throws: Failure.unavailable) { try ball.contains(0, using: metric) }
        #expect(throws: Failure.unavailable) { try ball.containsInterior(0, using: metric) }
        #expect(throws: Failure.unavailable) { try ball.containsOnBoundary(0, using: metric) }
    }

    @Test func `Tagged centers retain their frame in public call sites`() throws {
        enum World {}
        typealias Position = Tagged<World, Point<3, Int>>
        let center = Position(_unchecked: Point(x: 1, y: 2, z: 3))
        let ball = Ball(center: center, radius: try Magnitude(validating: 2))
        let preserved: Position = ball.center
        #expect(preserved == center)
    }

    @Test func `Coding rejects invalid radii and preserves valid values`() throws {
        for value in [-1, -100] {
            let data = Data("{\"center\":2,\"radius\":\(value)}".utf8)
            #expect(throws: DecodingError.self) {
                try JSONDecoder().decode(Ball<Int, Int>.self, from: data)
            }
        }
        let ball = Ball(center: 2, radius: try Magnitude(validating: 3))
        #expect(try JSONDecoder().decode(Ball<Int, Int>.self, from: JSONEncoder().encode(ball)) == ball)
        #expect(Set([ball, ball]).count == 1)
    }

    @Test func `Point coding conformances are independent`() throws {
        struct EncodeOnly: Encodable { let value: Int }
        struct DecodeOnly: Decodable { let value: Int }
        let ball = Ball(center: EncodeOnly(value: 7), radius: Magnitude<Int>.zero)
        let data = try JSONEncoder().encode(ball)
        let decoded = try JSONDecoder().decode(Ball<DecodeOnly, Int>.self, from: data)
        #expect(decoded.center.value == 7)
        #expect(decoded.radius.value == 0)
    }
}
