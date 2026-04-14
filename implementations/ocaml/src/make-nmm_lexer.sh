COL='\([^\t]*\)'
TAB='\t'

SED_CMD_EXTRACT='s/'$COL$TAB$COL$TAB$COL$TAB$COL$TAB$COL$TAB$COL'/ "\1" | "\2" |/'

MIDDLE="$(sed "$SED_CMD_EXTRACT" ../bin/tags.tsv | sed 's/| ""//')"

INTRO='let tag_shared = [%sedlex.regexp? '

OUTRO=']'

STRING_TO_INSERT="$INTRO $MIDDLE $OUTRO"

echo "$STRING_TO_INSERT" | sed 's/| \]/\]/' > nmm_lexer.ml

echo "" >> nmm_lexer.ml

cat nmm_lexer_template.ml >> nmm_lexer.ml


