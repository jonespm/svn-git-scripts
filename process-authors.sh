#!/bin/bash

# This quick shell script takes the authors file and makes a shell script to re-write the authors file.
# save the output and use it to re-write the authors.

cat <<EOF
#!/bin/sh
 
git filter-branch --env-filter '
GIT_COMMITTER_EMAIL="\${GIT_COMMITTER_EMAIL/@????????-????-*/}"
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
 print "  export GIT_COMMITTER_NAME=\"" name "\""
 print "  export GIT_COMMITTER_EMAIL=\"" email "\""
 print "  export GIT_AUTHOR_NAME=\"" name "\""
 print "  export GIT_AUTHOR_EMAIL=\"" email "\""
 print "fi"
}'

cat <<EOF
' --tag-name-filter cat --original authors -- $1
EOF


