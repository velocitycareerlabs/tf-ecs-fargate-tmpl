aws s3api create-bucket --bucket vcl-terraform-backend-store --region us-east-1 #--create-bucket-configuration LocationConstraint=us-east-1
aws s3api put-bucket-encryption --bucket vcl-terraform-backend-store --server-side-encryption-configuration "{\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}"
aws iam create-user --user-name vcl-terraform-user
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --user-name vcl-terraform-user
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess --user-name vcl-terraform-user
# update bucket-policy.json file with user ARN output from previous step
aws s3api put-bucket-policy --bucket vcl-terraform-backend-store --policy file://bucket-policy.json
aws s3api put-bucket-versioning --bucket vcl-terraform-backend-store --versioning-configuration Status=Enabled
aws iam create-access-key --user-name vcl-terraform-user
