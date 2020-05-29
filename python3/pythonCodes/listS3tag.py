import boto3


session = boto3.session.Session(profile_name='cfao-fdsqa', region_name='us-west-2')

# Create an S3 client
s3 = session.client('s3')

# Call S3 to get bucket tagging
bucket_tagging = s3.get_bucket_tagging(Bucket='mynewbucketname9')

# Get a list of all tags
tag_set = bucket_tagging['Tagkey']

# Print out each tag
for tag in tag_set:
    print(tag)
