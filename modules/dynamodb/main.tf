resource "aws_dynamodb_table" "table" {
  name           = var.name
  billing_mode   = var.billing_mode
  read_capacity  = var.rcus
  write_capacity = var.wcus
  hash_key       = var.hash_key
  range_key      = var.range_key
  count          = length(var.attributes)
  attribute      = var.attributes[count.index]

  attribute {
    name = var.hash_key
    type = "S"
  }

  attribute {
    name = var.range_key
    type = "S"
  }

  attribute {
    name = var.attribute_name
    type = var.attribute_type
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

}

variable "name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "billing_mode" {
  description = "The billing mode of the DynamoDB table"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "rcus" {
  description = "The read capacity units of the DynamoDB table"
  type        = "number"
  default     = 20
}

variable "wcus" {
  description = "The write capacity units of the DynamoDB table"
  type        = "number"
  default     = 20
}

variable "hash_key" {
  description = "The hash key of the DynamoDB table"
  type        = string
  default     = "id"
}

variable "range_key" {
  description = "The range key of the DynamoDB table"
  type        = string
  default     = "name"
}

variable "attributes" {
  description = "The attributes of the DynamoDB table"
  type = list(object({
    attribute_name : string,
    attribute_type : string,
  }))
}

