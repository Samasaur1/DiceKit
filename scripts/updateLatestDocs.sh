cat > docs/latest.html <<HERE
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Refresh" content="0; url=v$1/index.html" />
  </head>
  <body>
    <p>The latest docs are available <a href="v$1/index.html">here</a>.</p>
  </body>
</html>
HERE