# the default target
.PHONY: default
default: debug

.PHONY: cleanall
cleanall:
	rm -rf $(BASE)/bin
	rm -rf $(BASE)/obj

CXXFLAGS += -std=c++14
LDFLAGS += -lstdc++ -pthread
CPPFLAGS += -I $(BASE)/scc/include

# all intermediate output goes to objdir
ifeq ($(BLDTYPE),debug)
CPPFLAGS += -Wall -O0 -g
OBJDIR = $(BASE)/obj/$(NAME)_d
else
CPPFLAGS += -O3
OBJDIR = $(BASE)/obj/$(NAME)
endif

# all apps and shared libs go to bindir
BINDIR = $(BASE)/bin

# if needed, create subdirs under the objdir directory for all source files
OBJS = $(addprefix $(OBJDIR)/, $(addsuffix .o, $(basename $(SRCS))))

# only build directories on a real build
ifdef BLDTYPE

# create a list of directories to build
# remove duplicates and put in order
DIRMK = $(sort $(dir $(abspath $(OBJS))))
XOBJDIR = $(abspath $(OBJDIR))/

#$(error dmk $(DIRMK) first $(word 1, $(DIRMK)) xobjdir $(XOBJDIR))

$(shell mkdir -p $(OBJDIR) &> /dev/null)
$(shell mkdir -p $(BINDIR) &> /dev/null)

# if the first (shortest) dir is below objdir, this is an error
ifeq ($(findstring $(XOBJDIR), $(word 1, $(DIRMK))),$(XOBJDIR))
$(shell mkdir -p $(DIRMK) &> /dev/null)
else
$(error Sources contain a directory outside of build tree)
endif

endif
