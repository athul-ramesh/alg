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
    var insertionSortArr = [_]u8{ 9, 8, 7, 6, 5, 4, 3, 2, 1 };
    insertionSort(&insertionSortArr);
    for (insertionSortArr) |item| {
        print("{} ", .{item});
    }
    // var mergeSortArr = [_]u8{ 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 };
    // mergeSort(&mergeSortArr, 0, 9);

    var remove_arr = [8]u8{ 0, 1, 2, 2, 3, 0, 4, 2 };
    removeDupInPlace(&remove_arr, 2);
    print("\nhere is the inline removed array\n", .{});
    for (remove_arr) |item| {
        print("{} ", .{item});
    }
    const str = "   fly me   to   the moon  ";
    const last_word_count = len_last_word(str);
    print("last word count {}\n", .{last_word_count});
    var arr_binary = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    const target_binary = 5;
    const index = binarySearch(&arr_binary, target_binary);
    print("\n binary search index is {}\n ", .{index});
    const s_ = "avv";
    const t = "vcc";
    const isoRes = try isIsomorphic(s_, t);
    print("{}\n", .{isoRes});
    const nums = [3]i32{ 2, 2, 1 };
    const answer = singleNumber(&nums);
    print("{}", .{answer});
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

fn insertionSort(arr: *[9]u8) void {
    const n = arr.len - 1;
    for (1..n) |i| {
        const key = arr[i];
        var j = i - 1;
        while (j >= 0 and arr[j] > key) {
            arr[j + 1] = arr[j];
            if (j == 0) {
                break;
            }
            j -= 1;
        }
        arr[j + 1] = key;
    }
}

fn merge(arr: *[10]u8, left: usize, mid: usize, right: usize) void {
    const lLen = mid - left + 1;
    const rLen = right - mid;
    const L = [lLen]u8{0} ** lLen;
    const R = [rLen]u8{0} ** rLen;
    for (0..lLen - 1) |i| {
        L[i] = arr[left + i];
    }
    for (0..rLen - 1) |i| {
        R[i] = arr[mid + 1 + i];
    }
    var i = 0;
    var j = 0;
    var k = left;
    while (i < lLen and j < rLen) : (k = k + 1) {
        if (L[i] < R[j]) {
            arr[k] = L[i];
            i += 1;
        } else {
            arr[k] = R[j];
            j += 1;
        }
    }
    while (i < lLen) : ({
        i += 1;
        k += 1;
    }) {
        arr[k] = L[i];
    }
    while (j < rLen) : ({
        j += 1;
        k += 1;
    }) {
        arr[k] = R[j];
    }
}

fn mergeSort(arr: *[10]u8, left: usize, right: usize) void {
    if (left < right) {
        const mid = @divFloor(left + right, 2);
        mergeSort(arr, left, mid);
        mergeSort(arr, mid + 1, right);
        merge(arr, left, mid, right);
    }
}

fn removeDupInPlace(arr: *[8]u8, val: u8) void {
    var i: usize = 0;
    var j: usize = arr.len - 1;
    while (i < j) {
        if (arr[i] == val and arr[j] != val) {
            arr[i] = arr[j];
            i += 1;
            j -= 1;
        } else if (arr[j] == val) {
            j -= 1;
        } else {
            i += 1;
        }
    }
    print("length of result array is {}\n", .{i + 1});
}

fn len_last_word(str: *const [27:0]u8) u16 {
    const len = str.len;
    var i = len - 1;
    var count: u16 = 0;
    while (i >= 0) : (i -= 1) {
        if (std.ascii.isAlphabetic(str[i])) {
            count += 1;
        } else {
            if (count > 0) {
                break;
            }
        }
    }
    return count;
}

fn binarySearch(arr: *[10]u8, target: u8) usize {
    var left: usize = 0;
    var right: usize = arr.len - 1;
    while (left <= right) {
        const mid: usize = @divFloor(left + right, 2);
        if (arr[mid] == target) {
            return mid;
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return 0;
}

fn isIsomorphic(s: *const [3:0]u8, t: *const [3:0]u8) !bool {
    if (s.len != t.len) {
        return false;
    }

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var mapST = std.AutoHashMap(u8, u8).init(allocator);
    var mapTS = std.AutoHashMap(u8, u8).init(allocator);
    defer {
        mapST.deinit();
        mapTS.deinit();
    }

    var i: usize = 0;
    while (i < s.len) : (i += 1) {
        const charS = s[i];
        const charT = t[i];

        if (mapST.contains(charT)) {
            const val = mapST.get(charT);
            if (val) |v| {
                if (v != charS) {
                    return false;
                }
            }
        } else {
            try mapST.put(charT, charS);
        }

        if (mapTS.contains(charS)) {
            const val = mapTS.get(charS);
            if (val) |v| {
                if (v != charT) {
                    return false;
                }
            }
        } else {
            try mapTS.put(charS, charT);
        }
    }

    return true;
}

fn singleNumber(nums: *const [3]i32) i32 {
    var ans: i32 = 0;
    for (nums) |num| {
        ans ^= num;
    }
    return ans;
}
