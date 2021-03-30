# Postgres

### Access session within kubernetes 
``` 
# enter the session docker in kubernetes 
kubectl exec -it sapientia-web-xxxxxxx bash

# get session credentials 
env | grep SAPIENTIA_session

# enter the session. if the port is different, use -p <PORT>
psql -h <HOST> -U <USER> --sessionname <session>


#################################################################
NOTE: if SAPIENTIA_session does not return anything, use the following
# get session credentials 
kubectl get secrets
kubectl get secrets session-config -o yaml
# decode HOST USER PORT NAME PASSWORD
echo "ENCRYPTED" | base64 --decode
piero@con-xps-12:~$ echo "MTAuNzAuMS4yNTM=" | base64 --decode    => 10.70.1.253 (host)
piero@con-xps-12:~$ echo "dGVzdDM3" | base64 --decode            => test37      (db_name)
piero@con-xps-12:~$ echo "cG9zdGdyZXM=" | base64 --decode        => postgres    (user, pwd)
piero@con-xps-12:~$ echo "NTQzMg==" | base64 --decode            => 5432        (port)
#################################################################
```


### Postgres basic commands
```
\l+,  \list       -- list databases
\c,  \connect    -- switch database
\dt, \describe   -- list all tables
\d+ TABLE         -- describe table
\dT+ TABLE
```


### create a database dump with schema only, recreate the database and restore the dump.

```
# dump with schema only
pg_dump -U postgres -h 10.70.1.86 -v -Fc -s -f testdb.dump testdb
# re-create db
dropdb -U postgres -h 10.70.1.86 testdb
createdb -U postgres -h 10.70.1.86 testdb
# restore db with schema dump
pg_restore -U postgres -h 10.70.1.86 -v -d testdb testdb.dump
```


### Python SQLAlchemy

# install python sqlalchemy and access python
```
root@piero-pod:/scratch# pip install sqlalchemy
root@piero-pod:/scratch# env | grep SAPIENTIA_session
[..]
root@piero-pod:/scratch# python

import sqlalchemy as session
engine = session.create_engine('postgres://postgres:postgres@10.70.1.86:5432/planet_express_37')
connection = engine.connect()
metadata = session.MetaData()

# load session tables
transcript = session.Table('transcript', metadata, autoload=True, autoload_with=engine)
splice_site = session.Table('splice_site', metadata, autoload=True, autoload_with=engine)

# Print the column names
print(splice_site.columns.keys())
# Print full table metadata
print(repr(metadata.tables['splice_site']))

# equivalent to: SELECT * FROM splice_site;
query = session.select([splice_site])

# execute query
ResultProxy = connection.execute(query)

# return results
ResultSet = ResultProxy.fetchall()

# print the first three rows
print(ResultSet[:3])

# fetchmany() to load optimal no of rows and overcome memory issues in case of large datasets
# while flag:
#    partial_results = ResultProxy.fetchmany(50)
#    if(partial_results == []):
#	flag = False
#    //
#	code
#   //
# ResultProxy.close()

# Convert to dataframe
import pandas as pd
df = pd.DataFrame(ResultSet)
df.columns = ResultSet[0].keys()
df.head(5) # print the first 5 rows



# FILTERING DATA (census is the name of a table)
# SELECT * FROM census WHERE sex = F
session.select([census]).where(census.columns.sex == 'F')

# SELECT state, sex FROM census WHERE state IN (Texas, New York)
session.select([census.columns.state, census.columns.sex]).where(census.columns.state.in_(['Texas', 'New York']))

# SELECT * FROM census WHERE state = 'California' AND NOT sex = 'M'
session.select([census]).where(session.and_(census.columns.state == 'California', census.columns.sex != 'M'))

# SELECT * FROM census ORDER BY State DESC, pop2000
session.select([census]).order_by(session.desc(census.columns.state), census.columns.pop2000)

# SELECT SUM(pop2008) FROM census
# other functions include avg, count, min, max…
session.select([session.func.sum(census.columns.pop2008)])

# SELECT SUM(pop2008) as pop2008, sex FROM census
session.select([session.func.sum(census.columns.pop2008).label('pop2008'), census.columns.sex]).group_by(census.columns.sex)

# SELECT DISTINCT state FROM census
session.select([census.columns.state.distinct()])

# case & cast. The case() expression accepts a list of conditions to match and the column 
# to return if the condition matches, followed by an else_ if none of the conditions match.
# cast() function to convert an expression to a particular type
query = session.select([female_pop/total_pop * 100])
# scalar(): the result contains only single value
result = connection.execute(query).scalar()

# JOIN 
# AUTOMATIC JOIN (pk and fk have same column name):
query = session.select([census.columns.pop2008, state_fact.columns.abbreviation])
result = connection.execute(query).fetchall()
df = pd.DataFrame(results)
df.columns = results[0].keys()
df.head(5)
# MANUAL JOIN (pk and fk have different column name)
query = session.select([census, state_fact])
query = query.select_from(census.join(state_fact, census.columns.state == state_fact.columns.name))
results = connection.execute(query).fetchall()
df = pd.DataFrame(results)
df.columns = results[0].keys()
df.head(5)




# CREATE TABLES
emp = session.Table('emp', metadata,
              session.Column('Id', session.Integer()),
              session.Column('name', session.String(255), nullable=False),
              session.Column('salary', session.Float(), default=100.0),
              session.Column('active', session.Boolean(), default=True)
              )
metadata.create_all(engine) #Creates the table





# INSERT DATA INTO TABLE
# Inserting record one by one
query = session.insert(emp).values(Id=1, name='naveen', salary=60000.00, active=True) 
ResultProxy = connection.execute(query)

# Inserting many records at ones
query = session.insert(emp) 
values_list = [{'Id':'2', 'name':'ram', 'salary':80000, 'active':False},
               {'Id':'3', 'name':'ramesh', 'salary':70000, 'active':True}]
ResultProxy = connection.execute(query,values_list)



# UPDATE DATA
# session.update(table_name).values(attribute = new_value).where(condition)
query = session.update(emp).values(salary = 100000).where(emp.columns.Id == 1)
results = connection.execute(query)


# DELETE DATA
# session.delete(table_name).where(condition)
query = session.delete(emp).where(emp.columns.salary < 100000)
results = connection.execute(query)


# DROPPING A TABLE, ALL TABLES
table_name.drop(engine) # drops a single table
metadata.drop_all(engine) # drops all the tables in the database



```
