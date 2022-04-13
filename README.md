# Terraform for AWS and Azure

## Installation and Usage

### Installing the Collection

Before using the terraform_demo collection, you need to install it.
You can also include it in a `requirements.yml` file and install it via `ansible-galaxy collection install -r requirements.yml`, using the format:

```yaml
---
collections:
  - name: https://gitlab.com/redhatautomation/terraform_demo.git
    type: git
```
Be sure to check the role readme for additional configuration considerations. 

```yaml
# set these to match your configuration
vars:
  workspace: apache_dev
  aws_key: dev_aws_key
  terraform_s3_bucket: apache_dev_tfstate
  ec2_env: apache_dev_instances
```
Check the role defaults for other variables which can control provisioning details.  You should definitely set the above, we generally interact with the others through Surveys on the Automation Controller (Tower) as needed. 
### Using the collection
```yaml
---
- name: do things
  hosts: localhost
  gather_facts: no
  tasks:
    - name: do terraform things
      ansible.builtin.include_role:
        name: redhatautomation.terraform_demo.tf_provision
      tags:
        - template
```

