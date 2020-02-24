output "hosted-zone" {
  value = data.aws_route53_zone.primary.name
}


output "nlb-nginx-ingress" {
  value = data.aws_lb.ingress-nginx.name
}

output "nlb-nginx-ingress-alias-1" {
  value = aws_route53_record.websketch.name
}


output "nlb-authnode-ingress" {
  value = data.aws_lb.ingress-authnode.name
}

output "nlb-authnode-ingress-alias-1" {
  value = aws_route53_record.websketch-lti.name
}
