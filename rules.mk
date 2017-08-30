# rules to build object files
DEPFLAGS = -MT $@ -MMD -MP -MF $(OBJDIR)/$*.Td

COMPILE.c = $(CC) $(DEPFLAGS) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
COMPILE.cc = $(CXX) $(DEPFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
POSTCOMPILE = @mv -f $(OBJDIR)/$*.Td $(OBJDIR)/$*.d && touch $@

# if we don't mark these objects as secondary, they get removed as intermediate by the make system
.SECONDARY: $(OBJS)

$(OBJDIR)/%.o : %.c
$(OBJDIR)/%.o : %.c $(OBJDIR)/%.d
	$(COMPILE.c) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)

$(OBJDIR)/%.o : %.cc
$(OBJDIR)/%.o : %.cc $(OBJDIR)/%.d
	$(COMPILE.cc) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)

$(OBJDIR)/%.o : %.cxx
$(OBJDIR)/%.o : %.cxx $(OBJDIR)/%.d
	$(COMPILE.cc) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)

$(OBJDIR)/%.o : %.cpp
$(OBJDIR)/%.o : %.cpp $(OBJDIR)/%.d
	echo $(OUTPUT_OPTION)
	$(COMPILE.cc) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)

$(BINDIR)/%.so: $(OBJS)
	# shared libs do not need library includes
	#$(CC) -shared -Wl,-soname,$(notdir $@) $(LDFLAGS) -o $@ $(OBJS)
	$(CC) -shared -Wl,-soname,$(notdir $@) -o $@ $(OBJS)
	@echo Built shared library $@

$(BINDIR)/%: $(OBJS)
	$(CC) $(LDFLAGS) -L $(BINDIR) -o $@ $(OBJS)
	@echo Built application $@

$(OBJDIR)/%.d: ;
.PRECIOUS: $(OBJDIR)/%.d

include $(wildcard $(patsubst %,$(OBJDIR)/%.d,$(basename $(SRCS))))
