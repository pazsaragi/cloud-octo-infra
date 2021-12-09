output "repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.repo
}

output "repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_escr_repository.repo.repository_url
}