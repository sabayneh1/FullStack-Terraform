output "web_application_url" {
  value       = module.web_load_balancer.lb_dns_name
  description = "URL to access the web application."
}


output "wdb_instance_address" {
  value       = module.database.db_instance_address
  description = "db instance address"
}

