#!/usr/bin/env python3
"""Verify the prune manifest for roblox-sandbox.

Usage: python3 tools/verify_prune.py <path/to/roblox-sandbox>

Asserts every pruned path is gone and every required path (build graph,
trap set, runtime data) survives. Exits 1 listing violations.
"""
import re
import sys
from pathlib import Path

ABSENT = [
    # Top-level directories
    "Android", "BuiltInPlugins", "CoreScriptConverter2", "GameChat",
    "IncludeChecker", "Installer", "iOS", "Mac", "MacClient.xcodeproj",
    "Microsoft.Xbox.Samples.NetworkMesh", "PrepAllForUpload", "QTitanRibbon",
    "RCCService.PrepForUpload", "RCCService.Test", "RCCService.Thumb.Test",
    "RbxTestHooks", "Roblox.RccServiceArbiter", "Roblox.Test", "RobloxHybrid",
    "RobloxMac", "RobloxMobileTest", "RobloxModelAnalyzer", "RobloxStudio",
    "RobloxStudio.PrepForUpload", "ScriptSigner", "SettingsComparisonTool",
    "SimulationTestUtility", "StudioPlugins", "WindowsClient.PrepForUpload",
    "XboxClient", "App.UnitTest", "App.UnitTest.Lib", "App.UnitTest.Run",
    "Base.UnitTest", "Base.UnitTest.Lib", "Base.UnitTest.Run", "RobloxTest",
    "RobloxTest.MultiPlayerTest.Run", "RobloxTest.PhysicsPerfTest.Run",
    "RobloxTest.PhysicsTests.Run", "RobloxTest.Run", "RefreshPolicies", "Log",
    "cmake",
    # Root files
    "CMakeLists.txt", "buildshaders.bat", "buildshaders.sh",
    "Roblox.Test.vsmdi", "RobloxDebugVisualizers.txt",
    # Subdirectory prunes
    "Library/Qt", "Library/cabsdk", "Library/glsl-optimizer",
    "Library/hlsl2glslfork", "Library/xulrunner", "Rendering/ShaderCompiler",
    "PlatformContent/android", "PlatformContent/durango", "PlatformContent/ios",
    "boostlibs/boost.test.vcxproj", "boostlibs/boost.test.vcxproj.filters",
    "boostlibs/boostTest", "boostlibs/boost.xcodeproj", "boostlibs/CMakeLists.txt",
    "Rendering/CMakeLists.txt",
]

REQUIRED = [
    # Build-graph directories
    "App", "App.BulletPhysics", "Base", "Network", "CSG", "ClientBase",
    "ClientShared", "Win", "WindowsClient", "RCCService", "Rendering",
    "boostlibs",
    # Build plumbing
    "PropertySheets", "CustomBuildRules.props", "CustomBuildRules.rules",
    "CustomBuildRules.targets", "CustomBuildRules.xml", "Roblox.sln",
    # Runtime data
    "content", "shaders", "PlatformContent/pc",
    # Trap set
    "Win", "ClientBase", "ClientShared",
    "Rendering/OpenVR", "Rendering/LibOVR", "Rendering/VrApi",
    "Rendering/g3d", "Rendering/GfxCore", "Rendering/GfxRender",
    "Rendering/AppDraw", "Rendering/RbxG3D", "Rendering/GfxBase",
    "fmod/include",
    "Library/boost", "Library/curl", "Library/zlib", "Library/SDL2",
    "Library/SDK", "Library/Mesa", "Library/VMProtect", "Library/DSBaseClasses",
    "Library/cpp-netlib", "Library/w3c-libwww",
    # Misc roots
    "README.md", "LICENSE", ".gitattributes", ".gitignore",
]


def main():
    if len(sys.argv) != 2:
        print(__doc__)
        return 2
    root = Path(sys.argv[1])
    if not root.is_dir():
        print(f"FATAL: {root} is not a directory")
        return 1
    errors = []
    for rel in ABSENT:
        if (root / rel).exists():
            errors.append(f"STILL PRESENT (should be pruned): {rel}")
    seen_required = set()
    for rel in REQUIRED:
        key = rel.rstrip("/")
        if key in seen_required:
            continue
        seen_required.add(key)
        if not (root / key).exists():
            errors.append(f"MISSING (required): {key}")

    # Solution integrity: no project in Roblox.sln may root into a pruned
    # top-level directory. Catches orphan Project blocks whose directories
    # are already gone from disk.
    absent_roots = {rel.strip("/\\").lower() for rel in ABSENT if "." not in rel}
    sln = root / "Roblox.sln"
    if sln.exists():
        proj_re = re.compile(r'^Project\("[^"]+"\)\s*=\s*"[^"]*",\s*"([^"]+)"')
        for line in sln.read_text(encoding="utf-8-sig", errors="surrogateescape").splitlines():
            m = proj_re.match(line)
            if not m:
                continue
            first_seg = m.group(1).replace("/", "\\").split("\\")[0].strip().lower()
            if first_seg in absent_roots:
                errors.append(f"SLN ORPHAN: {m.group(1)}")
    if errors:
        print(f"VERIFY_FAILED: {len(errors)} violation(s)")
        for e in errors:
            print(f"  {e}")
        return 1
    print(f"VERIFY_OK: {len(ABSENT)} pruned paths absent, "
          f"{len(seen_required)} required paths present")
    return 0


if __name__ == "__main__":
    sys.exit(main())
