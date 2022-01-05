# trv-mvn-fake

This docker image is built to workaround [trivy](https://github.com/aquasecurity/trivy) timeout problems while scanning an image (with jar inside) in air-gapped environment. This is a workaround, which replies 404 to `trivy` calls, so some security informations will certainly miss.

## Usage

TODO

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
