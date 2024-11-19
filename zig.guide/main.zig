const std = @import("std");
const expect = std.testing.expect;

pub fn main() void {
    const user = User{
        .power = 9001,
        .name = "Scrat",
    };

    std.debug.print("Hello, {s} with power {d}!\n", .{ user.name, user.power });
}

pub const User = struct {
    power: u64,
    name: []const u8,
};

test "always succeeds" {
    try expect(true);
}

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

test "while with continue expression" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 10) : (i += 1) {
        sum += i;
    }

    try expect(sum == 55);
}

test "while with continue" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 3) : (i += 1) {
        if (i == 2) continue;
        sum += i;
    }

    try expect(i == 4);
}

test "while with break" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 3) : (i += 1) {
        if (i == 2) break;
        sum += 1;
    }

    try expect(sum == 1);
}

test "for" {
    const array = [_]u8{ 'a', 'b', 'c' };

    for (array, 0..) |character, index| {
        _ = character;
        _ = index;
    }

    for (array) |character| {
        _ = character;
    }

    for (array, 0..) |_, index| {
        _ = index;
    }

    for (array) |_| {}
}

fn addFive(a: u32) u32 {
    return a + 5;
}

test "addFive" {
    const y = addFive(2);

    try expect(@TypeOf(y) == u32);
    try expect(addFive(1) == 6);
}

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "fibonacci" {
    const fi = fibonacci(10);

    try expect(fi == 55);
}

test "try defer" {
    var u: i16 = 2;
    {
        defer u += 5; // defer the execution of the statement until exiting inclosing block
        try expect(u == 2);
    }

    try expect(u == 7);
}

test "multiple defer" {
    // the execution of multiple defer are in reverse order
    var n: f32 = 5;
    {
        defer n += 2; // execute second
        defer n /= 2; // execute first
    }

    try expect(n == 4.5);
}
