const std = @import("std");
const spec_types = @import("spec-types");
const text_decode = @import("wasm-text-decode");

pub fn readWastFromFile(
    io: std.Io,
    allocator: std.mem.Allocator,
    file_path: []const u8,
) ![]spec_types.command.Command {
    const file_content = try std.Io.Dir.cwd().readFileAlloc(
        io,
        file_path,
        allocator,
        .unlimited,
    );
    defer allocator.free(file_content);

    return text_decode.parseWastScript(allocator, file_content);
}

pub fn freeCommands(commands: []spec_types.command.Command, allocator: std.mem.Allocator) void {
    for (commands) |*cmd| {
        text_decode.freeCommand(allocator, cmd);
    }
    allocator.free(commands);
}
