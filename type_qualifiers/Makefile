
# Path from current directory to top level ableC repository
ABLEC_BASE?=../../ableC
# Path from current directory to top level extensions directory
EXTS_BASE?=../../extensions

# All directories containing grammars that may be included
GRAMMAR_DIRS=$(ABLEC_BASE) $(wildcard $(EXTS_BASE)/*/grammars) artifact

# All silver files in included grammars, to be included as dependancies
GRAMMAR_SOURCES=$(shell find $(GRAMMAR_DIRS) -name *.sv -print0 | xargs -0)
# Flags passed to silver including the appropriate directories
override SVFLAGS+=$(addprefix -I ,$(GRAMMAR_DIRS))

all: example1.out

ableC.jar: $(GRAMMAR_SOURCES)
	touch artifact/Artifact.sv
	silver -o $@ $(SVFLAGS) artifact

example1.c:	example1.xc ableC.jar
	java -Xss6M -jar ableC.jar example1.xc -I $(EXTS_BASE)/ableC-string/include

example1.o:	example1.c
	gcc -std=gnu11 -c example1.c

example1.out:	example1.o
	gcc -lgc -o example1.out example1.o

clean:
	rm -f *~ *.i *.c *.o *.out *.test *.jar *.copperdump.html build.xml

.PHONY: all clean
