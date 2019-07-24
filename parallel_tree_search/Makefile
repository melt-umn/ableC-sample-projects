ABLEC_BASE?=../../ableC
EXTS_BASE?=../../extensions

# The scope of your NPM package. This should be the username of your NPM account
# or the orginzation you are a member of.
NPM_USERNAME=joeblanchard

# All directories containing grammars that may be included
GRAMMAR_DIRS=$(ABLEC_BASE)/grammars $(wildcard $(EXTS_BASE)/*/grammars) artifact

IDE_DIRS=$(ABLEC_BASE)/ide/slide $(wildcard $(EXTS_BASE)/*/ide/slide) ide

# All silver files in included grammars, to be included as dependancies
GRAMMAR_SOURCES=$(shell find $(GRAMMAR_DIRS) -name *.sv -print0 | xargs -0)

# Flags passed to silver including the appropriate directories
override SVFLAGS+=$(addprefix -I ,$(GRAMMAR_DIRS))
override SLIDEFLAGS+=$(addprefix -I , $(IDE_DIRS))


all: pts.out



atom-ide-demo:
	silver-ableC --treesitter-spec ablec4ptsdemo --treesitter-demo --ide-interface $(SVFLAGS) artifact
	sed s/_edu_umn_cs_melt_ableC_concretesyntax_BlockComment/edu_umn_cs_melt_ableC_concretesyntax_BlockComment/ grammar.js > grammar2.js; mv grammar2.js grammar.js
	sed s/_edu_umn_cs_melt_ableC_concretesyntax_LineComment/edu_umn_cs_melt_ableC_concretesyntax_LineComment/ grammar.js > grammar2.js ; mv grammar2.js grammar.js
	gen-treesitter-parser --scope $(NPM_USERNAME) --lang ablec4ptsdemo --publish
	slide -I ide/extensionOwnColorSpec ideInterface.txt ide/DemoSpecList.txt
	gen-atom-language-package ablec4ptsdemo $(NPM_USERNAME) 

update-spec-demo:
	silver-ableC --treesitter-demo --ide-interface $(SVFLAGS) artifact
	slide -I ide/extensionOwnColorSpec ideInterface.txt ide/DemoSpecList.txt
	gen-atom-language-package ablec4ptsdemo $(NPM_USERNAME) 

atom-ide:
	silver-ableC --treesitter-spec ablec4pts --ide-interface $(SVFLAGS) artifact
	sed s/_edu_umn_cs_melt_ableC_concretesyntax_BlockComment/edu_umn_cs_melt_ableC_concretesyntax_BlockComment/ grammar.js > grammar2.js; mv grammar2.js grammar.js
	sed s/_edu_umn_cs_melt_ableC_concretesyntax_LineComment/edu_umn_cs_melt_ableC_concretesyntax_LineComment/ grammar.js > grammar2.js ; mv grammar2.js grammar.js
	gen-treesitter-parser --scope $(NPM_USERNAME) --lang ablec4pts --publish 
	slide $(SLIDEFLAGS) ideInterface.txt ide/RealisticDemoSpecList.txt
	gen-atom-language-package ablec4pts $(NPM_USERNAME) 

update-spec:
	silver-ableC --ide-interface $(SVFLAGS) artifact
	slide $(SLIDEFLAGS) ideInterface.txt ide/RealisticDemoSpecList.txt
	gen-atom-language-package ablec4pts $(NPM_USERNAME) 
	

ableC.jar: $(GRAMMAR_SOURCES)
	touch artifact/Artifact.sv
	silver-ableC -o $@ $(SVFLAGS) artifact


pts.c:	pts.xc ableC.jar
	java -Xss6M -jar ableC.jar pts.xc -I/usr/local/include/cilk

pts.out:	pts.c
	gcc -xc -I/usr/local/include/cilk -D__REENTRANT -O2 \
		pts.c -o pts.out \
		-L/usr/local/lib -L/usr/local/lib/cilk \
		-Wl,-rpath,/usr/local/lib \
		-static -lcilkrt0 -lcilk -pthread -lm

#TODO: Statically link ONLY TO LIBCILKRT0 or update our version of libcilkrt0 to
# work with dynamic linking on modern systems. This is somewhat of an ugly hack.

clean:
	rm -f *~ *.i *.c *.o *.out *.test *.jar *.copperdump.html build.xml

.PHONY: all clean
