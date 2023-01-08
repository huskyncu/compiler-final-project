%{
    #include <stdio.h>
	void yyerror(const char *message);
	int yylex();
	struct stack{
		char name;
		int ival;
	}; 
	struct stack stacks[10000];
	int indexs = 0;
    int check  = 0 ;
%}

%union{
	struct data{
		int ival;		
		char name;
	}data;
}

%token<data> number
%token<data> ID 
%token<data> bool_val 
%token<data> AND
%token<data> OR
%token<data> NOT 
%token<data> MOD
%token<data> print_num 
%token<data> print_bool  
%token<data> define
%token<data> IF


%type<data> PROGRAM
%type<data> STMT
%type<data> PRINT_STMT 
%type<data> EXP 
%type<data> NUM_OP 
%type<data> PLUS
%type<data> PLUS_EXP
%type<data> SUB
%type<data> MUL
%type<data> MUL_EXP
%type<data> DIV
%type<data> MOD_FORMULA 
%type<data> GREATER 
%type<data> SMALLER
%type<data> EQUAL
%type<data> EQUAL_EXP
%type<data> LOGICAL_OP
%type<data>  AND_OP
%type<data>  AND_EXP
%type<data>  OR_OP
%type<data>  OR_EXP
%type<data>  NOT_OP
%type<data>  IF_EXP 
%type<data>  TEST_EXP
%type<data>  THEN_EXP
%type<data>  ELSE_EXP
%type<data>  DEF_STMT
%type<data>  VARIABLE

%left AND
%left OR
%left NOT
%left MOD
%left '='
%left '<'
%left '>'
%left '+' 
%left '-'
%left '*' 
%left '/' 
%left '(' 
%left ')'

%%

PROGRAM : STMT STMTS
;
STMTS 	: STMT STMTS
		| STMT
;
STMT    : EXP
	      | DEF_STMT
		| PRINT_STMT
;
PRINT_STMT : '(' print_num EXP ')'  {   //printf("here2\n");  
                                        printf("%d\n", $3.ival);
                                    }
		      | '(' print_bool EXP ')' {                 
								                if($3.ival==1){
                                                    printf("#t\n");
                                                }else{
                                                    printf("#f\n");
                                                }
                                        }
			;  
EXP	    : '(' NUM_OP ')'  {     
                                $$.ival=$2.ival;   
                                // printf("here 5 %d\n",$$.ival);
                          }
		| '(' LOGICAL_OP ')' {
		                               $$.ival=$2.ival;
		                     }
		| '(' IF_EXP ')'   {    
		                               $$.ival=$2.ival;
		                           }
		|bool_val {
		                              $$.ival=$1.ival;
		        }
		| number   {
		                             $$.ival=$1.ival;
		            }
		| VARIABLE {
		                                 $$.ival=$1.ival;
		        }
		;
					
NUM_OP  : PLUS     {
                    $$.ival=$1.ival;  
                    //printf("here %d\n", $$.ival);
                    }
		| SUB    {
                    
                    $$.ival=$1.ival;
                    }
		| MUL { 
                    $$.ival=$1.ival;
                   }
		| DIV   { 
                        $$.ival=$1.ival;
                }
		| MOD_FORMULA  { 
                        $$.ival=$1.ival;
                   }
		| GREATER  {
                     $$.ival=$1.ival;
                    }
		| SMALLER  { 
                        $$.ival=$1.ival;
                    }
		| EQUAL    {
                        $$.ival=$1.ival;
                    }
                ;
PLUS    :  '+' EXP PLUS_EXP  { //printf("2\n");
                            $$.ival=$2.ival+$3.ival;
                            //printf("%d\n",$$.ival);
                           }
                ;
PLUS_EXP   : EXP PLUS_EXP {   
                    $$.ival=$1.ival+$2.ival;
                    }
		| EXP {
                    $$.ival=$1.ival;
                }
        ;
SUB   :  '-' EXP EXP  {
                if(check ==0)
                {
                    $$.ival=$2.ival-$3.ival;
                }
                else{
                    $$.ival=$3.ival-$2.ival;
                    check = 0 ;
                }
                
                }
        ;
MUL:  '*' EXP MUL_EXP  {
            $$.ival=$2.ival*$3.ival;
            }
        ;
