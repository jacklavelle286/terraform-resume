resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PROVISIONED"

  for_each = { for idx, attr in var.dynamodb_attributes : idx => attr }

  attribute {
    name = each.value.name
    type = each.value.type
  }
}
