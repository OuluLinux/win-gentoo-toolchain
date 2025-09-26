# win-gentoo-toolchain

Gentoo crossdev overlay targeting `x86_64` and `i686` for building Windows executables with pthreads and OpenGL support.


## Installation

1. Create the overlay definition `/usr/x86_64-w64-mingw32/etc/portage/repos.conf/oululinux-win.conf` (or any file under `repos.conf`).
2. Add the following repository configuration:

```
[oululinux-win]
location = /var/db/repos/oululinux-win
sync-type = git
sync-uri = https://github.com/oululinux/win-gentoo-toolchain.git
```

3. Sync the new overlay:

```bash
emaint sync -r oululinux-win
```

4. Install a package, for example:

```bash
emerge --ask media-libs/libsdl2
```
