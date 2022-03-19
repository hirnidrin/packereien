# packereien

[Hashicorp Packer](https://www.packer.io/docs) templates.

## General usage

1. `cd` into a subdirectory
2. Adapt the main `.pkr.hcl` file if required. The templates have been tested, work without modification.
3. Have a look at the vars defined in `variables.pkr.hcl`
4. Create a `variables.auto.pkrvars.hcl` file to set/override var values, in the format:

   `var_one = "dingbats"`  
   `var_two = "barfi"`

5. Run `packer init -upgrade .` to check the config and pull plugins.
6. Run `packer build .` to build the template on the target system.

