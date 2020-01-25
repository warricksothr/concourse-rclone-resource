# concourse-rclone-resource

A Concourse CI resource that executes [`rclone`](https://rclone.org/) 
against a remote host.

See [Docker Hub](https://cloud.docker.com/repository/docker/sothr/concourse-rclone-resource)
for tagged image versions available.

## Resource Type Configuration

```bash
resource_types:
- name: rclone
  type: docker-image
  source:
    repository: sothr/concourse-rclone-resource
    tag: latest
```

## Source Configuration

* `config`: Required. The rclone config file contents to use.
* `password`: Optional. Encryption password used for encrypted rclone configurations. Please use secrets management for this value.
* `files`: Optional. Additional files to write to the /tmp/rclone directory. This is a map of key/value pairs for the filename and contents of that file.

### Example

```bash
resources:
- name: rclone
  type: rclone
  source:
    config: |
      [remote]
      client_id = <Your ID>
      client_secret = <Your Secret>
      scope = drive
      root_folder_id = <Your root folder id>
      service_account_file = /tmp/rclone/serviceAccountFile
      token = {"access_token":"XXX","token_type":"Bearer","refresh_token":"XXX","expiry":"2014-03-16T13:57:58.955387075Z"}
    files:
      serviceAccountFile: |
        ...contents...
```

### Note

It's highly recommended to use secrets mangement to avoid storing sensitive credentials in the pipeline

## Behaviour

### `check`: No-Op

### `in`: No-Op

### `out`: Execute `rclone`

#### Parameters

* `source`: Required. The path to the source files.
* `destination`: Required. A list of destinations to copy files to.
    * `dir`: Required. A rclone destination for the files. ex. `remote:some/location`
    * `subdir`: Optional. A file that includes additional path information to be appended to the end of destination.
    * `dedupe`: Optional. Run `rsync dedupe` after syncing files. Default `false`
    * `dedupeMode`: Optional. The dedupe mode to use. Default `newest`. [rclone dedupe](https://rclone.org/commands/rclone_dedupe/)
      * skip
      * first
      * newest (default)
      * oldest
      * largest
      * rename
    * `link`: Optional. Create a link to the resource if possible. Default `false`
    * `linkFilter`: Optional. A find filter on the source directory for files to generate links to. Default `-maxdepth 1 -type f`
    * `linkDestination`: Optional. Required if `link` is specified as `true`. This is the rclone target to place the resulting link json data at.
* `args`: Optional. An array of additional arguments to pass to rclone.

#### Example

```bash
# Extends example in Source Configuration

jobs:
- name:
  plan:
  - do:
    - get: code # git resource
    - put: rclone
      params:
        source: code
        destination: 
          - dir: "remote:backup"
            subdir: code/target
          - dir: "remote2:release"
```

## License

Copyright 2020 Drew Short

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.