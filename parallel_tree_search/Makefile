# Top-level directory containing ableC repository and extensions folder
ABLEC_BASE?=../../ableC
EXTS_BASE?=../../extensions

# All directories containing grammars that may be included
GRAMMAR_DIRS=$(ABLEC_BASE)/grammars $(wildcard $(EXTS_BASE)/*/grammars) artifact

# All silver files in included grammars, to be included as dependancies
GRAMMAR_SOURCES=$(shell find $(GRAMMAR_DIRS) -name *.sv -print0 | xargs -0)

# Flags passed to silver including the appropriate directories
override SVFLAGS+=$(addprefix -I ,$(GRAMMAR_DIRS))

all: pts.out

ableC.jar: $(GRAMMAR_SOURCES)
	touch artifact/Artifact.sv
	silver-ableC -o $@ $(SVFLAGS) artifact


pts.c:	pts.xc ableC.jar
	java -Xss6M -jar ableC.jar pts.xc -I/usr/local/include/cilk

pts.out:	pts.c
	gcc -xc -I/usr/local/include/cilk -D__REENTRANT -O2 \
		pts.c -o pts.out \
		-L/usr/local/lib -L/usr/local/lib/cilk -lcilkrt0 -lcilk \
		-Wl,-rpath,/usr/local/lib -pthread -lm

clean:
	rm -f *~ *.i *.c *.o *.out *.test *.jar *.copperdump.html build.xml

.PHONY: all clean
