# rive_native fork

Unofficial fork of [`rive_native`](https://pub.dev/packages/rive_native). Not
affiliated with or endorsed by Rive. MIT licensed, Copyright (c) 2024 Rive; see
`LICENSE`.

- **Upstream:** https://pub.dev/packages/rive_native. Rive does not publish a
  source repo, so the pub.dev tarball is the upstream.
- **Vendored version:** 0.1.11 (the version resolved by `rive` 0.14.11).

## Why this fork exists

`FFIFlutterFactory._deleteRenderer` removes a `_canvasLookup` entry only if its
canvas has already been garbage collected. That is almost never true when the
callback runs, so one entry leaks per `Renderer.make` call, which means once
per frame per animating Rive widget. The fix is on branch
`fix/canvas-lookup-leak`; see its commit message for details.

`FFIFlutterFactory.decodeImage` waits on `ui.decodeImageFromList`, whose
callback only runs on success, so a failed decode (invalid bytes, or an
allocation refused under memory pressure) never completes. That also blocks
every later file decode, which awaits all pending images in
`_loadingImages`. The fix decodes through `ui.instantiateImageCodec` and
resolves a failure to `null`; see the `fix: resolve a failed Flutter image
decode` commit.

`version.txt` and `hash.txt` are untouched, so `bin/setup.dart` still downloads
and verifies Rive's official prebuilt native libraries. We host no binaries.

## Branches

- `main`: pristine commits only. Each one is a byte-identical copy of a pub.dev
  release, plus this file and `.gitignore`.
- `fix/canvas-lookup-leak`: the fixes, one commit each, on top of the pristine
  commit. Tags are cut from this branch.

## Rebasing onto a new upstream version

1. `flutter pub unpack rive_native:<version> --no-resolve`
2. On `main`, replace every tracked file except `FORK.md` and `.gitignore` with
   the unpacked tree, and commit it as a fresh pristine commit:
   `chore: vendor rive_native <version> verbatim from pub.dev`
3. Cherry-pick the fixes onto it, oldest first:
   `git checkout -B fix/canvas-lookup-leak main && git cherry-pick <fix shas>`
4. Tag the result (`v<version>-betclic.N`) and bump the ref in the monorepo.

Drop a fix once upstream ships it, and the fork once none is left.
