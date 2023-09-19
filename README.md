# Composite Update Site Builder

This scripts allows you to create a single update site that contains multiple update sites, e.g. the official KNIME extensions and your own extensions.

## How to use

Call the `composite-generator.sh` script with the following parameters:

- `-n` the name of the composite update site
- `-d` the directory where the composite update site should be created in
- `-c` the space separated list of update sites that should be included in the composite update site
  - These can be either local directories or URLs to remote update sites
  - If you are hosting the update site on a web server, use relative paths to the location of the generated composite update site on the server

## Examples

### Composite update that contains two local update sites

Prerequisite: `local-one` and `local-two` are directories that contain an update site each,
and are located at `/path/to/output/local-one` and `/path/to/output/local-two`
respectively.

```bash
./composite-generator.sh -n "My local Composite Update site" -d /path/to/output -c "local-one local-two"
```

After the script has been run, the following directory structure will be created:

```shell
/path/to/output
├── compositeArtifacts.jar
├── compositeContent.jar
├── p2.index
├── local-one
│   ├── artifacts.jar
│   ├── content.jar
│   ├── plugins/
│   ├── features/
│   └── p2.index
└── local-two
   ├── artifacts.jar
   ├── content.jar
   ├── plugins/
   ├── features/
   └── p2.index
```

Configuring the composite update site in KNIME Analytics Platform will allow you to install all extensions from both local update sites.

### Other examples 

#### Composite update that contains a remote update site and a local update site

```bash
./composite-generator.sh -n "My mixed composite Update site" -d /path/to/output -c "local-one https://update.knime.com/analytics-platform/5.1"
```

#### Composite update that contains a remote update site and a local update site that is hosted on a web server

```bash
./composite-generator.sh -n "My remote composite Update site" -d /path/to/output -c "http://intranet.example.com/updatesite https://update.knime.com/analytics-platform/5.1"
```
