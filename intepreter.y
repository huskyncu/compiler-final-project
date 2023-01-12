%{
    #include <stdio.h>
	void yyerror(const char *message);
	int yylex();
	struct stack{
		int ival;
        char name;
        char type;
	}; 
	struct stack stacks[10000];
	int indexs = 0;
    int check  = 0 ;
%}

%union{
	struct data{
		int ival;		
		char name;
        char type;
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
                                $$.type=$2.type;  
                                // printf("here 5 %d\n",$$.ival);
                          }
		| '(' LOGICAL_OP ')' {
		                               $$.ival=$2.ival;
                                       $$.type=$2.type;  
		                     }
		| '(' IF_EXP ')'   {    
		                               $$.ival=$2.ival;
                                       $$.type=$2.type;  
		                           }
		|bool_val {
		                              $$.ival=$1.ival;
                                      $$.type=$1.type;  
		        }
		| number   {
		                             $$.ival=$1.ival;
                                     $$.type=$1.type;  
		            }
		| VARIABLE {
		                                 $$.ival=$1.ival;
                                         $$.type=$1.type;  
		        }
		;
					
NUM_OP  : PLUS     {
                    $$.ival=$1.ival;  
                    $$.type=$1.type;  
                    //printf("here %d\n", $$.ival);
                    }
		| SUB    {
                    
                    $$.ival=$1.ival;
                    $$.type=$1.type;  
                    }
		| MUL { 
                    $$.ival=$1.ival;
                    $$.type=$1.type;  
                   }
		| DIV   { 
                        $$.ival=$1.ival;
                        $$.type=$1.type;  
                }
		| MOD_FORMULA  { 
                        $$.ival=$1.ival;
                        $$.type=$1.type;  
                   }
		| GREATER  {
                     $$.ival=$1.ival;
                     $$.type=$1.type;  
                    }
		| SMALLER  { 
                        $$.ival=$1.ival;
                        $$.type=$1.type;  
                    }
		| EQUAL    {
                        $$.ival=$1.ival;
                        $$.type=$1.type;  
                    }
                ;
PLUS    :  '+' EXP PLUS_EXP  { //printf("2\n");
                            if($2.type!=$3.type){
                                yyerror("Type error!");
                                return 0;
                               }
                            $$.ival=$2.ival+$3.ival;
                            $$.type=$2.type;  
                            //printf("%d\n",$$.ival);
                            //printf("%c %c\n",$2.type,$3.type);
                           }
                ;
PLUS_EXP   : EXP PLUS_EXP { 
                    if($1.type!=$2.type){
                        //printf("%c %c\n",$1.type,$2.type);
                        yyerror("Type error!");
                        return 0;
                    }
                    //printf("%c %c\n",$1.type,$2.type);
                    $$.ival=$1.ival+$2.ival;
                    $$.type=$2.type;  
                    }
		| EXP {
                    $$.ival=$1.ival;
                    $$.type=$1.type;  
                }
        ;
SUB   :  '-' EXP EXP  {
                if($2.type!=$3.type){
                    //printf("sub %c %c\n",$2.type,$3.type);
                    yyerror("Type error!");
                    return 0;
                }
                if(check !=2)
                {
                    $$.ival=$2.ival-$3.ival;
                    $$.type=$2.type;  
                }
                else{
                    $$.ival=$3.ival-$2.ival;
                    $$.type=$2.type;  
                    check = 0 ;
                }
                
                }
        ;
MUL:  '*' EXP MUL_EXP  {
            if($2.type!=$3.type){
                    yyerror("Type error!");
                    return 0;
                }
            $$.ival=$2.ival*$3.ival;
            $$.type=$2.type;  
            }
        ;
MUL_EXP : EXP MUL_EXP {
            if($2.type!=$1.type){
            yyerror("Type error!");
            return 0;
            }
            $$.ival=$1.ival*$2.ival;
            $$.type=$2.type;  
            }
		| EXP {
            $$.ival=$1.ival;
            $$.type=$1.type;  
            }
        ;
DIV  :  '/' EXP EXP  {
                if($2.type!=$3.type){
                    //printf("here\n");
                    yyerror("Type error!");
                    return 0;
                }
               if(check !=2)
                {
                    $$.ival=$2.ival/$3.ival;
                    $$.type=$2.type;  
                }
                else{
                    $$.ival=$3.ival/$2.ival;
                    $$.type=$2.type;  
                    check = 0 ;
                }
        }
        ;
MOD_FORMULA :  MOD EXP EXP  {
                if($2.type!=$3.type){
                    yyerror("Type error!");
                    return 0;
                }
                if(check !=2)
                {
                    $$.ival=$2.ival%$3.ival;
                    $$.type=$2.type;  
                }
                else{
                    $$.ival=$3.ival%$2.ival;
                    $$.type=$2.type;  
                    check = 0 ;
                }
        }
        ;
GREATER :  '>' EXP EXP  {
                if($2.type!=$3.type){
                        yyerror("Type error!");
                        return 0;
                    }
                if(check !=2)
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
                $$.type=$2.type;  
                }
        ;
SMALLER :  '<' EXP EXP  {
            if($2.type!=$3.type)
            {
                yyerror("Type error!");
                return 0;
            }
            if(check != 2 )
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
            $$.type=$2.type;  
            
        }
        ;
EQUAL   :  '=' EXP EQUAL_EXP  {
            if($2.type!=$3.type)
            {
                yyerror("Type error!");
                return 0;
            }
            if($2.ival==$3.ival)
            {
                $$.ival=1;
            }
			else{
                $$.ival=0;
            }
            $$.type=$2.type;  
            }
        ;
EQUAL_EXP  : EXP EQUAL_EXP {
            if($2.type!=$1.type){
                yyerror("Type error!");
                return 0;
            }
            if($1.ival==$2.ival){
                $$.ival=$1.ival;
            }
			else{
                $$.ival=0;
            }
            $$.type=$2.type;  
            }
		| EXP {
            $$.ival=$1.ival;
            $$.type=$1.type;  
        }
        ;
LOGICAL_OP : AND_OP
           | OR_OP
		   | NOT_OP
           ;
AND_OP  :  AND EXP AND_EXP  {
            if($2.type!=$3.type){
                yyerror("Type error!");
                return 0;
            }
            if($2.ival&$3.ival)
            {
                $$.ival=1;
            }
            else{
                $$.ival=0;
            }
            $$.type=$2.type;  
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
            $$.type=$2.type;  
            }
        | EXP {
            if(!$1.ival){
                $$.ival=0;
            }else{
                $$.ival=1;
            }
            $$.type=$1.type;  
        }
        ;
OR_OP   :  OR EXP OR_EXP   {
            if($2.type!=$3.type)
            {
                yyerror("Type error!");
                return 0;
            }
            if($2.ival|$3.ival){
                $$.ival=1;
            }
            else{
                $$.ival=0;
            }
            $$.type=$2.type;  
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
            $$.type=$1.type;  
        }
	   | EXP {
            if(!$1.ival)
            {
                $$.ival=0;
            }
            else{
                $$.ival=1;
            }
            $$.type=$1.type;  
        }
        ;
NOT_OP :  NOT EXP  {
            if($2.type!='b')
            {
                yyerror("Type error!");
                return 0;
            }
            if($2.ival){
                $$.ival=0;
            }else{
                $$.ival=1;
            }
            $$.type=$2.type;  
        }
        ;
IF_EXP :  IF TEST_EXP THEN_EXP ELSE_EXP  {
            if(!$2.ival){
                $$.ival=$4.ival;
                
            }
            else{
                $$.ival=$3.ival; 
            }
            $$.type=$2.type;  
        }
        ;
TEST_EXP : EXP {
            $$.ival=$1.ival;
            $$.type=$1.type;  
        }
        ;   
THEN_EXP : EXP {
            $$.ival=$1.ival;
            $$.type=$1.type;  
        }
        ;
ELSE_EXP : EXP {
            $$.ival=$1.ival;
            $$.type=$1.type;  
        }
        ;
DEF_STMT    : '(' define ID EXP ')'	
            {
                stacks[indexs].name=$3.name; 
                stacks[indexs].ival=$4.ival;
                stacks[indexs].type = $4.type;
                indexs++; 
                $$.ival=$4.ival;
                $$.type=$4.type;
                // printf("define 3 %c\n",$3.name);
                // printf("define 3 %c\n",$3.type);
                // printf("define 4 name %c\n",$4.name);
                // printf("define 4 name %c\n",$4.type);
                // printf("define 4 name %d\n",$4.ival);
            }
            ;
VARIABLE    : ID {
                $$.ival=stacks[indexs-1].ival;
                $$.type=stacks[indexs-1].type;  
                indexs--;
                check +=1;
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