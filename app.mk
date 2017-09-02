include $(BASE)/make/shared.mk

.PHONY: debug
debug:
	@for lib in $(BLDLIBS); do \
	$(MAKE) -C $$lib --no-print-directory debug; \
	done
	@make --no-print-directory BLDTYPE=debug $(BINDIR)/$(NAME)_d
	@echo Run with cmd: LD_LIBRARY_PATH=$(BINDIR) $(BINDIR)/$(NAME)_d

.PHONY: release
release:
	@for lib in $(BLDLIBS); do \
	$(MAKE) -C $$lib --no-print-directory release; \
	done
	@make --no-print-directory BLDTYPE=release $(BINDIR)/$(NAME)
	@echo Run with cmd: LD_LIBRARY_PATH=$(BINDIR) $(BINDIR)/$(NAME)

.PHONY: clean
clean:
	rm -f $(BINDIR)/$(NAME)
	rm -f $(BINDIR)/$(NAME)_d
	rm -rf $(OBJDIR)
	rm -rf $(OBJDIR)_d

.PHONY: cleanlibs
cleanlibs: clean
	@for lib in $(BLDLIBS); do \
	$(MAKE) -C $$lib --no-print-directory cleanlibs; \
	done

include $(BASE)/make/rules.mk
