# AWS

```
# list files in a s3 bucket
aws s3 ls <s3://bucket>

# other commands are:
piero@con-xps-12:~/$ aws s3 
cp        ls        mb        mv        presign   rb        rm        sync      website  

```

### create `folders` in a bucket using python boto3
```
import boto3
s3 = boto3.client('s3')
bucket_name = "YOUR-BUCKET-NAME"
directory_name = "DIRECTORY/THAT/YOU/WANT/TO/CREATE" #it's name of your folders
s3.put_object(Bucket=bucket_name, Key=(directory_name+'/'))
```



# Gcloud
Many commands are very similar to aws
