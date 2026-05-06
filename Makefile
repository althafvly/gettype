CXX      ?= g++
AR       ?= ar
STRIP    ?= strip

CXXFLAGS := -O2 -std=c++17
LDFLAGS  :=

# Prefer musl for fully static portable binaries if a proper musl C++ compiler is found
MUSL_CXX := $(shell uname -m)-linux-musl-g++
ifneq ($(shell command -v $(MUSL_CXX) 2>/dev/null),)
CXX      := $(MUSL_CXX)
CXXFLAGS += -static
LDFLAGS  += -static
endif

.PHONY: all clean

all: gettype

gettype: gettype.cpp libfmt.a
	@echo "    GEN   $@"
	@$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@chmod +x $@
	@echo "    STRIP $@"
	@$(STRIP) $@

libfmt.a: format.o getfmt.o
	@echo "    AR    $@"
	@$(AR) rcs $@ $^

format.o: format.cpp
	@echo "    CPP   $@"
	@$(CXX) $(CXXFLAGS) -c $< -o $@

getfmt.o: getfmt.cpp
	@echo "    CPP   $@"
	@$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	@echo "    CLEAN"
	@rm -f *.o *.a gettype
