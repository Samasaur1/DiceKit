# The name "ud" comes from UpdateDocs
# However, this script can be used to generate new docs if you so desire.
# It generates docs for any passed versions that are tagged
set -o errexit

rm -rf doks
mkdir doks
for VERSION in "$@"
do
    git checkout v$VERSION
    jazzy -o newdocs --author_url https://samasaur1.github.io --github-file-prefix https://github.com/Samasaur1/DiceKit/tree/v$VERSION --swift-build-tool spm
    mkdir doks/v$VERSION
    mv newdocs/* doks/v$VERSION
    rm -rf newdocs
    echo 'section > section > p > img { margin-top: 4em; margin-right: 2em; }' >> doks/v$VERSION/css/jazzy.css
done
git checkout gh-pages
for VERSION in "$@"
do
    rm -rf docs/v$VERSION
    mkdir docs/v$VERSION
    mv doks/v$VERSION/* docs/v$VERSION
done
