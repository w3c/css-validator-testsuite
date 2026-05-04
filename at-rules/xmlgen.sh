#!/bin/sh

if [ ! -f xmlgen.sh ]; then
    echo "You must run this script in its directory"
    exit 0
fi

for level in  css21 css2 css3 ; do
    cat >../xml/atrules-$level.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!--
test markup also accepts 3 properties: warning, profile and medium
like <test profile="css2" medium="all" warning="0">
where warning means warninglevel in use (0 => normal, no => none).
-->
<testsuite>
EOF
done

for kind in positive ; do
    if [ ! -d $kind ]; then
	echo "Directory $kind not present"
	exit 0
    fi

    for atrule in `ls $kind | grep -v CVS` ; do
	echo "Working on $atrule"
	for level in `ls $kind/$atrule | grep -v CVS` ; do
	    echo "Level for $atrule is $level"
	    echo "  <type title=\"Valid_at_$atrule\">" >> ../xml/atrules-$level.xml
	    for tst in `ls $kind/$atrule/$level | grep -v CVS` ; do
# FIXME check form the test (comment?) what is the intent and expected
# result.
		cat >> ../xml/atrules-$level.xml <<EOF
    <test profile="$level" warning="no">
      <file>testsuite/at-rules/$kind/$atrule/$level/$tst</file>
      <description>Valid @$atrule level $level</description>
      <result valid="true" />
    </test>
EOF
	    done
	    echo "  </type>" >> ../xml/atrules-$level.xml	    
	done
    done
done

for level in css21 css2 css3 ; do
    cat >> ../xml/atrules-$level.xml <<EOF
<!--
test markup also accepts 3 properties: warning, profile and medium
like <test profile="css2" medium="all" warning="0">
where warning means warninglevel in use (0 => none).
-->
</testsuite>
EOF
done
