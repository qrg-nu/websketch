# =============================================================================
# NLB Ingress to Internal NGINX Load Balancer

data "kubernetes_service" "ingress-nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = "ingress-nginx"
  }
}

data "aws_lb" "ingress-nginx" {
  name = "${element(split("-", element(split(".", data.kubernetes_service.ingress-nginx.load_balancer_ingress.0.hostname), 0)), 0)}"
}


data "aws_route53_zone" "primary" {
  name = var.hosted-zone
}

resource "aws_route53_record" "websketch" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name = "websketch.${var.hosted-zone}"
  type = "A"
  alias {
    name = data.aws_lb.ingress-nginx.dns_name
    zone_id = data.aws_lb.ingress-nginx.zone_id
    evaluate_target_health = false
  }
}


# =============================================================================
# NLB Ingress to LTI Authorization Node

data "kubernetes_service" "ingress-authnode" {
  metadata {
    name      = "lti-authnode-public"
    namespace = "websketch"
  }
}

data "aws_lb" "ingress-authnode" {
  name = "${element(split("-", element(split(".", data.kubernetes_service.ingress-authnode.load_balancer_ingress.0.hostname), 0)), 0)}"
}

resource "aws_route53_record" "websketch-lti" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name = "websketch-lti.${var.hosted-zone}"
  type = "A"
  alias {
    name = data.aws_lb.ingress-authnode.dns_name
    zone_id = data.aws_lb.ingress-authnode.zone_id
    evaluate_target_health = false
  }
}
