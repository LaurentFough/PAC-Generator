#!/bin/bash
# Yeri Tiete
# aka Tuinslak
# http://yeri.be
# https://github.com/Tuinslak/PAC-Generator

# Get config, make sure it's named correctly
source config.sh

# Get URLs based on csv file, 1st column is url (see http://yeri.be/hr)
awk '{print $1}' FS="," $LIST > $TMP1

# Check on www.* and write both with and without www. to the tmp file
while read a; do {
	if [[ $a == www.* ]]; then
		echo $a >> $TMP2
		echo $a | sed 's/www./*./' >> $TMP2
	else
		echo $a >> $TMP2
	fi
} done < $TMP1

# Create the .pac file
echo "function FindProxyForURL(url, host) {" > $TMPPAC
echo "	// Proxy.pac generated by PAC-Generator (http://yeri.be/j4)" >> $TMPPAC
echo "	// Yeri Tiete" >> $TMPPAC
echo "	// aka Tuinslak" >> $TMPPAC
echo "	// http://yeri.be" >> $TMPPAC
echo "" >> $TMPPAC
echo "	// Generated at `date -u '+%H:%M:%S %d-%m-%Y'` (UTC)" >> $TMPPAC
echo "" >> $TMPPAC

while read a; do {
	echo "	if (shExpMatch(host, \"$a\"))" >> $TMPPAC
	echo "		{ return \"PROXY $PROXYADDRESS; DIRECT\" }" >> $TMPPAC
	echo "	else " >> $TMPPAC
	echo "" >> $TMPPAC
} done < $TMP2

echo "" >> $TMPPAC

echo "	{ " >> $TMPPAC
echo "	// Default: no proxy," >> $TMPPAC
echo "	// but just in case it fails to resolve directly, use proxy" >> $TMPPAC
echo "	return \"DIRECT\"" >> $TMPPAC
echo "	}" >> $TMPPAC
echo "" >> $TMPPAC
echo "// End of PAC file" >> $TMPPAC
echo "}" >> $TMPPAC

# Move the temporary PAC file to its final location
mv $TMPPAC $OUT

# That's it !
