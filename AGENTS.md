# AGENTS

## Repository Snapshot (2025-02-19)
- Overlay name: `oululinux-win` (see `profiles/repo_name`).
- Targeted cross toolchains: `x86_64-w64-mingw32` and `i686-w64-mingw32`.
- Focus: build Windows executables from Gentoo using `crossdev` with pthreads and OpenGL-enabled dependencies.
- Core ebuilds: `app-arch/xz-utils` and `media-libs/libsdl2` tailored for mingw environments.

## Directory Reference
- `app-arch/xz-utils/` – Ships `xz-utils-5.8.1-r1.ebuild` mirroring Gentoo upstream with multilib/PGO tuning and mingw DLL sanity checks.
- `media-libs/libsdl2/` – Provides `libsdl2-2.32.8.ebuild` with cross-aware OpenGL handling and bundled patch.
- `media-libs/libsdl2/files/` – Contains `libsdl2-2.32.0-fix-tests-for-disabled-vulkan-and-gles.patch`, gating GLES/Vulkan tests on feature flags.
- `metadata/layout.conf` – Declares overlay metadata (`masters = gentoo`, thin manifests, EAPI policies, allowed PROPERTIES/RESTRICT values).
- `profiles/repo_name` – Registers the overlay as `oululinux-win` for Portage discovery.
- `README.md` – Sync instructions for consumers of the overlay.

## Crossdev Usage Notes
- Bootstrap MinGW cross toolchains with the default `crossdev --target x86_64-w64-mingw32` and `crossdev --target i686-w64-mingw32` commands before emerging overlay packages.
- pthreads support relies on the mingw-w64 runtime; ensure `USE=pthreads` is set where applicable.
- OpenGL support for mingw is provided through SDL; overlay relaxes Linux-only OpenGL deps when `CHOST` matches mingw.
- Keep `eselect repository` or `/etc/portage/repos.conf` pointing at this overlay to pick up custom ebuilds.

## Maintenance Checklist
- Run `pkgcheck scan` before pushing updates to maintain Manifest/EAPI compliance.
- Sync with upstream Gentoo ebuilds periodically and port new releases as needed.
- Verify patches still apply against upstream tarballs and regenerate `Manifest` on changes.
- Test cross-built binaries on Windows (or Wine) to confirm pthreads/OpenGL features load correctly.

## Open Items / Clarifications Needed
- Track missing dependencies discovered while building SDL2-based games; add new mingw-oriented ebuilds as required.
- Evaluate whether documenting non-default `crossdev` flags becomes necessary if workflows evolve beyond the defaults.
- Consider adopting one or more QA routines: `pkgcheck scan`, `repoman full -d`, scripted mingw builds of sample projects, Windows/Wine runtime smoke tests.
