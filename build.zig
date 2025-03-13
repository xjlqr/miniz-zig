const std = @import("std");

pub fn build(b: *std.Build) !void {
    const test_link = b.option(
        bool,
        "test_link",
        "Test linking the library against a dummy application",
    ) orelse false;

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

    if (test_link) {
        const test_module = b.createModule(.{
            .root_source_file = b.path("src/test.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        });
        test_module.linkLibrary(library);

        const tests = b.addTest(.{
            .root_module = test_module,
        });
        const run_tests = b.addRunArtifact(tests);
        b.getInstallStep().dependOn(&run_tests.step);
    }
}
