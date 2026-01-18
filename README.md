# puck

**puck** is an AppJail application that uses a very restricted, ephemeral jail to convert a potentially suspicious PDF into a trustworthy one.

This application is basically a few patches for [qubes-app-linux-pdf-converter](https://github.com/QubesOS/qubes-app-linux-pdf-converter), so you are essentially using the original application; the patches are only necessary to make it work on FreeBSD. There is one subtle difference: both the client and server run inside the jail, so no dependencies need to be installed for the client to work. Just run the Makejail file as described below.

For more details, please see the article in which this concept was originally introduced:

http://blog.invisiblethings.org/2013/02/21/converting-untrusted-pdfs-into-trusted.html

## How to use this Makejail

```console
# appjail makejail \
    -f gh+AppJail-makejails/puck \
    -- \
    --puck_file /path/to/your/suspicious/file.pdf
...
# xdg-open file.trusted.pdf
...
```

### Arguments

* `puck_file` (mandatory): Suspicious PDF file.
* `puck_output` (default: `${APPJAIL_PWD}`): Output file or directory. The current directory is used by default.
* `puck_nostop` (optional): Don't stop the jail.
* `puck_ajspec` (default: `gh+AppJail-makejails/puck`): Entry point where the `appjail-ajspec(5)` file is located.
* `puck_tag` (default: `14.3`): see [#tags](#tags).

### Environment

* `PUCK_RESOLUTION` (default: `300`): Resolution of output.
* `PUCK_BATCH` (default: `50`): Maximum number of conversion tasks.
* `PUCK_COMPRESSION` (default: `1`): Enable compression. Set this environment variable to `0` to disable compression.
* `PUCK_COMPRESSION_WITH_GRAYSCALE` (default: `0`): Enable grayscale conversion which can further reduce output size.
* `PUCK_COMPRESSION_RESOLUTION` (default: `72`): Resolution in DPI.

## Tags

| Tag           | Arch    | Version            | Type   |
| ------------- | --------| ------------------ | ------ |
| `14.3`    | `amd64` | `14.3-RELEASE` | `thin` |
| `15`    | `amd64` | `15` | `thin` |
