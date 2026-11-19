COL='\([^\t]*\)'
TAB='\t'

SED_CMD_EXTRACT='s/'$COL$TAB$COL$TAB$COL$TAB$COL$TAB$COL$TAB$COL'/"\1"; "\2"; /'

sed "$SED_CMD_EXTRACT" $1 | sed 's/; ""//' | sed -z 's/.*/\[ \0 \]/'


