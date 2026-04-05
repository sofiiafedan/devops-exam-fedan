# 1. ПОВНІСТЮ НОВА МЕРЕЖА
resource "digitalocean_vpc" "vpc" {
  name     = "sofiia-ultra-fresh-vpc"
  region   = "fra1"
  ip_range = "10.55.55.0/24" # Новий діапазон
}

# 2. НОВИЙ СЕРВЕР + NGINX
resource "digitalocean_droplet" "node" {
  image    = "ubuntu-22-04-x64"
  name     = "sofiia-final-node-exam"
  region   = "fra1"
  size     = "s-1vcpu-1gb"
  vpc_uuid = digitalocean_vpc.vpc.id

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF
}

# 3. НОВИЙ ФАЄРВОЛ
resource "digitalocean_firewall" "firewall" {
  name = "sofiia-security-shield-final"

  droplet_ids = [digitalocean_droplet.node.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# 4. НОВИЙ БАКЕТ
resource "digitalocean_spaces_bucket" "bucket" {
  name   = "sofiia-exam-success-bucket-2026" # Абсолютно унікальне ім'я
  region = "fra1"
  acl    = "private"
}