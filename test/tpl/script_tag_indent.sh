# Indented text should be undented
if true; then
    printf "%b\n" Text1
else
    printf "%b\n" Text2
fi
printf "%b\n" \ \ \ \ Text3
