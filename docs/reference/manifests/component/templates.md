# Section `templates`

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

> Note: either `directory` or `files` must be specified

## Template Kind

Hubctl supports several kinds of templates

* `curly` - String replacement template with format `${param}` in the file. This is the default template kind.
* `mustache` - String replacement template with format `{{param}}`
* `go` - Go template with format `{{.param}}`

### Kind: `curly`

A simple syntax where parameter name for substitution is included between curly brackets `${}`, ie. `${kubernetes.api.endpoint}`.

Substitution may include encoding function `${param/encoding}` where `encoding` is one of:  `json`, `yaml`, `bcrypt`, `base64`. Multiple encodings are supported, processed in the order above: `${dex.passwordDb.password/bcrypt/base64}`.

### Kind: `mustache`

Parameter name enclosed in `{{}}`. Because of conflict with `.` special meaning in mustache, it must be replaced with `_`, for example `{{component_cert-manager_issuerEmail}}`.

## Kind: `go`
Full-featured [Golang templates](https://golang.org/pkg/text/template/) with `-` in parameter name replaced with `_`, for example `{{.cert_manager.issuerEmail}}`.

> Note: parameter name starts with `.` symbol

[Sprig Functions](http://masterminds.github.io/sprig/) are available for use in go templates.

### Best practice

* Use `template` file extension for `curly` or `mustache` templates
* Use `gotemplate` file extension for `go` templates

Before deployment, Hubctl will subtract template file extension and use the rest as a destination file name.

## See Also

* [Parameters](../parameters)
* [Component manifest](../)
* [Golang templates](https://golang.org/pkg/text/template/)
* [Sprig Functions](http://masterminds.github.io/sprig/)
