# VPC MODULE
This module is developed for joindevops company.Project inside the joindevops company will follows this module to create their VPC

## Inputs
* project (required/mandatory) -> users should specify their project name
* environment (required/mandatory) -> Users should specify thier environment
* cidr_block (optional) -> Users can provide their own CIDR Block. default is 10.0.0.0/16

## Outputs
vpc_id - Exportes, vpc id created...