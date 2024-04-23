output "asg_name" {
  value       = aws_autoscaling_group.web.name
  description = "The name of the Auto Scaling Group created."
}


output "web_security_group_id" {
  description = "ID of the Web Security Group"
  value       = aws_security_group.web.id
}

output "instance_id" {
  value = aws_launch_configuration.web_server.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.web.name
}
