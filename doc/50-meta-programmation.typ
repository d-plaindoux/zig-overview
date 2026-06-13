#import "@preview/polylux:0.4.0": *
#import "style.typ": *

#chapter-slide[
    = Méta-programmation en #box(image(zig-logo-light, height: 1em), baseline: 17%)
]

#default-slide[
    #title[Comptime vs. Runtime]

    == Code éxecuté durant la compilation

]

#default-slide[
    #title[Type universel]

]

#default-slide[
    #title[HKT et le Pure du Foncteur]

#v(0.5em)
```zig
fn Pure(M: fn (type) type, A: type) type {
    return fn (A) M(A);
}

fn Optional(T: type) type { return ?T; }

fn pure(A: type) Pure(Optional, A) {
    return struct {
        fn fun(v: A) Optional(A) { return v; }
    }.fun;
}
```
]

#default-slide[
    #title[HKT et le Pure du Foncteur]

#v(0.5em)
```zig
fn Optional(T: type) type { return ?T; }

fn pure(A: type) Pure(Optional, A) {
    return struct {
        fn fun(v: A) Optional(A) { return v; }
    }.fun;
}
```
]
