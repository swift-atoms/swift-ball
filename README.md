# swift-ball

Use this package when you need a region of all points within a radius of a center, measured by a distance function you choose. That includes points that aren't coordinates, such as strings under a discrete metric. Start from `Ball<Point, Radius>`. If the region has different extents along different axes, use swift-ellipse. For an axis-aligned box in N dimensions, use swift-orthotope.

## Laws

- A ball is closed. `contains` holds exactly when `distance(center, point) <= radius`. `containsInterior` holds when the distance is strictly less than the radius, and `containsOnBoundary` holds when it is exactly equal. Every contained point is in exactly one of the interior or the boundary.
- A ball of radius zero contains only its center. The center lies on the boundary, and the interior is empty.
- The ball does not store a metric. Each query calls the function passed to it with `(center, point)` and compares the result with no tolerance. The ball never checks the metric axioms (symmetry, triangle inequality), so two queries that use different functions can disagree about the same ball.
- Decoding rejects a negative radius.
