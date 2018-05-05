%{
  //  -----------------------------------------------------------------	//
  //									//
  //		ourPython.lex						//
  //									//
  //	    This file defines a flex file that defines a C++ program	//
  //	that outputs the tokens encountered in a Python source file.	//
  //	For the parser's sake, it keeps track of indentation and	//
  //	outputs BEGIN_INDENT when there is more indentation and		//
  //	END_INDENT when there is less.					//
  //									//
  //	----	----	----	----	----	----	----	----	//
  //									//
  //	Version 1a		2018 April 13		Joseph Phillips	//
  //									//
  //  -----------------------------------------------------------------	//

  //  Compile and run with:
  //    $ flex -o ourPythonTokenizer.cpp ourPython.lex
  //    $ g++ ourPythonTokenizer.cpp -o ourPython
  //    $ ./ourPython computeBMI.py

#include	<cstdlib>
#include	<cstdio>
#include	<cstring>


//  PURPOSE:  To distinguish among the tokens that can be tokenized.
typedef		enum
		{
		  NO_LEX,
		  INTEGER_LEX,
		  FLOAT_LEX,
		  STRING_LEX,
		  IDENTIFIER_LEX,
		  BEGIN_INDENT_LEX,
		  END_INDENT_LEX,
		  BEGIN_PAREN_LEX,
		  END_PAREN_LEX,
		  COLON_LEX,
		  COMMA_LEX,
		  EQ_LEX,
		  LESSER_LEX,
		  LESSER_EQ_LEX,
		  GREATER_LEX,
		  GREATER_EQ_LEX,
		  EQ_EQ_LEX,
		  NOT_EQ_LEX,
		  PLUS_LEX,
		  MINUS_LEX,
		  STAR_LEX,
		  SLASH_LEX,
		  PERCENT_LEX,
		  SLASH_SLASH_LEX,
		  STAR_STAR_LEX,
		  PLUS_EQ_LEX,
		  MINUS_EQ_LEX,
		  STAR_EQ_LEX,
		  SLASH_EQ_LEX,
		  PERCENT_EQ_LEX,
		  SLASH_SLASH_EQ_LEX,
		  STAR_STAR_EQ_LEX,
		  IF_LEX,
		  ELIF_LEX,
		  ELSE_LEX,
		  WHILE_LEX,
		  FOR_LEX,
		  IN_LEX,
		  DEF_LEX
		}
		lex_ty;


//  PURPOSE:  To tell the size of typical buffers.
const int	BUFFER_LEN		= 4080;


//  PURPOSE:  To tell how many spaces are implied by a tab char.
const int	NUM_SPACES_PER_TAB	= 8;


//  PURPOSE:  To hold the indentation so far on the current line.
extern int	numSpacesSinceNewLine;


//  PURPOSE:  To hold the indentation of the line before the current line.
extern int	lastIndentCount;


//  PURPOSE:  To hold 'true' when should count spaces for indentation
//	comparison purposes, or 'false' otherwise.
extern bool	shouldCount;

#undef 		YY_INPUT

#define		YY_INPUT(buffer,numRetChars,bufferLen)	\
		{ numRetChars = getLexChar(buffer,bufferLen); }


//  PURPOSE:  To read the next char from 'yyin' and put it into 'buffer' of
//	length 'bufferLen'.  Returns '1' to signify that only one char was
//	obtained on success, or returns 'YY_NULL' on EOF error otherwise.
extern
int		getLexChar	(char*		buffer,
       				 int		bufferLen
				);

%}

