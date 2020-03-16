/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buffer_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

unsigned int comment_depth = 0;
unsigned int string_buffer_left;
bool string_error;


char * after_backslash() {
  char *c = &yytext[1];
  if (*c == '\n') {
    curr_lineno++;
  }
  return c;
}

int append_string(char *str, unsigned int len) {
  if (len < string_buffer_left) {
    strncpy(string_buffer_ptr, str, len);
    string_buffer_ptr += len;
    string_buffer_left -= len;
    return 0;
  } else {
    string_error = true;
    yylval.error_msg = "String constant too long";
    return -1;
  }
}
%}

CLASS           [cC][lL][aA][sS][sS]
INHERITS        [iI][nN][hH][eE][rR][iI][tT][sS]
NEW             [nN][eE][wW]
OBJECTID        [a-z][_a-zA-Z0-9]*
TYPEID          [A-Z][_a-zA-Z0-9]*

DIGIT           [0-9]

NOT             [nN][oO][tT]
TRUE            t[rR][uU][eE]
FALSE           f[aA][lL][sS][eE]

IF              [iI][fF]
THEN            [tT][hH][eE][nN]
ELSE            [eE][lL][sS][eE]
FI              [fF][iI]

LET             [lL][eE][tT]
IN              [iI][nN]

WHILE           [wW][hH][iI][lL][eE]
LOOP            [lL][oO][oO][pP]
POOL            [pP][oO][oO][lL]

CASE            [cC][aA][sS][eE]
OF              [oO][fF]
ESAC            [eE][sS][aA][cC]

COMMENTBODY     [^\n*(\\]
STRINGBODY      [^\n\0\\\"]
WHITESPACE      [ \t\r\f\v]+
NEWLINE         [\n]

LE              <=
ASSIGN          <-
DARROW          =>
ISVOID          [iI][sS][vV][oO][iI][dD]

LINE_COMMENT    "--"
START_COMMENT   "(*"
END_COMMENT     "*)"

QUOTES          \"
BACKSLASH       [\\]

%x COMMENT STRING

%%

<INITIAL,COMMENT>{
    {NEWLINE}               { curr_lineno++; }
}

<INITIAL>{
    {START_COMMENT}         { comment_depth++; BEGIN(COMMENT); }
    {END_COMMENT}           { yylval.error_msg = "Unmatched *)"; return (ERROR); }
    {LINE_COMMENT}[^\n]*    ;

    {QUOTES}                { BEGIN(STRING); string_buffer_ptr = string_buf; string_buffer_left = MAX_STR_CONST; string_error = false; }
    {WHITESPACE}            ;

    {TRUE}                  { yylval.boolean = true; return (BOOL_CONST); }
    {FALSE}                 { yylval.boolean = false; return (BOOL_CONST); }
    {NOT}                   { return (NOT); }

    {CLASS}                 { return (CLASS); }
    {INHERITS}              { return (INHERITS); }
    {NEW}                   { return (NEW); }

    {IF}                    { return (IF); }
    {THEN}                  { return (THEN); }
    {ELSE}                  { return (ELSE); }
    {FI}                    { return (FI); }

    {LET}                   { return (LET); }
    {IN}                    { return (IN); }

    {WHILE}                 { return (WHILE); }
    {LOOP}                  { return (LOOP); }
    {POOL}                  { return (POOL); }

    {CASE}                  { return (CASE); }
    {OF}                    { return (OF); }
    {ESAC}                  { return (ESAC); }

    {ISVOID}                { return (ISVOID); }
    {DARROW}                { return (DARROW); }
    {ASSIGN}                { return (ASSIGN); }
    {LE}                    { return (LE); }

    {TYPEID}                { yylval.symbol = stringtable.add_string(yytext); return (TYPEID); }
    {OBJECTID}              { yylval.symbol = stringtable.add_string(yytext); return (OBJECTID); }
    {DIGIT}+                { yylval.symbol = stringtable.add_string(yytext); return (INT_CONST); }

    ";"                     { return int(';'); }
    ","                     { return int(','); }
    ":"                     { return int(':'); }
    "{"                     { return int('{'); }
    "}"                     { return int('}'); }
    "+"                     { return int('+'); }
    "-"                     { return int('-'); }
    "*"                     { return int('*'); }
    "/"                     { return int('/'); }
    "<"                     { return int('<'); }
    "="                     { return int('='); }
    "~"                     { return int('~'); }
    "."                     { return int('.'); }
    "@"                     { return int('@'); }
    "("                     { return int('('); }
    ")"                     { return int(')'); }
    .                       { yylval.error_msg = yytext; return (ERROR); }
}

<COMMENT>{
    <<EOF>>                 { yylval.error_msg = "EOF in comment"; BEGIN(INITIAL); return (ERROR); }
    [*]/[^)]                ;
    [(]/[^*]                ;
    {COMMENTBODY}*          ;
    {BACKSLASH}(.|{NEWLINE}) { after_backslash(); }
    {START_COMMENT}         { comment_depth++; }
    {END_COMMENT}           { comment_depth--; if (comment_depth == 0) { BEGIN(INITIAL); } }
}

<STRING>{
    <<EOF>>                 { yylval.error_msg = "EOF in string constant"; BEGIN(INITIAL); return ERROR; }
    {STRINGBODY}*           { int returnCode = append_string(yytext, yyleng); if (returnCode != 0) { return (ERROR); } }
    [\0]                    { yylval.error_msg = "String contains null character"; string_error = true; return (ERROR); }
    {NEWLINE}               { BEGIN(INITIAL); curr_lineno++; if (!string_error) { yylval.error_msg = "Unterminated string constant"; return (ERROR); } }
    {BACKSLASH}(.|{NEWLINE}) { char *c = after_backslash();
                              int returnCode;
                              switch (*c) {
                                case 'n':
                                  returnCode = append_string("\n", 1);
                                  break;
                                case 'b':
                                  returnCode = append_string("\b", 1);
                                  break;
                                case 't':
                                  returnCode = append_string("\t", 1);
                                  break;
                                case 'f':
                                  returnCode = append_string("\f", 1);
                                  break;
                                case '\0':
                                  yylval.error_msg = "String contains null character";
                                  string_error = true;
                                  returnCode = -1;
                                  break;
                                default:
                                  returnCode = append_string(c, 1);
                              }
                              if (returnCode != 0) {
                                return (ERROR);
                              }
                            }
    {QUOTES}                { BEGIN(INITIAL); if (!string_error) { yylval.symbol = stringtable.add_string(string_buf, string_buffer_ptr - string_buf); return (STR_CONST); } }
}

%%
