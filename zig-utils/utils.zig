const std = @import("std");

pub fn heapSort(T: anytype, items: []T, lessThanFn: fn (void, T, T) bool) void {
    std.sort.heap(T, items, {}, lessThanFn);
}

pub fn LessThan(T: anytype) type {
    return struct {
        pub fn lessThanFn(_: void, a: T, b: T) bool {
            return a < b;
        }
    };
}
pub fn heapSortAsc(T: type, items: []T) void {
    return std.sort.heap(T, items, {}, LessThan(T).lessThanFn);
}
