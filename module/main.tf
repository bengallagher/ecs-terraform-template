locals {
  # Set the service name to passed value, else use dynamic value.
  service_id = var.service_name != "demo" ? var.service_name : random_pet.this.id
}

# Create a random pet name for resource identification.
resource "random_pet" "this" {
  length = 2
}
