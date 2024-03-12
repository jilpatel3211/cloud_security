output "aws_policy_arn" {
    value = aws_iam_policy.lab6policy.arn
}

output "aws_ec2_role_name" {
    value = aws_iam_role.lab6role.name
}

output "aws_ec2_instance_profile_name" {
    value = aws_iam_instance_profile.ec2_instance_profile.name
}