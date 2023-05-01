# Templates


```yaml
templates:
  kind: curly                         # mandatory, mustache go
  directories:                        # optional, list of directories to search for templates
  - config                            # example of directory name
  files:                              # mandatory, list of template files, supports globs
  - "*.template"                      # example of template files in current component directory
  extra:                              # optional, to support multiple template kinds
  - kind: mustache                    # optional, additional template kind
    files:                            # mandatory, list of template files, supports globs
    - terraform/*.tfvars.template     # example of Terraform variable templates in directory `terraform`
  - kind: go                          # example of Go template
    files:                            
    - helm/values*.yaml.gotemplate    # example of Helm values template
```

## Template Kind

Hubctl supports several kinds of templates

* `curly` - String replacement template with format `${param}` in the file. This is the default template kind.
* `mustache` - String replacement template with format `{{param}}`
* `go` - Go template with format `{{.param}}`

### Best practice

* Use `template` file extension for `curly` or `mustache` templates
* Use `gotemplate` file extension for `go` templates

Before deployment, Hubctl will subtract template file extension and use the rest as a destination file name.

## See Also

* [Parameters](../parameters)
* [Component manifest](../)
