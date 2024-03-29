
# Path from current directory to top level ableC repository
ABLEC_BASE?=../../ableC
# Path from current directory to top level extensions directory
EXTS_BASE?=../../extensions

# The jar file to build
ABLEC_JAR=ableC.jar
# The artifact specification grammar to compile
ARTIFACT=artifact
# All directories containing grammars that may be included
GRAMMAR_DIRS=$(ABLEC_BASE)/grammars $(wildcard $(EXTS_BASE)/*/grammars) $(ARTIFACT)
# All silver files in included grammars, to be included as dependancies
GRAMMAR_SOURCES=$(shell find $(GRAMMAR_DIRS) -name *.sv -print0 | xargs -0)
# Flags passed to silver including the appropriate directories
override SVFLAGS+=$(addprefix -I , $(GRAMMAR_DIRS))

all: accounting.out populate_table.out

$(ABLEC_JAR): $(GRAMMAR_SOURCES)
	touch $(wildcard $(ARTIFACT)/*.sv)
	silver-ableC -o $@ $(SVFLAGS) $(ARTIFACT)

populate_table.c:	populate_table.xc ableC.jar
	java -Xss6M -jar ableC.jar populate_table.xc -I $(EXTS_BASE)/ableC-sqlite/include

populate_table.o:	populate_table.c
	gcc -c populate_table.c

serialize.c:	serialize.xc serialize.h ableC.jar
	java -Xss6M -jar ableC.jar serialize.xc

serialize.o:	serialize.c
	gcc -c serialize.c

populate_table.out:	populate_table.o serialize.o sqlite3.o
	gcc -o populate_table.out populate_table.o serialize.o  sqlite3.o -lpthread -ldl

accounting.c:	accounting.xc ableC.jar
	java -Xss6M -jar ableC.jar accounting.xc -I $(EXTS_BASE)/ableC-sqlite/include

accounting.o:	accounting.c
	gcc -c accounting.c

accounting.out:	accounting.o serialize.o sqlite3.o
	gcc -o accounting.out accounting.o serialize.o sqlite3.o -lpthread -ldl

sqlite3.o: $(EXTS_BASE)/ableC-sqlite/src/sqlite3.c
	gcc -c $(EXTS_BASE)/ableC-sqlite/src/sqlite3.c -I$(EXTS_BASE)/ableC-sqlite/include

clean:
	rm -f *.c *.i *.o accounting.out populate_table.out ableC.jar build.xml farm.db
