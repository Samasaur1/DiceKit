set -o errexit

gem install jazzy

rm -rf docs
rm -rf DiceKit.xcodeproj
swift package generate-xcodeproj
git clone --branch=gh-pages https://github.com/Samasaur1/DiceKit.git ghp
jazzy -o newdocs -x -target,DiceKit
mkdir ghp/docs/v$VERSION
mv newdocs/* ghp/docs/v$VERSION
rm -rf newdocs/
cd ghp
echo 'section > section > p > img { margin-top: 4em; margin-right: 2em; }' >> ghp/docs/v$VERSION/css/jazzy.css
bash ../script/updateLatestDocs.sh $VERSION
git config --global user.name "Documentation Bot"
git config --global user.email "docbot@travis-ci.com"
git add .
git commit -m "Update documentation"
git remote set-url origin https://${GH_TOKEN}@github.com/Samasaur1/DiceKit.git
git push
