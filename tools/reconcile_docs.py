#!/usr/bin/env python3
"""Reconcile documentation coverage: every in-scope source file must have a doc.

Usage: python3 tools/reconcile_docs.py <repo_root> <docs_root>

Accepts both doc naming conventions per module:
  A) <Name><ext>.md   (e.g. Network/Players.cpp.md)
  B) <Name>.md        (e.g. Base/signal.md)
Excluded vendored subtrees are skipped in sources. INDEX/CERTIFICATION docs
are not counted as coverage. Exit 1 with a GAP report if anything is missing.
"""
import os
import sys

EXCLUDE_PARTS = ('/glew/', '/sgCore/', '/freetype/', '/raknet/', '/cat/',
                 '/Lua-5.1.4/', '/xulrunner', '/Qt')

# (source_dir_rel, doc_dir_rel, extensions_or_None_for_cpp_family)
MODULES = [
    ('App/v8datamodel',            'App/v8datamodel',       '.cpp'),
    ('App/include/script',         'App/include/script',    '.h'),
    ('App/include/gui',            'App/include/gui',       '.h'),
    ('App/include/humanoid',       'App/include/humanoid',  '.h'),
    ('App/humanoid',               'App/humanoid',          '.cpp'),
    ('App/include/reflection',     'App/include/reflection','.h'),
    ('App/include/lua',            'App/include/lua',       '.h'),
    ('App/include/v8xml',          'App/include/v8xml',     '.h'),
    ('App/include/solver',         'App/include/solver',    '.h'),
    ('App/include/tool',           'App/include/tool',      '.h'),
    ('App/include/util',           'App/include/util',      None),
    ('App/include/v8kernel',       'App/include/v8kernel',  '.h'),
    ('App/include/v8world',        'App/include/v8world',   None),
    ('App/include/v8datamodel',    'App/include/v8datamodel','.h'),
    ('Base',                       'Base',                  None),
    ('Network',                    'Network',               '.cpp'),
    ('RCCService',                 'RCCService',            None),
    ('WindowsClient',              'WindowsClient',         None),
    ('CSG',                        'CSG',                   None),
    ('Rendering/AppDraw',          'Rendering/AppDraw',     None),
    ('Rendering/GfxBase',          'Rendering/GfxBase',     None),
    ('Rendering/RbxG3D',           'Rendering/RbxG3D',      None),
]

WAIVE = {  # orchestrator-approved non-doc items, keyed by module-relative path
    'Base/include/FastLog.h': 'orchestrator-authored reconstruction header',
    'WindowsClient/resource.h': 'build plumbing (resource ids)',
}


def excluded(rel):
    return any(part in '/' + rel for part in EXCLUDE_PARTS)


def sources_for(root, mod, ext):
    src_mod = mod[0]
    out = {}
    base = os.path.join(root, mod[0])
    if not os.path.isdir(base):
        return out
    for r, _, fs in os.walk(base):
        rel_dir = os.path.relpath(r, base).replace('\\', '/')
        if rel_dir == '.':
            rel_dir = ''
        for f in fs:
            keep = f.endswith(ext) if ext else f.endswith(('.cpp', '.h', '.inl'))
            if not keep:
                continue
            rel = (rel_dir + '/' + f) if rel_dir else f
            if excluded(rel):
                continue
            stem = f.rsplit('.', 1)[0]
            out[src_mod + ":" + rel] = (stem, f)
    return out


def docs_for(root, mod_doc):
    out = set()
    droot = os.path.join(root, mod_doc)
    if not os.path.isdir(droot):
        return out
    for r, _, fs in os.walk(droot):
        for f in fs:
            if f.endswith('.md'):
                out.add(f[:-3])
    return out


def main():
    repo, droot = sys.argv[1], sys.argv[2]
    total_missing = 0
    report = []
    for mod in MODULES:
        src_mod, doc_mod, ext = mod
        srcs = sources_for(repo, (src_mod, doc_mod, ext), ext)
        docs = docs_for(droot, doc_mod)
        missing = []
        for key, (stem, fname) in sorted(srcs.items()):
            rel_only = key.split(':', 1)[1]
            waived = WAIVE.get(rel_only) or WAIVE.get(doc_mod + '/' + rel_only)
            if waived or stem in docs or fname in docs:
                continue
            missing.append(key)
        total_missing += len(missing)
        status = 'OK ' if not missing else 'GAP'
        print(f"{status} {doc_mod}: sources={len(srcs)} missing={len(missing)}")
        for m in missing[:8]:
            print(f"     - {m}")
        if len(missing) > 8:
            print(f"     ... +{len(missing)-8} more")
        report.append((doc_mod, len(srcs), missing))
    print()
    if total_missing:
        print(f"RECONCILE_FAILED: {total_missing} undocumented in-scope file(s)")
        return 1
    print("RECONCILE_OK: every in-scope source has a doc")
    return 0


if __name__ == '__main__':
    sys.exit(main())