MUL_EXP : EXP MUL_EXP {
            $$.ival=$1.ival*$2.ival;
            }
		| EXP {
            $$.ival=$1.ival;
            }
        ;
DIV  :  '/' EXP EXP  {
               if(check ==0)
                {
                    $$.ival=$2.ival/$3.ival;
                }
                else{
                    $$.ival=$3.ival/$2.ival;
                    check = 0 ;
                }
        }
        ;
MOD_FORMULA :  MOD EXP EXP  {
                if(check ==0)
                {
                    $$.ival=$2.ival%$3.ival;
                }
                else{
                    $$.ival=$3.ival%$2.ival;
                    check = 0 ;
                }
        }
        ;
GREATER :  '>' EXP EXP  {
                if(check ==0)
                {
                    if($2.ival>$3.ival)
                    {
                        $$.ival=1;
                    }
					else{
                        $$.ival=0;
                    }
                }
                else {
                    if($2.ival<$3.ival)
                    {
                        $$.ival=1;
                    }
					else{
                        $$.ival=0;
                    }
                    check = 0;
                }
                    
                }
        ;
SMALLER :  '<' EXP EXP  {
            if(check == 0 )
            {
                if($2.ival<$3.ival)
                {
                    $$.ival=1;
                }
			    else{
                    $$.ival=0;
                }
            }
            else {
                if($2.ival>$3.ival)
                {
                    $$.ival=1;
                }
			    else{
                    $$.ival=0;
                }
                check = 0;
            }

            
        }
        ;
EQUAL   :  '=' EXP EQUAL_EXP  {
            if($2.ival==$3.ival)
            {
                $$.ival=1;
            }
			else{
                $$.ival=0;
            }
            }
        ;
EQUAL_EXP  : EXP EQUAL_EXP {
            if($1.ival==$2.ival){
                $$.ival=$1.ival;
            }
			else{
                $$.ival=0;
            }
            }
		| EXP {
            $$.ival=$1.ival;
        }
        ;
LOGICAL_OP : AND_OP
           | OR_OP
		   | NOT_OP
           ;
AND_OP  :  AND EXP AND_EXP  {
            if($2.ival&$3.ival)
            {
                $$.ival=1;
            }
            else{
                $$.ival=0;
            }
            }
        ;
AND_EXP : EXP AND_EXP {
            if($1.ival&$2.ival)
            {
                $$.ival=1;
            }
            else{
                $$.ival=0;
            }
            }
        | EXP {
            if(!$1.ival){
                $$.ival=0;
            }else{
                $$.ival=1;
            }
        }
        ;
OR_OP   :  OR EXP OR_EXP   {
            if($2.ival|$3.ival){
                $$.ival=1;
            }
            else{
                $$.ival=0;
            }
            }
        ;
OR_EXP : EXP OR_EXP {
            if($1.ival|$2.ival)
            {
                $$.ival=1;
            }
            else{
                $$.ival=0;
            }
        }
	   | EXP {
            if(!$1.ival)
            {
                $$.ival=0;
            }
            else{
                $$.ival=1;
            }
        }
        ;
NOT_OP :  NOT EXP  {
            if($2.ival){
                $$.ival=0;
            }else{
                $$.ival=1;
            }
        }
        ;
IF_EXP :  IF TEST_EXP THEN_EXP ELSE_EXP  {
            if(!$2.ival){
                $$.ival=$4.ival;
            }
            else{
                $$.ival=$3.ival;
            }
        }
        ;
TEST_EXP : EXP {
            $$.ival=$1.ival;
        }
        ;   
THEN_EXP : EXP {
            $$.ival=$1.ival;
        }
        ;
ELSE_EXP : EXP {
            $$.ival=$1.ival;
        }
        ;
DEF_STMT    : '(' define ID EXP ')'	
            {
                stacks[indexs].name=$3.name; 
                stacks[indexs].ival=$4.ival;
                indexs++; 
                $$.ival=$4.ival;
            }
            ;
VARIABLE    : ID {
                $$.ival=stacks[indexs-1].ival;
                indexs--;
                check = 1;
            }
            ;
%%

void yyerror (const char *message)
{
	printf("%s\n",message);
}

int main(int argc, char** argv)
{
    yyparse();
    //printf("1\n");
    return 0;
}