#!/bin/sh
# check a set of TEI-like resources to see if they are valid
# against current schema.
#
# Sebastian Rahtz 2013-11-22
# sebastian.rahtz@it.ox.ac.uk
#
checkTEI() {
    if grep -q "<TEI.2" $N.xml 
	then
	    echo TEI P4,
	    if xmllint -o $N-P4.xml --noent --dropdtd $N.xml >& $N.LOG
	    then		
		curl -s -m 300 -o $N.xml -F upload=@${N}-P4.xml ${OXGARAGE}
		checkTEI
	    else
		COLOUR=red
		echo expanding TEI P4 fails
	    fi
	else
	    if jing TEI.rng $N.xml >& $N.LOG
	    then
		echo Valid TEI P5
		OK=$((OK + 1))
		COLOUR=green
	    else
		echo not valid TEI P5
		COLOUR=orange
		if grep -q 'attribute "xsi:schemaLocation"' $N.LOG 
		then
		   echo " (because it has XSD schema link)"
		fi
	    fi
        fi
}

OXGARAGE=http://oxgarage.oucs.ox.ac.uk:8080/ege-webservice/Conversions/P4%3Atext%3Axml/TEI%3Atext%3Axml/
LIST=https://raw.github.com/stuartyeates/sampler/master/TEI/content-formatted.csv
echo "<html><head><title>Checking $LIST</title></head><body><table>"
curl -L  -s -O $LIST
curl -L  -s -o TEI.rng http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng
N=0
OK=0
for i in `awk -F, '{print $1}' content-formatted.csv`
do
    COLOUR=white
    N=$((N + 1))
    echo "<tr><td>$N</td><td><a href=\"$i\">$i<a></td><td>"
    if  [[ $i == https* ]] 
    then
	curl -L  -s -o $N.xml "$i"
	checkTEI
    else
	if xmllint -o $N.xml --xinclude "$i" >& $N.LOG
	then
	    checkTEI
	else
	    echo not well-formed XML, or resources not available      
	    COLOUR=red
	fi
    fi
   echo "</td><td style=\"background-color:$COLOUR\"><a href=\"$N.LOG\">LOG</a></td></tr>"
done
echo "</table>"
echo "<p>$N texts examined, $OK are valid against TEI P5</p>"
echo "</body></html>"