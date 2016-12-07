# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "public" {
  name = "${var.customer}-terraform-example-public"
  vpc_id = "${aws_vpc.vpc.id}"
  # HTTP access from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "private" {
  count = "${var.az_count}"
  name = "${var.customer}-terraform-example-private-${count.index}"
  vpc_id = "${aws_vpc.vpc.id}"
  # SSH access from the public subnets
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${lookup(var.pubsub_cidrs, count.index)}"]
  }
  # HTTP access from the public subnets
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${lookup(var.pubsub_cidrs, count.index)}"]
  }
  # Outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "elb" {
  name = "${var.customer}-terraform-example-elb"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.public.id}"]
  instances = ["${aws_instance.web.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}

resource "aws_key_pair" "auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "web" {
  # Tag it
  tags {
    Name = "${var.customer}-terraform-example"
    Power = "dev"
    Owner = "andy.powell@eduserv.org.uk"
    Billing = "ap.eduservlab.net"
  }
  instance_type = "t2.micro"
  ami = "${lookup(var.aws_amis, var.region)}"
  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.private.*.id}"]
  subnet_id = "${aws_subnet.private0.0.id}"
# Note: use of provisioner not possible because instance is on a private subnet
#  # The connection block tells our provisioner how to
#  # communicate with the resource (instance)
#  connection {
#    # The default username for our AMI
#    user = "ubuntu"
#    type = "ssh"
#    private_key = "${file(var.private_key_path)}"
#    # The connection will use the local SSH agent for authentication.
#  }
#  # The name of our SSH keypair we created above.
#  key_name = "${aws_key_pair.auth.id}"
#  # We run a remote provisioner on the instance after creating it.
#  # In this case, we just install nginx and start it. By default,
#  # this should be on port 80
#  provisioner "remote-exec" {
#    inline = [
#      "sudo apt-get -y update",
#      "sudo apt-get -y install nginx",
#      "sudo service nginx start",
#    ]
#  }
  user_data = <<EOF
#!/bin/sh
sudo apt-get -y update
sudo apt-get -y install nginx
sudo service nginx start
EOF
}
