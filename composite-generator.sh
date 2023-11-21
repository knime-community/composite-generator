#!/bin/bash
# This script generates the composite defintion


usage(){
    echo "Usage: $0 [-n name of the composite update site] [-c list of children
    separated by space, can be either relative local or remote paths (e.g.
    https://update.knime.com/analytics-platform/5.1/, or 'child-update-site')] [-d destination directory to write the composite update site to]"
}

# get options from command line with getopts
while getopts "n:c:d:" opt; do
  case $opt in
    n) name=$OPTARG ;;
    c) children=$OPTARG ;;
    d) dest=$OPTARG ;;
    *) usage; exit 1;;
  esac
done

if [ ! $name ] && [ ! $children ] && [ ! $dest ]; then
    usage
    exit 1
fi

if [ -z "$name" ]; then
    echo "name not defined, use the -n option to set it"
    exit 1
fi

if [ -z "$children" ]; then
    echo "No children defined, use the -c option to set them"
    exit 1
fi

if [ -z "$dest" ]; then
    echo "No destination directory defined, use the -d option to set it"
    exit 1
fi

cc="${dest}/compositeContent.xml"
ca="${dest}/compositeArtifacts.xml"

echo "<?xml version='1.0' encoding='UTF-8'?>" > $cc
echo "<?xml version='1.0' encoding='UTF-8'?>" > $ca
echo "<?compositeMetadataRepository version='1.0.0'?>" >> $cc
echo "<?compositeArtifactRepository version='1.0.0'?>" >> $ca
echo "<repository name='$name' type='org.eclipse.equinox.internal.p2.metadata.repository.CompositeMetadataRepository' version='1'>" >> $cc
echo "<repository name='$name' type='org.eclipse.equinox.internal.p2.metadata.repository.CompositeArtifactRepository' version='1'>" >> $ca
echo "  <properties size='1'>" >> $cc
echo "  <properties size='1'>" >> $ca
echo "    <property name='p2.timestamp' value='$(date +%s)'/>" >> $cc
echo "    <property name='p2.timestamp' value='$(date +%s)'/>" >> $ca
echo "    <property name='p2.compressed' value='true'/>" >> $cc
echo "    <property name='p2.compressed' value='true'/>" >> $ca
echo "  </properties>" >> $cc
echo "  </properties>" >> $ca

# insert children
size=$(echo $children | wc -w)
echo "  <children size='$size'>" >> $cc
echo "  <children size='$size'>" >> $ca

for child in $children; do
  echo "    <child location='$child'/>" >> $cc
  echo "    <child location='$child'/>" >> $ca
done

echo "  </children>" >> $cc
echo "  </children>" >> $ca
echo "</repository>" >> $cc
echo "</repository>" >> $ca

zip -j -9 "${dest}/compositeArtifacts.jar" "${ca}"
zip -j -9 "${dest}/compositeContent.jar" "${cc}"

rm "${ca}" "${cc}"


(echo "version = 1";
echo "metadata.repository.factory.order = compositeContent.xml,\\!"
echo "artifact.repository.factory.order = compositeArtifacts.xml,\\!") > "${dest}/p2.index"
