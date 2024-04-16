# cloud_security
aws iam detach-role-policy --policy-arn $arn:aws:iam::767398108656:policy/policy --role-name $lab6-role

aws iam remove-role-from-instance-profile --role-name lab6-role --instance-profile-name ec2_instance_profile

aws iam delete-instance-profile --instance-profile-name ec2_instance_profile

aws iam delete-role --role-name lab6-role
