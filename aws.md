# AWS

### List all profiles
```
aws configure list-profiles
```

### Setting up role and profile
Mini guide to getting the AWS.

FIND ROLE in AWS services -> AIM

Alternatively, set it up like this ~/.aws/config (recommend against setup a default profile to avoid accidents)
```
[sso-session PROD]
sso_start_url = https://d-9c673c4092.awsapps.com/start#
sso_region = eu-west-2
sso_registration_scopes = sso:account:access

[profile PROFILE_NAME]
sso_session = PROD
sso_account_id = <account number>
sso_role_name = AdministratorAccess
region = eu-west-2
output = json

[profile profile_assuming_role_from_PROFILE_NAME]
role_arn = <role arn>
source_profile = PROFILE_NAME
```

Then, log in to SSO:
```
aws sso login --sso-session PROD
```

To use the profiles
```
export AWS_PROFILE=PROFILE_NAME or
aws ... --profile PROFILE_NAME
```

If you need environment variables for something
```
eval "$(aws configure export-credentials --profile PROFILE_NAME --format env)"
```



### List files in a s3 bucket
```
aws s3 ls --profile <MY_PROFILE IN .aws/config or default> <s3://bucket>

# other commands are:
piero@con-xps-12:~/$ aws s3
cp        ls        mb        mv        presign   rb        rm        sync      website

```

### Check identity of person running aws.
This is helpful for making sure one is using the right account / profile
```
aws sts get-caller-identity
{
    "UserId": ***,
    "Account": ***,
    "Arn": ***
}
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
