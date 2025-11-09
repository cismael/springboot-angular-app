
# Apply dos2unix to all script files inside .scripts folder
````bash
cd .scripts && find . -type f -name "*.sh" -print0 | xargs -0 dos2unix
````
