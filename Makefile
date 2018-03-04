-include disable_implicit_rules.mk

srcs := lib/Sexplib.pm

all:
	@echo Nothing to do. Please run 'check' for tests.

check:
	./test.sh

tidy:
	perltidy $(srcs)
	for p in lib/*.tdy ;\
	    do mv $$p $${p%.*}; done
