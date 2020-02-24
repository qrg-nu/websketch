resource "aws_ebs_volume" "sketchRepo" {
  availability_zone = aws_subnet.websketch-public[0].availability_zone
  size = var.sketch-repo-volume-size
  type = "gp2"
  tags = {
    Name = "websketch_Sketch_Repo"
  }
}

resource "aws_ebs_volume" "websketchLogs" {
  availability_zone = aws_subnet.websketch-public[0].availability_zone
  size = var.logs-volume-size
  type = "gp2"
  tags = {
    Name = "websketch_Logs"
  }
}

resource "aws_ebs_volume" "ltiDb" {
  availability_zone = aws_subnet.websketch-public[0].availability_zone
  size = var.db-volume-size
  type = "gp2"
  tags = {
    Name = "websketch_LTI_Db"
  }
}