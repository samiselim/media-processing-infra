resource "aws_db_subnet_group" "default" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project}-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "${var.project}-rds"
  
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  db_name                    = "media_db"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [var.security_group_id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}
