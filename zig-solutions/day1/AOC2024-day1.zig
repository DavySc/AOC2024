const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const GPA = std.heap.GeneralPurposeAllocator;

pub fn main() !void {
    var gpa = GPA(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const input = @embedFile("input.txt");
    try stdout.print("{d}", .{try solve(allocator, input)});
}

fn solve(allocator: Allocator, input: [:0]const u8) !u64 {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");

    var list1 = ArrayList(u64).init(allocator);
    defer list1.deinit();
    var list2 = ArrayList(u64).init(allocator);
    defer list2.deinit();
    var current: u64 = 0;
    var current2: u64 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) break;
        var iter = std.mem.tokenize(u8, line, " ");
        const a = try std.fmt.parseInt(u64, iter.next().?, 10);
        const b = try std.fmt.parseInt(u64, iter.next().?, 10);
        try list1.append(a);
        try list2.append(b);
    }

    std.mem.sort(u64, list1.items, {}, comptime std.sort.asc(u64));
    std.mem.sort(u64, list2.items, {}, comptime std.sort.asc(u64));
    for (list1.items, 0..) |a, j| {
        const b = list2.items[j];
        current += @max(a, b) - @min(a, b);
    }

    for (list1.items) |a| {
        const b = list2.items;
        const count = std.mem.count(u64, b, &[1]u64{a});
        current2 += count * a;
    }

    return current2;
}
