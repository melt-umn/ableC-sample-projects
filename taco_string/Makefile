# Top-level directory containing ableC repository and extensions folder
ABLEC_BASE?=../../ableC
EXTS_BASE?=../../extensions

# All directories containing grammars that may be included
GRAMMAR_DIRS=$(ABLEC_BASE)/grammars $(wildcard $(EXTS_BASE)/*/grammars) artifact

# All silver files in included grammars, to be included as dependencies
GRAMMAR_SOURCES=$(shell find $(GRAMMAR_DIRS) -name *.sv -print0 | xargs -0)

# Flags passed to silver including the appropriate directories
override SVFLAGS+=$(addprefix -I ,$(GRAMMAR_DIRS))

all: lbnl-example.out

ableC.jar: $(GRAMMAR_SOURCES)
	touch artifact/Artifact.sv
	silver-ableC -o $@ $(SVFLAGS) artifact

lbnl-example.c: lbnl-example.xc ableC.jar string.xh
	java -Xss6M -jar ableC.jar lbnl-example.xc

lbnl-example.o: lbnl-example.c
	gcc -c -O3 -g -std=gnu11 lbnl-example.c -o lbnl-example.o

lbnl-example.out: lbnl-example.o
	gcc -v -pthread lbnl-example.o -o lbnl-example.out
#	gcc -v -pthread -L/home/evw/PPoPP_Tutorial/gc-8.0.2/lib/ -lgc lbnl-example.o -o lbnl-example.out

#	gcc -v -pthread -l:/home/evw/PPoPP_Tutorial/gc-8.0.2/lib/libgc.so lbnl-example.o -o lbnl-example.out



clean:
	rm -f *~ *.i *.c *.o *.out *.test *.jar *.copperdump.html build.xml

.PHONY: all clean