%%
"#" {
  int x = yyinput();
  while (1) {
    if (x == '\n') break;
    x = yyinput();
  }
  numSpacesSinceNewLine = 0;
  shouldCount = true;
}
"\n" {
  numSpacesSinceNewLine = 0;
  shouldCount = true;
}
" " {
  if(shouldCount)
    numSpacesSinceNewLine++;
}
"\t" {
  if(shouldCount)
    numSpacesSinceNewLine += NUM_SPACES_PER_TAB;
}
"=" {
 return EQ_LEX;
}
"(" {
  return BEGIN_PAREN_LEX;
}
")" {
 return END_PAREN_LEX;
}
"def" {
  return DEF_LEX;
}
"if" {
  return IF_LEX;
}
"else" {
  return ELSE_LEX;
}
"elif" {
  return ELIF_LEX;
}
"while" {
  return WHILE_LEX;
}
"for" {
  return FOR_LEX;
}
"<" {
  return LESSER_LEX;
}
"<=" {
 return LESSER_EQ_LEX;
}
">" {
  return GREATER_LEX;
}
">=" {
  return GREATER_EQ_LEX;
}
"!=" {
  return(NOT_EQ_LEX);
}
"+" {
  return PLUS_LEX;
}
"-" {
  return MINUS_EQ_LEX;
}
"*" {
  return STAR_LEX;
}
"/" {
  return SLASH_LEX;
}
"," {
 return COMMA_LEX;
}
":" {
 return COLON_LEX;
}
[0-9]+ {
  return INTEGER_LEX;
}
("+"|-)?[0-9]+"."[0-9]* {
  return(FLOAT_LEX);
}
("+"|-)?[0-9]*"."[0-9]+ {
  return(FLOAT_LEX);
}
("+"|-)?[0-9]+ {
  return(INTEGER_LEX);
}
\"([^\\\"]|\\.)*\" {
  return(STRING_LEX);
}
[A-Za-z_][A-Za-z_0-9]* {
  return(IDENTIFIER_LEX);
}
. {
    printf("What is %c?\n",yytext[0]);
    return(0);
}
%%

//  PURPOSE:  To hold the names of the tokens given in 'lex_ty'.
const char*	lexTypeName[]	= { "not a legal lexeme",
				    "INTEGER",
				    "FLOAT",
				    "STRING",
				    "IDENTIFIER",
				    "BEGIN_INDENT",
				    "END_INDENT",
				    "BEGIN_PAREN",
				    "END_PAREN",
				    "COLON",
				    "COMMA",
				    "EQ",
				    "LESSER",
				    "LESSER_EQ",
				    "GREATER",
				    "GREATER_EQ",
				    "EQ_EQ",
				    "NOT_EQ",
				    "PLUS",
				    "MINUS",
				    "STAR",
				    "SLASH",
				    "PERCENT",
				    "SLASH_SLASH",
				    "STAR_STAR",
				    "PLUS_EQ",
				    "MINUS_EQ",
				    "STAR_EQ",
				    "SLASH_EQ",
				    "PERCENT_EQ",
				    "SLASH_SLASH_EQ",
				    "STAR_STAR_EQ",
				    "IF",
				    "ELIF",
				    "ELSE",
				    "WHILE",
				    "FOR",
				    "IN",
				    "DEF"
				  };


//  PURPOSE:  To hold the indentation so far on the current line.
int		numSpacesSinceNewLine
				= 0;


//  PURPOSE:  To hold the indentation of the line before the current line.
int		lastIndentCount	= 0;


//  PURPOSE:  To hold 'true' when should count spaces for indentation
//	comparison purposes, or 'false' otherwise.
bool		shouldCount	= true;


//  PURPOSE:  To read the next char from 'yyin' and put it into 'buffer' of
//	length 'bufferLen'.  Returns '1' to signify that only one char was
//	obtained on success, or returns 'YY_NULL' on EOF error otherwise.
int		getLexChar	(char*	buffer,
       				 int	bufferLen
				)
{
  //  PURPOSE:  To hold the chars of the most recently read line:
  static
  char		line[BUFFER_LEN];

  //  PURPOSE:  To hold the position of the next char to read in 'linePtr',
  //	or 'line + BUFFER_LEN' if should read a new line.
  static
  char*		linePtr	= line + BUFFER_LEN;


  //  I.  Application validity check:

  //  II.  Get next char:
  if  ( feof(yyin) )
  {
    //  II.A.  Note when at end-of-file:
    return(YY_NULL);
  }
  else
  {
    //  II.B.  Have not encountered EOF yet, attempt to get next char:
    //  II.B.1.  Read next line if at end of current one:
    if  ( (linePtr >= line + BUFFER_LEN)  ||  (*linePtr == '\0') )
    {
      //  II.B.1.a.  Attempt to read next line, note if find EOF instead:
      if  (fgets(line,BUFFER_LEN,yyin) == NULL)
      {
        return(YY_NULL);
      }

      //  II.B.1.b.  Prepare to read from beginning of new line:
      linePtr = line;
    }

    //  II.B.2.  Store next char in 'buffer':
    buffer[0]	= *linePtr++;
    buffer[1]	= '\0';
  }

  //  III.  Finished:
  return(1);
}


