OBJS     = utp_internal.o utp_utils.o utp_hash.o utp_callbacks.o utp_api.o utp_packedsockaddr.o
CFLAGS   = -Wall -DPOSIX -g -fno-exceptions $(OPT)
CXXFLAGS = $(CFLAGS) -fPIC -fno-rtti
CC       = gcc
CXX      = g++

CXXFLAGS += -Wno-sign-compare
CXXFLAGS += -fpermissive

# Uncomment to enable utp_get_stats(), and a few extra sanity checks
CFLAGS += -D_DEBUG

# Uncomment to enable debug logging
CFLAGS += -DUTP_DEBUG_LOGGING

# Dynamically determine if librt is available.  If so, assume we need to link
# against it for clock_gettime(2).  This is required for clean builds on OSX;
# see <https://github.com/bittorrent/libutp/issues/1> for more.  This should
# probably be ported to CMake at some point, but is suitable for now.
all: libutp.so

libutp.so: $(OBJS)
	$(CXX) $(CXXFLAGS) -o libutp.so -shared $(OBJS)

anyway: clean all
.PHONY: clean all anyway

clean:
	rm -f *.o *.so

install:
	install -D libutp.so $(DESTDIR)/libutp.so
