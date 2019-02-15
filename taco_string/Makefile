# Top-level directory containing ableC repository and extensions folder
ABLEC_BASE?=../../ableC
EXTS_BASE?=../../extensions

# All directories containing grammars that may be included
GRAMMAR_DIRS=$(ABLEC_BASE)/grammars $(wildcard $(EXTS_BASE)/*/grammars) artifact

# All silver files in included grammars, to be included as dependencies
GRAMMAR_SOURCES=$(shell find $(GRAMMAR_DIRS) -name *.sv -print0 | xargs -0)

# Flags passed to silver including the appropriate directories
override SVFLAGS+=$(addprefix -I ,$(GRAMMAR_DIRS))

# All directories contining extension header files that may be included
XC_INCLUDE_DIRS=$(wildcard $(EXTS_BASE)/*/include)
# All header files that may be included, to be included as dependencies
XC_INCLUDE_SOURCES=$(foreach dir,$(XC_INCLUDE_DIRS),$(wildcard $(dir)/*.*h))
# Flags passed to ableC including the appropriate directories
override XCFLAGS+=$(addprefix -I,$(XC_INCLUDE_DIRS))

all: lbnl-example.out

ableC.jar: $(GRAMMAR_SOURCES)
	touch artifact/Artifact.sv
	silver-ableC -o $@ $(SVFLAGS) artifact

lbnl-example.c: lbnl-example.xc ableC.jar $(XC_INCLUDE_SOURCES)
	java -Xss6M -jar ableC.jar lbnl-example.xc $(XCFLAGS)

lbnl-example.o: lbnl-example.c
	gcc -c -O3 -g -std=gnu11 lbnl-example.c -o lbnl-example.o

lbnl-example.out: lbnl-example.o
	gcc -v -pthread lbnl-example.o -lgc -o lbnl-example.out



clean:
	rm -f *~ *.i *.c *.o *.out *.test *.jar *.copperdump.html build.xml

.PHONY: all clean
