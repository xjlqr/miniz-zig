//! This just tests that the library links and installs
//! headers correctly when a zig module links against it

const std = @import("std");

const c = @cImport({
    @cInclude("miniz.h");
});

test "linktest" {
    const version_slice = std.mem.sliceTo(c.mz_version(), 0);
    try std.testing.expect(std.mem.eql(u8, version_slice, "11.0.2"));
}
