CPPFLAGS += -fpic

include $(BASE)/make/shared.mk

.PHONY: debug
debug:
	@make --no-print-directory BLDTYPE=debug $(BINDIR)/lib$(NAME)d.so

.PHONY: release
release:
	@make --no-print-directory BLDTYPE=release $(BINDIR)/lib$(NAME).so

.PHONY: clean
clean:
	rm -f $(BINDIR)/lib$(NAME).so
	rm -f $(BINDIR)/lib$(NAME)d.so
	rm -rf $(OBJDIR)
	rm -rf $(OBJDIR)_d

include $(BASE)/make/rules.mk
