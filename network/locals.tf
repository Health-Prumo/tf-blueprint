locals {
  name = "${var.basename}-${var.environment}"
  azs  = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  # Subnets privadas na primeira metade da VPC (/20 cada). A segunda metade fica
  # reservada para subnets públicas, que não são criadas enquanto não houver uso.
  private_cidrs = [for i in range(var.az_count) : cidrsubnet(var.cidr_block, 4, i)]
}
