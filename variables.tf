variable "aws_region" {
  description = "La región donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "ec2_instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "ebs_volume_size" {
  description = "Tamaño del volumen EBS en GB"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Etiquetas comunes para los recursos"
  type        = map(string)
  default = {
    Owner           = "Facu Miglio",
    Email           = "facundo.miglio@educacionit.com",
    Team            = "DevOpsTeam",
    Proyectogrupo-1 = "Actividad-AWS"
  }
}
