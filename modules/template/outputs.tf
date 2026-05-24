output "debian_ready" { value = null_resource.template_debian.id }
output "nginx_ready"  { value = null_resource.template_nginx.id }
output "db_ready"     { value = null_resource.template_db.id }
