# Global C++ practice Makefile. Neovim supplies SOURCE as the active buffer.

SOURCE ?= $(error SOURCE must point to the C++ file to compile)
INPUT ?= in

.DEFAULT_GOAL := all

CXX := g++-15
CXXFLAGS := -std=c++23 -O2 -g -Wall -Wextra -pedantic -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-unused-result -Wno-sign-conversion

ifeq ($(shell uname -s),Darwin)
# Homebrew GCC on macOS does not ship libasan.
DEBUG_CXXFLAGS := -fstack-protector-all -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC
else
DEBUG_CXXFLAGS := -fsanitize=address -fsanitize=undefined -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fno-sanitize-recover=all -fstack-protector-all
DEBUG_CXXFLAGS += -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC
endif
CXXFLAGS += $(DEBUG_CXXFLAGS)

PCH_ROOT := $(HOME)/.precompiled_headers
PCH_KEY := $(shell sha256sum $$(which $(CXX)) | cut -d ' ' -f1)-$(shell echo '$(CXXFLAGS)' | sha256sum | cut -d ' ' -f1)
PCH_DIR := $(PCH_ROOT)/$(PCH_KEY)
PCH_FILES := $(PCH_DIR)/bits/stdc++.h.gch
PCH_CXXFLAGS := -isystem $(PCH_DIR) -Winvalid-pch

$(PCH_DIR)/bits/stdc++.h:
	mkdir -p $(dir $@)
	printf '#pragma once\n#include_next <%s>\n' 'bits/stdc++.h' > $@

$(PCH_DIR)/bits/stdc++.h.gch: $(PCH_DIR)/bits/stdc++.h
	rm -f $@
	echo '#include <bits/stdc++.h>' > $@.h
	$(CXX) $(CXXFLAGS) $(PCH_CXXFLAGS) -x c++-header $@.h -o $@
	rm -f $@.h

# all is phony because SOURCE changes as Neovim switches between practice files.
all: $(PCH_FILES)
	rm -f sol
	$(CXX) $(CXXFLAGS) $(PCH_CXXFLAGS) "$(SOURCE)" -o sol
.PHONY: all

export TIME=\n  real\t%es\n  user\t%Us\n  sys\t%Ss\n  mem\t%MKB

run: all
	\time ./sol < "$(INPUT)"
.PHONY: run
