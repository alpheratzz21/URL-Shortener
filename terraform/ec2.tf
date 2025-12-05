data "aws_ami" "ubuntu" {
  most_recent = true

  owners = [ "099720109477" ] #canonical ubuntu owner

  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

resource "aws_instance" "url_shortener" {
    ami = data.aws_ami.ubuntu.id #Ubuntu 22.04 ap-southeast-1
    instance_type = var.instance_type
    key_name = aws_key_pair.generated.key_name
    security_groups = [aws_security_group.url_sg.name]

    user_data = <<-EOF
#!/bin/bash
apt update -y
apt install -y nginx python3 python3-pip git

# Clone Repo
cd /home/ubuntu
git clone https://github.com/alpheratzz21/URL-Shortener.git
cd URL-Shortener

pip3 install flask gunicorn

#Copy nginx config
cp flask.conf /etc/nginx/sites-available/flask.conf
ln -s /etc/nginx/sites-available/flask.conf /etc/nginx/sites-enabled/flask.conf
rm /etc/nginx/sites-enabled/default
systemctl restart nginx

#gunicorn systemd
cat <<EOT > /etc/systemd/system/gunicorn.service
[Unit]
Description=Gunicorn URL Shortener
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/URL-Shortener
ExecStart=/usr/bin/python -m gunicorn -b 0.0.0.0:5000 app:app

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl enable gunicorn
systemctl start gunicorn
EOF

    tags = {
      Name = "url-shortener-server"
    }
  
}