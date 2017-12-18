SRCFILES = src/gui.c src/audio.c src/oscillators.c src/synth.c src/main.c

FILE_NAME=fuck

# ===== Tool executables =====

# Native builds.
CC := gcc
SDL2_CONFIG ?= sdl2-config

# Cross-compiled Windows builds.
WINDOWS_CC  ?= x86_64-w64-mingw32-gcc
WINDOWS_SDL2_CONFIG ?= x86_64-w64-mingw32-sdl2-config

# ====================================================


LINUX_EXE=${FILE_NAME}
WINDOWS_EXE=${FILE_NAME}.exe

# ===== Flags =====

LINUX_SDL2_CFLAGS  := $(shell ${SDL2_CONFIG} --cflags)
LINUX_SDL2_LDFLAGS := $(shell ${SDL2_CONFIG} --static-libs)

WINDOWS_SDL2_CFLAGS := $(shell ${WINDOWS_SDL2_CONFIG} --cflags)
WINDOWS_SDL2_LDFLAGS := $(shell ${WINDOWS_SDL2_CONFIG} --static-libs)

# Copypasta from Faulty.
override COMPILER_FLAGS += -std=c11 -Wall -g -Wextra -Wunused -Wformat=2 -Winit-self -Wmissing-include-dirs -Wstrict-overflow=4 -Wfloat-equal -Wwrite-strings -Wconversion -Wundef -Wtrigraphs -Wunused-parameter -Wunknown-pragmas -Wcast-align -Wswitch-enum -Waggregate-return -Wmissing-noreturn -Wmissing-format-attribute -Wpacked -Wredundant-decls -Wunreachable-code -Winline -Winvalid-pch -Wdisabled-optimization -Wbad-function-cast -Wunused-function -Werror=implicit-function-declaration -gdwarf-2 -pedantic-errors -O0

override LINKER_FLAGS += ${SDL2_LDFLAGS}

LINUX_COMPILER_FLAGS := ${COMPILER_FLAGS} ${LINUX_SDL2_CFLAGS}
LINUX_LINKER_FLAGS   := ${LINKER_FLAGS} ${LINUX_SDL2_LDFLAGS}

WINDOWS_COMPILER_FLAGS := ${COMPILER_FLAGS} ${WINDOWS_SDL2_CFLAGS}
WINDOWS_LINKER_FLAGS   := ${LINKER_FLAGS} ${WINDOWS_SDL2_LDFLAGS}

# ===== Targets =====

all: linux windows

linux ${LINUX_EXE}:
	${CC} ${COMPILER_FLAGS} ${LINKER_FLAGS} ${SRCFILES} -o ${LINUX_EXE} ${LINUX_SDL2_CFLAGS} ${LINUX_SDL2_LDFLAGS}

windows ${WINDOWS_EXE}:
	${WINDOWS_CC} ${COMPILER_FLAGS} ${LINKER_FLAGS} ${SRCFILES} -o ${WINDOWS_EXE} ${WINDOWS_SDL2_CFLAGS} ${WINDOWS_SDL2_LDFLAGS} --static

clean:
	@find . -name '*.o' -delete
	@rm -f ${FILE_NAME} ${FILE_NAME}.exe

.PHONY: all linux windows clean
