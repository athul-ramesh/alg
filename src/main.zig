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
    const num: i64 = 1212;
    try isPalindrome(num);
    const strs = [3][]const u8{ "floi", "flower", "toi" };
    longestCommonPrefix(strs);
    const s = "()[]{}}";
    try isValidParantheses(s);
    var duplicateArray = [2]i16{ 1, 2 };
    const ans = removeDuplicates(&duplicateArray);
    print("length of unique elements is {}\n", .{ans});
}
fn longestCommonPrefix(strs: [3][]const u8) void {
    if (strs.len == 0) {
        print("invalid", .{});
        return;
    }
    if (strs.len == 1) {
        print("{}\n", .{strs[0]});
        return;
    }
    const prefix = strs[0];
    var poiter = prefix.len;
    for (strs) |item| {
        const local = item;
        const smaller = if (local.len < prefix.len) local.len else prefix.len;
        for (0..smaller) |i| {
            if (local[i] != prefix[i]) {
                poiter = i;
                break;
            }
        }
    }
    print("{s}\n", .{prefix[0..poiter]});
}
fn isPalindrome(original: i64) !void {
    if (original < 0) {
        print("false\n", .{});
    }
    var num = original;
    var reversed: i64 = 0;
    while (num > 0) : (num = @divFloor(num, 10)) {
        reversed = reversed * 10 + @rem(num, 10);
    }
    if (original == reversed) {
        print("true\n", .{});
    } else {
        print("false\n", .{});
    }
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

fn getClosingBracket(ref: *const [3]u8, c: u8) usize {
    for (ref, 0..ref.len) |item, i| {
        if (item == c) {
            return i;
        }
    }
    return 3;
}
fn isValidParantheses(s: []const u8) !void {
    if (s.len == 0 or s.len == 1) {
        print("false\n", .{});
        return;
    }
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var arr = std.ArrayList(i64).init(gpa.allocator());
    defer arr.deinit();

    const open = [_]u8{ '(', '{', '[' };
    const close = [_]u8{ ')', '}', ']' };
    for (s) |item| {
        const index = getClosingBracket(&open, item);
        if (index == 3) {
            const top = if (arr.items.len > 0) arr.pop() else '0';
            if (top != item) {
                print("false\n", .{});
                return;
            }
        } else {
            try arr.append(close[getClosingBracket(&open, item)]);
        }
    }
    if (arr.items.len == 0) {
        print("true\n", .{});
    } else {
        print("false\n", .{});
    }
}

fn removeDuplicates(arr: *[2]i16) usize {
    if (arr.len == 0) {
        return 0;
    }
    var i: usize = 0;
    for (1..arr.len) |j| {
        if (arr[j] != arr[i]) {
            i += 1;
            arr[i] = arr[j];
        }
    }
    return i + 1;
}
