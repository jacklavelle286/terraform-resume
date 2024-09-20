variable "dynamodb_attributes" {
  type = list(object({
    name = string
    type = string
  }))
  description = "List of DynamoDB attributes with their names and types"
  default = []
}

variable "table_name" {
  type = string
}
