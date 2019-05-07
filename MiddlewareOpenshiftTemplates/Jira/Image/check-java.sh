
_EXPECTED_JAVA_VERSION="8"

#
# check for correct java version by parsing out put of java -version
# we expect first line to be in format 'java version "1.8.0_40"' and assert that minor version number will be 8 or higher
#

# original script expected only "java version", this fixes parsing of openjdk output as well
"$_RUNJAVA" -version 2>&1 | grep "\(java\|openjdk\) version" | ( 
        IFS=. read ignore1 version ignore2
        if [ ! ${version:-0} -ge "$_EXPECTED_JAVA_VERSION" ]
        then
           echo "*************************************************************************************************************************************"
           echo "**********     Wrong JVM version! You are running with "$ignore1"."$version"."$ignore2" but JIRA requires at least 1.8 to run.      **********"
           echo "*************************************************************************************************************************************"
           exit 1
        fi
    )   
if [ $? -ne 0 ] ; then
   exit 1
fi

