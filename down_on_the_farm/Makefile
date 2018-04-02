
# Path from current directory to top level ableC repository
ABLEC_BASE?=../../ableC
# Path from current directory to top level extensions directory
EXTS_BASE?=../../extensions

# The jar file to built
ABLEC_JAR=ableC.jar
# The artifact specification grammar to compile
ARTIFACT=artifact
# All directories containing grammars that may be included
GRAMMAR_DIRS=$(ABLEC_BASE)/grammars $(wildcard $(EXTS_BASE)/*/grammars) $(ARTIFACT)
# All silver files in included grammars, to be included as dependancies
GRAMMAR_SOURCES=$(shell find $(GRAMMAR_DIRS) -name *.sv -print0 | xargs -0)
# Flags passed to silver including the appropriate directories
override SVFLAGS+=$(addprefix -I ,$(GRAMMAR_DIRS))

$(ABLEC_JAR): $(GRAMMAR_SOURCES)
	touch $(wildcard $(ARTIFACT)/*.sv)
	silver -o $@ $(SVFLAGS) $(ARTIFACT)



all: accounting.out populate_table.out

livestock.c:	livestock.xc livestock.h ableC.jar
	java -Xss6M -jar ableC.jar livestock.xc

livestock.o:	livestock.c
	gcc -c livestock.c

populate_table.c:	populate_table.xc ableC.jar
	java -Xss6M -jar ableC.jar populate_table.xc -I ../../extensions/ableC-sqlite/include

populate_table.o:	populate_table.c
	gcc -c populate_table.c

serialize.c:	serialize.xc serialize.h ableC.jar
	java -Xss6M -jar ableC.jar serialize.xc

serialize.o:	serialize.c
	gcc -c serialize.c

populate_table.out:	populate_table.o serialize.o livestock.o
	gcc -o populate_table.out populate_table.o serialize.o livestock.o  -lpthread -ldl -lsqlite3

accounting.c:	accounting.xc ableC.jar
	java -Xss6M -jar ableC.jar accounting.xc -I ../../extensions/ableC-sqlite/include

accounting.o:	accounting.c
	gcc -c accounting.c

accounting.out:	accounting.o serialize.o livestock.o 
	gcc -o accounting.out accounting.o serialize.o livestock.o -lsqlite3 -lpthread -ldl


clean:
	rm -f *.c *.i *.o accounting.out populate_table.out ableC.jar build.xml farm.db
