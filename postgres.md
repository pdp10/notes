# Postgres

### Access DB within kubernetes 
``` 
# get DB credentials 
kubectl get secrets
kubectl get secrets db-config -o yaml

# decode HOST USER PORT NAME PASSWORD
echo "ENCRYPTED" | base64 --decode

piero@con-xps-12:~$ echo "MTAuNzAuMS4yNTM=" | base64 --decode    => 10.70.1.253 (host)
piero@con-xps-12:~$ echo "dGVzdDM3" | base64 --decode            => test37      (db_name)
piero@con-xps-12:~$ echo "cG9zdGdyZXM=" | base64 --decode        => postgres    (user, pwd)
piero@con-xps-12:~$ echo "NTQzMg==" | base64 --decode            => 5432        (port)


# enter the DB docker in kubernetes 
kubectl exec -it sapientia-web-xxxxxxx /bin/bash

# enter the DB
psql -h HOST -p PORT -U USER NAME
```

### Postgres basic commands
```
\l,  \list       -- list databases
\c,  \connect    -- switch database
\dt, \describe   -- list all tables
\d TABLE         -- describe table
```
