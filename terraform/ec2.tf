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
apt install -y nginx python3 python3-pip git python3-venv

# Clone Repo
cd /home/ubuntu
git clone https://github.com/alpheratzz21/URL-Shortener.git
chown -R ubuntu:ubuntu URL-Shortener

cd URL-Shortener
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

#fix storage.json permissions
if [ ! -f /home/ubuntu/URL-Shortener/storage.json ]; then
    echo "{}" > /home/ubuntu/URL-Shortener/storage.json
fi

chown ubuntu:www-data /home/ubuntu/URL-Shortener/storage.json
chmod 666 /home/ubuntu/URL-Shortener/storage.json

#update permission gunicorn
chmod +x /home/ubuntu/URL-Shortener/venv/bin/gunicorn


#Create nginx config

# cat <<EOT> /etc/nginx/sites-available/flask.conf
# server{
#     listen 80;
#     server_name _;
    
#     location / {
#         proxy_pass http://127.0.0.1:5000;
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#     }
# }
# EOT

#copy nginx config 

cp /home/ubuntu/URL-Shortener/nginx/flask.conf /etc/nginx/sites-available/flask.conf
ln -s /etc/nginx/sites-available/flask.conf /etc/nginx/sites-enabled/flask.conf
rm -f /etc/nginx/sites-enabled/default
sudo systemctl restart nginx.service

#gunicorn systemd

cat <<EOT > /etc/systemd/system/gunicorn.service
[Unit]
Description=Gunicorn URL Shortener
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/URL-Shortener
ExecStart=/home/ubuntu/URL-Shortener/venv/bin/gunicorn --workers 3 -b 127.0.0.1:5000 app:app

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl daemon-reload
systemctl enable gunicorn.service
systemctl start gunicorn.service
EOF

    tags = {
      Name = "url-shortener-server"
    }
  
}