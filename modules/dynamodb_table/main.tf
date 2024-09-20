resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PROVISIONED"
  read_capacity = 1
  write_capacity = 1

  dynamic "attribute" {
    for_each = var.dynamodb_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
}
