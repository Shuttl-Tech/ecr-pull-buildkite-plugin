# ECR Pull Buildkite Plugin

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) to pull Docker images from private ECR repository.

## Example

The following pipeline pulls the image with `latest` tag from ECR repository `my-repo`:

```yml
steps:
  - plugins:
      - Shuttl-Tech/ecr-pull#v1.0.0:
          repository: my-repo
```

Multiple tags can be pulled as well:

```yml
steps:
  - plugins:
      - Shuttl-Tech/ecr-pull#v1.0.0:
          repository: my-repo
          tags: [ "latest", "ft-1190" ]
```

## Configuration

- `repository` (required, string)

  Name of the ECR repository.

- `region` (optional, string)

  Region the ECR registry is in, defaults to `$AWS_DEFAULT_REGION` and then to the AWS region of build agent if not set.

- `tags` (optional, array|string)

  Tags to pull.

  Default: `latest`

## License

[BSD 3-Clause License](LICENSE)
