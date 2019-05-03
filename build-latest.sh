#!/bin/bash

src_dir='src'
github_project='git@github.com:Nilhcem/FakeSMTP.git'

cd "$(dirname "$0")"

if [[ ! -d "$src_dir" ]]; then
    git clone "$github_project" "$src_dir"
    if [[ $? -ne 0 ]]; then
        ehco "Failed to update source!"
        exit 1
    fi
else
    cd "$src_dir"
fi

git pull
if [[ $? -ne 0 ]]; then
    ehco "Failed to update source!"
    exit 1
fi

mvn clean package -Dmaven.test.skip
if [[ $? -ne 0 ]]; then
    echo "Failed to build Fake SMTP"
    exit 1
fi

jar="$(pwd)/$(find target -maxdepth 1 -name 'fakeSMTP*.jar')"
if [[ ! -a "$jar" ]]; then
    echo "Build completed, but jar was not found!"
    exit 1
else
    ln -s "$jar" '../fakeSMTP.jar'
fi

echo "Fake SMTP is ready for use"
