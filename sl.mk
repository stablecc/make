CPPFLAGS += -fpic

include $(BASE)/make/shared.mk

.PHONY: debug
debug:
	@for lib in $(SLBUILDS); do \
	$(MAKE) -C $$lib --no-print-directory debug; \
	done
	@make --no-print-directory BLDTYPE=debug $(BINDIR)/lib$(NAME)d.so

.PHONY: release
release:
	@for lib in $(SLBUILDS); do \
	$(MAKE) -C $$lib --no-print-directory release; \
	done
	@make --no-print-directory BLDTYPE=release $(BINDIR)/lib$(NAME).so

.PHONY: clean
clean:
	rm -f $(BINDIR)/lib$(NAME).so
	rm -f $(BINDIR)/lib$(NAME)d.so
	rm -rf $(OBJDIR)
	rm -rf $(OBJDIR)_d

.PHONY: cleanlibs
cleanlibs: clean
	@for lib in $(SLBUILDS); do \
	$(MAKE) -C $$lib --no-print-directory cleanlibs; \
	done

include $(BASE)/make/rules.mk
