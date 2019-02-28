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


### conda
```bash
# install miniconda (note: py27 can be installed with miniconda3)
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# update conda and packages
conda update conda 
conda update --all

# create a new py36 environment
conda create -n py36 python=3.6 pip pytest

# create a new environment from YAML config file 
conda env create --file environment.yml

# activate/deactivate py36 environment
conda activate py36
deactivate

# delete an environment 
conda env remove -n py36 --all

# show conda info
conda info

# list the available environments 
conda info --envs

# list the packages installed in this environment
conda list

# search / install / uninstall a package in this environment
conda search pandas
conda install pandas
conda uninstall pandas -n py36

# add channels (e.g. conda-forge, bioconda)
conda config --add channels CHANNELNAME
```


### virtualenv
```bash
# install virtualenv
pip install virtualenv --user

# create a new virtualenv called venv
virtualenv venv

# activate the environment venv
source venv/bin/activate

# install py packages in venv
pip install <package_name>

# leave venv
deactivate
```
