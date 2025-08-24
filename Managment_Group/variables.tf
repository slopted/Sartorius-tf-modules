variable "display_name" {
    description = "Name for the management group."
    type        = string
    default     = "ParentGroup"
}

variable "parent_management_group_id" {
    description = "ID of the parent management group. If not provided, the group will be root."
    type        = string
    default     = null
}
