resource "google_redis_instance" "redis" {
  name               = "techtest-redis"
  tier               = "BASIC"
  memory_size_gb     = 2
  region             = "europe-west2"
  location_id        = "europe-west2-c"
  redis_version      = "REDIS_5_0"
  auth_enabled       = true
  authorized_network = google_compute_network.vpc.name
}
