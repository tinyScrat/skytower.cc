const std = @import("std");
const expect = std.testing.expect;

pub fn main() void {
    std.debug.print("Hello, {s}!\n", .{"world"});
}

test "always succeeds" {
    try expect(true);
}

// test "always fails" {
//     try expect(false);
// }

test "convert" {
    const a: u64 = 3;
    var b: u32 = 2;
    b += 1;

    try expect(a == @as(u64, b));
}

test "check undefined" {
    const c = 3;
    var d: i32 = undefined;
    d = 1;

    const e: [3]i32 = [3]i32{ 1, 2, 3 }; // array with explictly length
    //const array = [_]u32{ 1, 2, 2, 4 }; // inferred length

    try expect(c != d and e.len == 3);
}

test "if statement" {
    const a = true;
    var x: u16 = 0;
    if (a) {
        x += 1;
    } else {
        x += 2;
    }

    try expect(x == 1);
}

test "if expression" {
    const a = true;
    var x: u16 = 0;
    x += if (a) 1 else 2;
    try expect(x == 1);
}

test "while" {
    var i: u8 = 2;

    while (i <= 100) {
        i *= 2;
    }

    try expect(i == 128);
}
