COL='\([^\t]*\)'
TAB='\t'

SED_CMD_SINGULAR='s/'$COL$TAB$COL$TAB$COL$TAB$COL$TAB$COL$TAB$COL'/| Cs_tag "\1" -> Some ("\4", "\3")\n/'

SED_CMD_PLURAL='s/'$COL$TAB$COL$TAB$COL$TAB$COL$TAB$COL$TAB$COL'/| Cs_tag "\2" -> Some ("\6", "\5")\n/'


sed "$SED_CMD_SINGULAR" $1 | grep -v 'Cs_tag ""' | grep -v '^$'

sed "$SED_CMD_PLURAL" $1 | grep -v 'Cs_tag ""' | grep -v '^$'


