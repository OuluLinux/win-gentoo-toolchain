# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="SDL2_mixer-${PV}"
inherit cmake-multilib

DESCRIPTION="Simple Direct Media Layer Mixer Library"
HOMEPAGE="https://github.com/libsdl-org/SDL_mixer"
SRC_URI="https://www.libsdl.org/projects/SDL_mixer/release/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~sparc x86"
IUSE="flac fluidsynth gme midi mod modplug mp3 opus playtools stb timidity tremor vorbis +wav wavpack xmp"
REQUIRED_USE="
\tmidi? ( || ( timidity fluidsynth ) )
\ttimidity? ( midi )
\tfluidsynth? ( midi )

\tvorbis? ( ?? ( stb tremor ) )
\tstb? ( vorbis )
\ttremor? ( vorbis )

\tmod? ( || ( modplug xmp ) )
\tmodplug? ( mod )
\txmp? ( mod )
"

RDEPEND="
\tmedia-libs/libsdl2[${MULTILIB_USEDEP}]
\tflac? ( media-libs/flac:=[${MULTILIB_USEDEP}] )
\tmidi? (
\t\tfluidsynth? ( media-sound/fluidsynth:=[${MULTILIB_USEDEP}] )
\t\ttimidity? ( media-sound/timidity++ )
\t)
\tmod? (
\t\tmodplug? ( media-libs/libmodplug[${MULTILIB_USEDEP}] )
\t\txmp? ( media-libs/libxmp[${MULTILIB_USEDEP}] )
\t)
\tmp3? ( media-sound/mpg123-base[${MULTILIB_USEDEP}] )
\topus? ( media-libs/opusfile[${MULTILIB_USEDEP}] )
\tplaytools? (
\t\t!media-libs/sdl-mixer[playtools]
\t\t!media-libs/sdl3-mixer[playtools]
\t)
\tvorbis? (
\t\tstb? ( dev-libs/stb )
\t\ttremor? ( media-libs/tremor[${MULTILIB_USEDEP}] )
\t\t!stb? ( !tremor? ( media-libs/libvorbis[${MULTILIB_USEDEP}] ) )
\t)
\tgme? ( media-libs/game-music-emu[${MULTILIB_USEDEP}] )
\twavpack? ( media-sound/wavpack[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
\tlocal enable_cmd=yes
\tif [[ ${CHOST} == *-mingw32 ]]; then
\t\t# SDL2's play commands rely on fork(), which mingw targets lack.
\t\tenable_cmd=no
\tfi

\tlocal mycmakeargs=(
\t\t-DSDL2MIXER_DEPS_SHARED=no # aka, no dlopen() (bug #950965)
\t\t-DSDL2MIXER_CMD=${enable_cmd}
\t\t-DSDL2MIXER_WAVE=$(usex wav)
\t\t-DSDL2MIXER_MOD=$(usex mod)
\t\t-DSDL2MIXER_MOD_MODPLUG=$(usex modplug)
\t\t-DSDL2MIXER_MOD_XMP=$(usex xmp)
\t\t-DSDL2MIXER_MIDI=$(usex midi)
\t\t-DSDL2MIXER_MIDI_TIMIDITY=$(usex timidity)
\t\t-DSDL2MIXER_MIDI_FLUIDSYNTH=$(usex fluidsynth)
\t\t-DSDL2MIXER_VORBIS=$(usex vorbis $(usex stb STB $(usex tremor TREMOR VORBISFILE) ) no )
\t\t-DSDL2MIXER_FLAC=$(usex flac)
\t\t-DSDL2MIXER_FLAC_LIBFLAC=$(usex flac)
\t\t-DSDL2MIXER_MP3=$(usex mp3)
\t\t-DSDL2MIXER_MP3_MPG123=$(usex mp3)
\t\t-DSDL2MIXER_OPUS=$(usex opus)
\t\t-DSDL2MIXER_GME=$(usex gme)
\t\t-DSDL2MIXER_WAVPACK=$(usex wavpack)
\t\t-DSDL2MIXER_SAMPLES=$(usex playtools)
\t\t-DSDL2MIXER_SAMPLES_INSTALL=$(usex playtools)
\t)
\tcmake_src_configure
}

multilib_src_install_all() {
\tdodoc {CHANGES,README}.txt
\trm -r "${ED}"/usr/share/licenses || die
}

pkg_postinst() {
\t# bug #412035
\tif use midi && use fluidsynth; then
\t\tewarn "FluidSynth support requires you to set the SDL_SOUNDFONTS"
\t\tewarn "environment variable to the location of a SoundFont file"
\t\tewarn "unless the game or application happens to do this for you."
\t\tif use timidity; then
\t\t\tewarn "Failing to do so will result in Timidity being used instead."
\t\telse
\t\t\tewarn "Failing to do so will result in silence."
\t\tfi
\tfi
}
