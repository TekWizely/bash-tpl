# Indented text should be undented
if true; then
    printf "%s\n" Text1
else
    printf "%s\n" Text2
fi
printf "%s\n" \ \ \ \ Text3
