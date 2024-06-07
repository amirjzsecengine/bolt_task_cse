output "public_ip" {
  value       = aws_instance.web_app.public_ip
  description = "The public IP address of the web server"
}
