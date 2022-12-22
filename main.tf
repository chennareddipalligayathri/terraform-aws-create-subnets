data "aws_availability_zones" "zones"{
    state ="available"
}
locals {
    digit =split (".",module.createVPC.vpc_cidr)
}
resource "aws_subnet" "private_subnet"{
    count = length(data.aws_availability_zones.zones.names)
    availability_zone = data.aws_availability_zones.zones.names[count.index]
    vpc_id =module.createVPC.vpc_id
    map_public_ip_on_launch =false
    cidr_block = "${local.digit[0]}.${local.digit[1]}.${count.index}.0/24"
    tags ={
        Name = "${var.subnet_name}_private_${count.index}"
        Type = "private"
    }
}
resource "aws_subnet" "public_subnet"{
    count = length(data.aws_availability_zones.zones.names)
    availability_zone = data.aws_availability_zones.zones.names[count.index]
    vpc_id =module.createVPC.vpc_id
    map_public_ip_on_launch =true
    cidr_block = "${local.digit[0]}.${local.digit[1]}.${10+count.index}.0/24"
    tags ={
        Name = "${var.subnet_name}_public_${count.index}"
        Type = "public"
    }
}