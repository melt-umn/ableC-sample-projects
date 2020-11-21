
# Path from current directory to top level ableC repository
ABLEC_BASE?=../../ableC
# Path from current directory to top level extensions directory
EXTS_BASE?=../../extensions

# All directories containing grammars that may be included
GRAMMAR_DIRS=$(ABLEC_BASE)/grammars $(wildcard $(EXTS_BASE)/*/grammars) artifact

# All silver files in included grammars, to be included as dependancies
GRAMMAR_SOURCES=$(shell find $(GRAMMAR_DIRS) -name *.sv -print0 | xargs -0)
# Flags passed to silver including the appropriate directories
override SVFLAGS+=$(addprefix -I ,$(GRAMMAR_DIRS))

all: tq.test

ableC.jar: $(GRAMMAR_SOURCES)
	touch artifact/Artifact.sv
	silver-ableC -o $@ $(SVFLAGS) artifact

tq.c:	tq.xc ableC.jar
	java -Xss6M -jar ableC.jar tq.xc -I $(EXTS_BASE)/ableC-string/include

tq.o:	tq.c
	gcc -std=gnu11 -c tq.c

tq.out:	tq.o
	gcc -o tq.out tq.o -lgc

tq.test: tq.out
	./tq.out
	touch tq.test

clean:
	rm -f *~ *.i *.c *.o *.out *.test *.jar *.copperdump.html build.xml

.PHONY: all clean
