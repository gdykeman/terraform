output "Server-URL" {
  description = "Server URL"
  value       = join("", ["http://", aws_instance.instance.public_ip])
}

output "Date-Time" {
  description = "Date & Time"
  value       = timestamp()
}