const std = @import("std");
const spec = @import("wasm-spec-test");

/// Main entry point for spec test runner
/// Supports both .wast/.wat text format and .json spec test format
pub fn main(init: std.process.Init) !void {
    var verbose: u8 = 1;
    var file_name: ?[]const u8 = null;

    var iterator = try init.minimal.args.iterateAllocator(init.arena.allocator());
    while (iterator.next()) |arg| {
        if (std.mem.eql(u8, arg, "-s")) {
            verbose = 0;
        } else if (std.mem.eql(u8, arg, "-v")) {
            verbose = 2;
        } else {
            file_name = arg;
        }
    }

    if (file_name) |file_path| {
        var runner = try spec.SpecTestRunneer.new(init.io, init.arena.allocator(), verbose);
        try runner.execFromFile(file_path);
    } else {
        std.debug.print("Usage: spec_test [-s|-v] <file.wast|file.json>\n", .{});
        std.debug.print("  -s: silent mode\n", .{});
        std.debug.print("  -v: verbose mode\n", .{});
        std.process.exit(1);
    }
}
