# Top-level directory containing ableC repository and extensions folder
ABLEC_BASE?=../../ableC
EXTS_BASE?=../../extensions

# All directories containing grammars that may be included
GRAMMAR_DIRS=$(ABLEC_BASE)/grammars $(wildcard $(EXTS_BASE)/*/grammars) artifact

# All silver files in included grammars, to be included as dependancies
GRAMMAR_SOURCES=$(shell find $(GRAMMAR_DIRS) -name *.sv -print0 | xargs -0)

# Flags passed to silver including the appropriate directories
override SVFLAGS+=$(addprefix -I ,$(GRAMMAR_DIRS))

all: fold.out graph.out

ableC.jar: $(GRAMMAR_SOURCES)
	touch artifact/Artifact.sv
	silver-ableC -o $@ $(SVFLAGS) artifact

fold.c: fold.xc ableC.jar
	java -Xss6M -jar ableC.jar fold.xc

fold.out: fold.c
	gcc -xc -O2 -g -std=gnu11 -pthread fold.c -o fold.out

graph.c: graph.xc ableC.jar
	java -Xss6M -jar ableC.jar graph.xc

graph.out: graph.c
	gcc -xc -O2 -g -std=gnu11 -pthread graph.c -o graph.out

clean:
	rm -f *~ *.i *.c *.o *.out *.test *.jar *.copperdump.html build.xml

.PHONY: all clean
