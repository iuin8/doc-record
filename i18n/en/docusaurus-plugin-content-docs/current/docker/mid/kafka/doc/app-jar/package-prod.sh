#!/bin/sh
#Go to File Root
#cd "$WORKSPACE"

#Project Packaging
mvn clean install package '-Dmaven.test.skip=true'