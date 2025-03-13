const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("upstream", .{});
    const module = b.createModule(.{
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    module.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = &.{"./miniz.c"},
    });
    module.addIncludePath(upstream.path(""));

    const library = b.addLibrary(.{
        .name = "miniz",
        .root_module = module,
    });
    library.installHeadersDirectory(
        upstream.path(""),
        "",
        .{},
    );
    b.installArtifact(library);
}
