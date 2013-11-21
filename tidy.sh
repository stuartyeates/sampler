while read LINE
do
    URL1=`echo $LINE|sed 's/,.*//'`
    #echo $URL1
    URL=`echo $URL1 | sed 's^|^%7C^g' | sed 's^?^%3F^'`
    #echo $URL $URL1
    if [ -n "$URL" ]; then 
	LOCATION=`curl --silent --retry 1 --head $URL| grep 'Location:'|sed 's^Location: ^^g' |tr -d '\15\32'`
	#echo $LOCATION
	if [ -n "$LOCATION" ]; then 
	    URL=$LOCATION
	    LOCATION=`curl --silent --retry 1 --head $URL| grep 'Location:'|sed 's^Location: ^^g' |tr -d '\15\32'`
	    if [ -n "$LOCATION" ]; then 
		URL=$LOCATION
		LOCATION=`curl --silent --retry 1 --head $URL| grep 'Location:'|sed 's^Location: ^^g' |tr -d '\15\32'`
		if [ -n "$LOCATION" ]; then 
		    URL=$LOCATION
		fi
	    fi
	fi
	SIZE=`curl --silent --retry 1 --head $URL| grep 'Content-Length:'| sed 's^Content-Length: ^ ^g'|tr -d '\15\32'`
	#echo $SIZE;
	echo $URL1, $URL, $SIZE,
	
    fi
done