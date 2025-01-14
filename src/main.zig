const std = @import("std");
const print = std.debug.print;
fn helper(arrList: *std.ArrayList(i64)) !void {
    const arr = [_]i64{ 1, 2, 3 };
    for (arr) |item| {
        try arrList.append(item);
    }
}
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var arr = std.ArrayList(i64).init(gpa.allocator());
    defer arr.deinit();

    try helper(&arr);
    const target: i64 = 3;
    try twoSum(&arr, target);
}

pub fn twoSum(arr: *std.ArrayList(i64), target: i64) !void {
    var hashTable = std.AutoHashMap(i64, u16).init(std.heap.page_allocator);
    defer hashTable.deinit();
    var answer: [2]u16 = undefined;
    for (arr.items, 0..) |item, i| {
        if (hashTable.contains(target - item)) {
            const anu = hashTable.get(target - item);
            if (anu) |val| {
                const res: [2]u16 = .{ val, @intCast(i) };
                answer = res;
            }
        } else {
            try hashTable.put(item, @intCast(i));
        }
    }
    print("{any}\n", .{answer});
}
