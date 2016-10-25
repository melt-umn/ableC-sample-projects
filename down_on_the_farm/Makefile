livestock.c:	livestock.xc livestock.h
	java -jar compiler/ableC.jar livestock.xc

accounting.c:	accounting.xc
	java -jar compiler/ableC.jar accounting.xc

a.out:	accounting.c
	gcc accounting.c

clean:
	rm -f *.c *.i a.out *~
