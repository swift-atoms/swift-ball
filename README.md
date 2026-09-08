# Ball

A center and a finite nonnegative radius interpreted through an explicit metric.
Magnitude owns radius validation. Point identity and frame remain in the center's
supplied type; no coordinate arithmetic or Euclidean interpretation is installed.

```swift
import Ball
let ball = Ball(center: 10, radius: try Magnitude(validating: 3))
let inside = try ball.contains(12) { a, b in
    try Magnitude(validating: abs(a - b))
}
```

`contains` includes the boundary, `containsInterior` uses a strict comparison,
and `containsOnBoundary` uses exact equality. The supplied distance function must
satisfy metric laws and return distances in the radius's units. A closure's type
cannot prove those laws. Zero radius is valid; it includes the center but has no
strict interior. Floating-point tolerance policies and metric algorithms belong
to the supplied relationship. Equality compares center and radius, not loci under
a chosen metric. Mutable radii remain validated Magnitude values.

Production depends only on the Magnitude atom by URL. Point and Tagged are test
call-site dependencies. Coding delegates radius validation to Magnitude. Encoding and decoding impose
only their respective conformance on both center and radius storage.
Native workspace integration and test execution are pending. No cross-platform
or full atom-phase completion is claimed.

Validation: registered in atoms.xcworkspace. GUI-backed native MCP umbrella
build-for-testing and all focused Ray/Ball/Orthotope tests passed on My Mac,
2026-09-08 21:01 (29 runtime cases total). See consolidation README for result
bundle and remaining phase work. Earlier pending-registration notes are superseded.
