# Useful bash commands

### grep, find, sed

```bash
#Search for a pattern in files in the current directory recursively
grep --include=*.py -rnw '.' -e 'pattern'

# Replace foo with bar recursively (all regular files) 
# i: in-place, g: globally
find . -type f -name "*.py" | xargs sed -i 's/foo/bar/g'

# Dry-run. p:print-only
find . -type f -name "*.py" | xargs sed 's/foo/bar/gp'
```

Here is a workflow to find, check, and replace whole word strings in files 
recursively.

```bash
# Show the occurences of "def" in files in the current directory recursively
grep --include=*.py -rnw '.' -e "def"

# Pipe the files (l: get files) from grep to sed 
# n: don't show file content; 
# \b: whole word; p: print). 
# Finally, grep the new string 
grep --include=*.py -rnwl '.' -e "def" | xargs sed -n 's/\bdef\b/DEF/gp' | grep "DEF"`

# Execute the command in place (-i)
grep --include=*.py -rnwl '.' -e "def" | xargs sed -i 's/\bdef\b/DEF/g'

# Double check
grep --include=*.py -rnw '.' -e "DEF"
```

