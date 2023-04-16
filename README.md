### [librivox-localhost](https://github.com/warren-bank/librivox-localhost)

#### Description:

The goal of this repo is to provide a local portable Win64 development environment for testing changes to the [Librivox catalog](https://github.com/LibriVox/librivox-catalog).
My immediate interest is in testing the [API](https://librivox.org/api/info) endpoints.

#### Install server:

1. via script
   ```bash
     call bin\1_install_server.bat
   ```
2. via prebuilt release
   * [download](https://github.com/warren-bank/librivox-localhost/releases) the file: `Laragon.7z`
   * unzip into the directory: `dist\PortableApps`

#### Restart server:

```bash
  call bin\2_restart_server.bat
```

#### Query server:

```bash
  curl "http://librivox.org.test/api/feed/audiobooks/?id=52"
```

#### Update catalog PHP:

```bash
  call bin\3_update_catalog_php.bat
```

#### Legal:

* copyright: [Warren Bank](https://github.com/warren-bank)
* license: [GPL-2.0](https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt)
