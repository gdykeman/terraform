variable "rg_name" {
    type = string
    default = "prod-rg"
}
variable "rg_loc" {
    type = string
    default = "East US"
}
variable "network" {
    type = object({
        name = string
        cidr = list(string)
    })
    default = {
        name = "prod-network"
        cidr = ["10.0.0.0/16"]
    }
}