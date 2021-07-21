# Python


### debugging
https://docs.python.org/3/library/pdb.html

```
python3 -m pdb myscript.py
```


### CliRunner and pytest
It occurred that a test file passed when executed alone, but failed when executed in combination with the other tests.
To investigate, I added: `, catch_exceptions=False` to: `result = runner.invoke(get_num_variants, args)`.
This allowed me to analyse the exceptions of the script. In that particular case, there was an issue with the structural logger.

