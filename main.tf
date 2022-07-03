provider "aws" {
  region     = "us-east-1"
}

resource "aws_vpc" "vpcs" {
  for_each = {
    1 = "10.193.220.0/24"
    2 = "10.193.221.0/24"
  }

  cidr_block = each.value

  tags = {
    Name = "use1-prod-vpc ${each.key}"
  }
}

resource "aws_subnet" "subnetsforvpc1" {
  vpc_id = aws_vpc.vpcs.1.id
  for_each = {
    1 = "10.193.220.0/28"
    2 = "10.193.220.16/28"

  }
  cidr_block = each.value



  tags = {
    Name = "1sub ${each.key}"
  }
}

resource "aws_subnet" "subnetsforvpc2" {
  vpc_id = aws_vpc.vpcs.2.id
  for_each = {
    1 = "10.193.221.0/28"
    2 = "10.193.221.16/28"

  }
  cidr_block = each.value



  tags = {
    Name = "2sub ${each.key}"
  }
}

resource "aws_ec2_transit_gateway" "tgw" {

}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment1" {
  subnet_ids         = [aws_subnet.subnetsforvpc1.1.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpcs.1.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment2" {
  subnet_ids         = [aws_subnet.subnetsforvpc2.1.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpcs.2.id
}


