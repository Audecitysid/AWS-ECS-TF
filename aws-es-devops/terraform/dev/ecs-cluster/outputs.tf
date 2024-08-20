
# Output ALB ARN
output "alb_arn" {
  value       = module.ecs-cluster.alb_arn
  description = "The ARN of the ALB"
}