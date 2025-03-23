#!/bin/bash

set -e

echo "Publishing reports to docs/ for GitHub Pages..."

# Create docs folder if it doesn't exist
mkdir -p docs

# Copy all HTML reports to docs/
cp benchmarkResults/*.html docs/

# Generate index.html
cat <<EOF > docs/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Benchmark Reports</title>
  <style>
    body { font-family: sans-serif; padding: 2rem; }
    table { border-collapse: collapse; width: 100%; }
    th, td { padding: 8px 12px; border-bottom: 1px solid #ccc; text-align: left; }
    a { text-decoration: none; color: #007acc; }
    a:hover { text-decoration: underline; }
    h1 { margin-bottom: 1rem; }
  </style>
</head>
<body>
  <h1>Messaging vs HTTP Benchmark Reports</h1>
  <p>Click any report below to view the detailed HTML report.</p>
  <table>
    <thead>
      <tr>
        <th>Scenario</th>
        <th>Report</th>
      </tr>
    </thead>
    <tbody>
EOF

for file in docs/*-report.html; do
  scenario=$(basename "$file" | sed 's/-report\.html//')
  echo "    <tr><td>${scenario}</td><td><a href=\"$(basename "$file")\">View Report</a></td></tr>" >> docs/index.html
done

cat <<EOF >> docs/index.html
    </tbody>
  </table>
</body>
</html>
EOF

echo "Reports copied to docs/"
