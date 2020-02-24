resource "aws_vpc" "websketch" {
  cidr_block = "192.168.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "${var.cluster-name}-vpc"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

# Public Subnets:

resource "aws_internet_gateway" "websketch-public" {
  vpc_id = aws_vpc.websketch.id
  tags = {
    "Name" = "${var.cluster-name}-public-gateway"
  }
}

resource "aws_subnet" "websketch-public" {
  count = 2
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = "192.168.${count.index * 16}.0/20"
  vpc_id = aws_vpc.websketch.id
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.cluster-name}-public-${count.index}"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_route_table" "websketch-public" {
  vpc_id = aws_vpc.websketch.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.websketch-public.id
  }
  tags = {
    "Name" = "${var.cluster-name}-public-routing"
  }
}

resource "aws_route_table_association" "websketch-public" {
  count = 2
  subnet_id = aws_subnet.websketch-public[count.index].id
  route_table_id = aws_route_table.websketch-public.id
}

# Private Subnets:

resource "aws_eip" "websketch-nat" {
  vpc = true
}

resource "aws_nat_gateway" "websketch-nat" {
  allocation_id = aws_eip.websketch-nat.id
  subnet_id = aws_subnet.websketch-public[0].id
  depends_on = [aws_internet_gateway.websketch-public]
  tags = {
    "Name" = "${var.cluster-name}-private-gateway"
  }
}

resource "aws_subnet" "websketch-private" {
  count = 2
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = "192.168.${(count.index + 2) * 16}.0/20"
  vpc_id = aws_vpc.websketch.id
  map_public_ip_on_launch = false
  tags = {
    "Name" = "${var.cluster-name}-private-${count.index}"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_route_table" "websketch-private" {
  vpc_id = aws_vpc.websketch.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.websketch-nat.id
  }
  tags = {
    "Name" = "${var.cluster-name}-private-routing"
  }
}

resource "aws_route_table_association" "websketch-private" {
  count = 2
  subnet_id = aws_subnet.websketch-private[count.index].id
  route_table_id = aws_route_table.websketch-private.id
}
