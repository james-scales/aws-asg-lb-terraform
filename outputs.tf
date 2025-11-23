output "lb_dns_name" {
  value       = module.load_balancing.lb_dns_name
  description = "The DNS name of the Load Balancer."
}