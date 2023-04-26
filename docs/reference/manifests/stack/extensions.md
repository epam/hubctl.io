# Section `extension`

## Referring another stack manifest file

Note: This is a good practice to split parameters from hub.yaml into it's own file params.yaml or even a series of params.yaml files. The parameter files can be referenced in hub.yaml as the following


extension:
  inclue:
  - params.yaml
