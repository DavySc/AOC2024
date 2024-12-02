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
    try stdout.print("{d}\n", .{try solve(allocator, input)});
}

fn solve(allocator: Allocator, input: [:0]const u8) !u32 {
    var lines = std.mem.tokenizeSequence(u8, input, "\n");
    var is_safe_counter: u32 = 0;

    while (lines.next()) |line| {
        var numbers = ArrayList(u32).init(allocator);
        //defer numbers.deinit();
        var levels_iterator = std.mem.tokenize(u8, line, " ");
        while (levels_iterator.next()) |level_str| {
            const number = try std.fmt.parseInt(u32, level_str, 10);
            try numbers.append(number);
        }
        is_safe_counter += is_safe(numbers.items);

        numbers.deinit();
    }
    return is_safe_counter;
}

fn is_safe(input: []const u32) u32 {
    if (std.sort.isSorted(u32, input, {}, std.sort.asc(u32)) or std.sort.isSorted(u32, input, {}, std.sort.desc(u32))) {
        for (input[1..], 0..) |right, left| {
            if (@abs(@as(i64, right) - @as(i64, input[left])) >= 4 or right == input[left]) {
                return 0;
            }
        }
        return 1;
    }
    return 0;
}
