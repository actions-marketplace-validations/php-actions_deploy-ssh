Deploy your application to servers or containers
================================================

> **THIS IS CURRENTLY WORK IN PROGRESS** - once v1 is released there will be no more major changes.

After a successful test run, this action can copy the project's files via SSH to another server, a remote Docker container, or into a fresh server.

An example repository has been created at https://github.com/php-actions/example-deploy to show how to use this action in development and production projects.

Usage
-----

Create your Github Workflow configuration in `.github/workflows/ci.yml` or similar.

```yml
name: CI

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      # Load the pre-build project files:
      - uses: actions/download-artifact@v3
        with:
          name: build-artifact
          path: /tmp/github-actions
    
      # Then deploy to your server of choice
      - uses: php-actions/deploy
        with:
          hostname: deploy.example.com
          user: webdeploy
          path: /var/www/example.com
          ssh_key: {{ secrets.deploy_ssh_key }}
```

To generate an SSH key pair (private and public) using the RSA algorithm, `ssh-keygen -t rsa -b 4096 -C "deploy@github-acions"`. To convert a key pair into PEM format, `ssh-keygen -f actions_rsa -e -m pem` - then paste the contents of the generated PEM file into your project's Github Secrets.

// TODO: Document post-transfer script, how it might need adding to sudoers if sudo is required.
