const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const GPA = std.heap.GeneralPurposeAllocator;

const MultiplyToken = struct {
    lexeme: []const u8,
    literal: []const u8,
};

const Scanner = struct {
    source: []const u8,
    tokens: std.ArrayList(MultiplyToken),
    start: usize = 0,
    current: usize = 0,

    fn init(source: []const u8, allocator: std.mem.Allocator) Scanner {
        return .{
            .source = source,
            .tokens = std.ArrayList(MultiplyToken).init(allocator),
        };
    }
    fn deinit(self: *Scanner) void {
        self.tokens.deinit();
    }

    fn scanMultiplyTokens(self: *Scanner) ![]const MultiplyToken {
        while (!self.isAtEnd()) {
            self.start = self.current;
            try self.scanMultiplyToken();
        }
        return self.tokens.items;
    }

    fn scanMultiplyToken(self: *Scanner) !void {
        const c = self.advance();
        switch (c) {
            'm' => self.findMultiplication(),
            else => return,
        }
    }
    fn isAtEnd(self: *Scanner) bool {
        return self.current >= self.source.len;
    }

    fn advance(self: *Scanner) u8 {
        defer self.current += 1;
        return self.source[self.current];
    }

    fn peek(self: *Scanner) u8 {
        if (self.isAtEnd()) return 0;
        return self.source[self.current];
    }

    fn findMultiplication(self: *Scanner) !void {
        _ = self;
    }
};

pub fn main() !void {
    var gpa = GPA(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const input = @embedFile("input.txt");
    var scanner = Scanner.init(input, allocator);
    defer scanner.deinit();
}
