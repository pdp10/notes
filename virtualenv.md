# Virtualenv (python)

### A virtualenv session: useful for testing an installation
```
#!/bin/bash

# create a virtualenv
python3 -m venv my_py3_venv

# activate the virtualenv
source my_py3_venv/bin/activate

# upgrade pip
pip install --upgrade pip

# install python packages manually with pip if needed

# install the package and its dependencies for production:
#python -m pip install -r requirements/production.txt
#python -m pip install .

# install the package and its dependencies for development:
# development.txt should start with 
# -r production.txt
python -m pip install -r requirements/development.txt
python -m pip install -e .

# deactivate virtualenv
deactivate

# remove virtualenv
rm -rf my_py3_venv
```
