output "address" {
  value       = aws_db_instance.example.address
  description = "connect db at this endpoint"
}

output "port" {
  value       = aws_db_instance.example.port
  description = "the port db is listening on"
}
