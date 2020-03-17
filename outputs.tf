output "op_defaultvpc" {
  value = aws_default_vpc.defaultvpc
}
output "op_subnetids" {
  value = data.aws_subnet_ids.subnetids
}
output "op_httpserver_secgrp_local" {
  value = aws_security_group.httpserver_secgrp_local
}
output "op_httpserverlocal" {
  value = aws_instance.httpserverlocal
}
output "op_httpserverlocal_publicdns" {
  value = aws_instance.httpserverlocal.public_dns
}
