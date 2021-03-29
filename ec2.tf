module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "magnolia"
  instance_count         = 1

  ami                    = "ami-05b891753d41ff88f"
  instance_type          = "t2.medium"
  key_name               = "1"
  monitoring             = true
  vpc_security_group_ids = ["sg-0cdf955eff69ad02a"]
  subnet_id              = "subnet-f7d44eae"

  user_data = <<EOF
#!/bin/bash
echo "Hello Terraform!"
apt update && upgrade -y
apt install default-jre -y
apt install nodejs -y
apt install npm -y
apt install nginx -y
apt install supervisor -y
npm install @magnolia/cli -g
mkdir /opt/app/
cd /opt/app/
echo "2" | mgnl jumpstart
echo "[program:magnolia]
command=mgnl start -p /opt/app/
autostart=true
autorestart=true
stderr_logfile=/var/log/magnolia.err.log
stdout_logfile=/var/log/magnolia.out.log" > /etc/supervisor/conf.d/magnolia.conf
service supervisor stop
service supervisor start
EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


