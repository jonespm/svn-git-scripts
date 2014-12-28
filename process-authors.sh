#!/bin/bash

# This quick shell script takes the authors file and makes a shell script to re-write the authors file.
# save the output and use it to re-write the authors.

cat <<EOF
#!/bin/sh
 
git filter-branch --env-filter '
EOF

# Contains lines like: a.fish@lancaster.ac.uk = Adrian Fish <a.fish@lancaster.ac.uk>
cat authors-all.txt | \
awk -F" = " '{
 split($2, details, " <");
 sub(/>/, "", details[2]);
 sub(/^ +/, "", details[1]);
 email=details[2]
 name=details[1]
 print "if [ \"\$GIT_COMMITTER_EMAIL\" = \"" $1 "\" ]"
 print "then"
 print "  export GIT_COMMITER_NAME=\"" name "\""
 print "  export GIT_COMMITER_EMAIL=\"" email "\""
 print "fi"
}'

cat <<EOF
' --tag-name-filter cat -- --branches
EOF


