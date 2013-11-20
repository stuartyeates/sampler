while read LINE
do
    URL1=`echo $LINE|sed 's/,.*//'`
    #echo $URL1
    URL=`echo $URL1 | sed 's^|^%7C^g'`
    #echo $URL $URL1
    if [ -n "$URL" ]; then 
	LOCATION=`curl --silent --retry 1 --head $URL| grep 'Location:'|sed 's^Location: ^^g' `
	#echo $LOCATION
	if [ -n "$LOCATION" ]; then 
	    URL=$LOCATION
	fi
	SIZE=`curl --silent --retry 1 --head $URL| grep 'Content-Length:'| sed 's^Content-Length: ^^g'`
	#echo $SIZE;
	echo $URL, $SIZE,
    fi
done