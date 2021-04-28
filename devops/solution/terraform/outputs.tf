output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "redis_host" {
  value = google_redis_instance.redis.host
  description = "Redis Host ip"
}

output "redis_pass" {
  value = google_redis_instance.redis.auth_string
  description = "redis auth string"
}

output "redis_port" {
  value = google_redis_instance.redis.port
  description = "redis host port"
}
