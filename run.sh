echo "---bison(yacc)---"
bison -d -o $1.tab.c $1.y
gcc -c -g -I.. $1.tab.c
echo "---flex(lex)---"
flex -o $1.yy.c $1.l
gcc -c -g -I.. $1.yy.c
echo "---gcc---"
gcc -o $1 $1.tab.o $1.yy.o -ll
echo "---complete---"

