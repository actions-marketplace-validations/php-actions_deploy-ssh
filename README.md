Deploy your application via SSH.
================================

> **THIS IS CURRENTLY WORK IN PROGRESS** - once v1 is released there will be no more major changes.

After a successful test run, this action can copy the project's files via SSH to another server, which could be an in-place deployment, or a fresh server that's set up for each deployment.

An example repository has been created at https://github.com/php-actions/example-deploy-ssh to show how to use this action in development and production projects.

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
```
