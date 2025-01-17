#!/bin/bash
set -euo pipefail

#nb: must be bash to support shopt globstar
shopt -s globstar

st=0

if grep -El '^\".+\" = \(.+\)' _maps/**/*.dmm;	then
    echo "ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!"
    st=1
fi;
if grep -P '^\ttag = \"icon' _maps/**/*.dmm;	then
    echo "ERROR: tag vars from icon state generation detected in maps, please remove them."
    st=1
fi;
if grep -P 'step_[xy]' _maps/**/*.dmm;	then
    echo "ERROR: step_x/step_y variables detected in maps, please remove them."
    st=1
fi;
if grep -P '\td[1-2] =' _maps/**/*.dmm;	then
    echo "ERROR: d1/d2 cable variables detected in maps, please remove them."
    st=1
fi;
if grep -P '^/area/.+[\{]' _maps/**/*.dmm;	then
    echo "ERROR: Vareditted /area path use detected in maps, please replace with proper paths."
    st=1
fi;
if grep -P '\W\/turf\s*[,\){]' _maps/**/*.dmm; then
    echo "ERROR: base /turf path use detected in maps, please replace with proper paths."
    st=1
fi;
if grep -P '^/*var/' code/**/*.dm; then
    echo "ERROR: Unmanaged global var use detected in code, please use the helpers."
    st=1
fi;
nl='
'
nl=$'\n'
while read f; do
    t=$(tail -c2 "$f"; printf x); r1="${nl}$"; r2="${nl}${r1}"
    if [[ ! ${t%x} =~ $r1 ]]; then
        echo "file $f is missing a trailing newline"
        st=1
    fi;
done < <(find . -type f -name '*.dm')
if grep -i 'centcomm' code/**/*.dm; then
    echo "ERROR: Misspelling(s) of CENTCOM detected in code, please remove the extra M(s)."
    st=1
fi;
if grep -i 'centcomm' _maps/**/*.dmm; then
    echo "ERROR: Misspelling(s) of CENTCOM detected in maps, please remove the extra M(s)."
    st=1
fi;
#WS begin - SolGov
if grep 'Solgov' code/**/*.dm; then
    echo "ERROR: Misspelling(s) of SolGov detected in code, please check capitalization."
    st=1
fi;
if grep 'Solgov' _maps/**/*.dmm; then
    echo "ERROR: Misspelling(s) of SolGov detected in maps, please check capitalization."
    st=1
fi;
#WS end
if ls _maps/*.json | grep -P "[A-Z]"; then
    echo "Uppercase in a map json detected, these must be all lowercase."
	st=1
fi;
if grep -i '/obj/effect/mapping_helpers/custom_icon' _maps/**/*.dmm; then
    echo "Custom icon helper found. Please include dmis as standard assets instead for built-in maps."
    st=1
fi;
# this check will return when I add json support for map templates
#for json in _maps/*.json
#do
#    filename="_maps/$(jq -r '.map_path' $json)/$(jq -r '.map_file' $json)"
#	if [ "$(jq -r '.map_file|type' $json)" == "array" ]
#	then
#		# We've got a multi-z map, check each file in succession
#		for file in $(jq -r '.map_file[]' $json)
#		do
#			subpath="_maps/$(jq -r '.map_path' $json)/$file"
#			if [ ! -f $subpath ]
#			then
#				echo "found invalid file reference to $subpath in _maps/$json"
#				st=1
#			fi
#		done
#    elif [ ! -f "$filename" ]
#    then
#        echo "found invalid file reference to $filename in _maps/$json"
#        st=1
#    fi
#done

exit $st
