set -o errexit

gem install jazzy

rm -rf docs
rm -rf DiceKit.xcodeproj
swift package generate-xcodeproj
jazzy
cd docs
git config --global user.name "Documentation Bot"
git config --global user.email "docbot@travis-ci.com"
git init
git add .
git commit -m "Documentation"
git push --force "https://${GH_TOKEN}@github.com/Samasaur1/DiceKit.git" master:gh-pages