//  PURPOSE:  To serve as a wrapper to the next-token-returning, flex-generated
//	function 'yylex()'.  Keeps track of changes in indentation with global
//	vars 'shouldCount', 'lastIndentCount' and 'numSpacesSinceNewLine'.
//	No parameters.
int		yyylex		()
{
  //  PURPOSE:  To hold the token that was read, and that should be 'return'-ed
  //  	on the current call to this function if either 'BEGIN_INDENT_LEX' or
  //	'END_INDENT_LEX' was returned on the last call.
  static
  int	lastResult	= YY_NULL;


  //  I.  Application validity check:

  //  II.  Get integer value of token to return:
  //  II.B.  Get integer value of token to return:
  int		toReturn;

  if  (lastResult != YY_NULL)
  {
    //  II.A.  Return 'lastResult' if it holds a legitimate token:
    toReturn	= lastResult;
    lastResult	= YY_NULL;
  }
  else
  {
    //  II.B.  No previously stored token, should get next token:
    //  II.B.1.  Get next token:
    toReturn	= yylex();

    //  II.B.2.  That we just read a token means we know we are no longer
    //		 at the beginning of a line, therefore stop counting spaces
    //		 at beginning:
    shouldCount	= false;

    //  II.B.3.  Handle changes in indentation:
    if  (numSpacesSinceNewLine != lastIndentCount)
    {
      //  II.B.3.a.  Remember read token for next call:
      lastResult	= toReturn;

      //  II.B.3.b.  Determine if indented or un-indented:
      if  (numSpacesSinceNewLine > lastIndentCount)
        toReturn	= BEGIN_INDENT_LEX;
      else
        toReturn	= END_INDENT_LEX;

      //  II.B.3.c.  Remember this level of indentation for next time
      lastIndentCount	= numSpacesSinceNewLine;
    }

  }

  //  III.  Finished:
  return(toReturn);
}


//  PURPOSE:  To return '0' if tokenizing should continue after reaching feof()
//	on 'yyin', or '1' otherwise.  No parameters.
int		yywrap		()
{
  //  I.  Application validity check:

  //  II.  Return value:
  return(1);
}


//  PURPOSE:  To tokenize the python program given as the first argument in
//	'argv[1]'.  Returns 'EXIT_SUCCESS' on success or 'EXIT_FAILURE'
//	otherwise.
int		main		(int argc, char* argv[])
{
  //  I.  Application validity check:
  if  (argc < 2)
  {
    fprintf(stderr,"Usage:\toutPython <prog.py>\n");
    exit(EXIT_FAILURE);
  }

  //  II.  Attempt to tokenize file:
  //  II.A.  Attempt to open file:
  const char*	filePathCPtr	= argv[1];

  if  ((yyin = fopen(filePathCPtr,"r")) == NULL)
  {
    fprintf(stderr,"Cannot open %s\n",filePathCPtr);
    exit(EXIT_FAILURE);
  }

  //  II.B.  Attempt to tokenize 'filePathCPtr':
  int	result;

  //  II.B.1.  Each iteration gets and prints the next token:
  while  ( (result = yyylex()) != YY_NULL )
  {
    printf("%s",lexTypeName[result]);

    switch  (result)
    {
    case INTEGER_LEX :
      printf(":\t%ld",strtol(yytext,NULL,0));
      break;

    case FLOAT_LEX :
      printf(":\t\t%g",strtod(yytext,NULL));
      break;

    case STRING_LEX :
      printf(":\t\t%s",yytext);
      break;

    case IDENTIFIER_LEX :
      printf(":\t%s",yytext);
      break;

    default :
      break;
    }

    putchar('\n');
  }

  //  II.C.  Clean up:
  fclose(yyin);

  //  III.  Finished:
  return(EXIT_SUCCESS);
}