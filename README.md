# process-template bash script

Simple placeholder replacing tool based on bash which uses environment variables. Used for initialization of docker containers by Lundegaard.


## Usage

```
process-template [-f from-file] [-p placeholder-prefix] [-q] [-v] [-s] -t target-file
    -f | --from from-file      Template file to process. If not given, target is used as input.
    -t | --target target-file  Target file to write the result.
    -p | --prefix pattern      Prefix of the placeholders [Default: PLACEHOLDER_]
    -q | --quiet               Do not output any status messages
    -v | --verbose             Output detailed info including messages from log file
    -s | --strict              Exit with exitcode 4 when some placeholders in template are not in env
```

Script simply replaces placeholders in the template file with values from environment variables and writes the result into target file.

The script would try to replace all env variables, to avoid conflicts placeholders should have prefix (by default `PLACEHOLDER_`), so e.g. for env variable `PASS` is the placeholder `PLACEHOLDER_PASS`. Prefix is configurable via `-p` parameter.

If the resulting file still contains placeholders, you might want to fail, since some expected value was not in the env variables. Use `-s` parameter for this.

## Example

We have template in file `config.properties.tpl` like this:

```
db.user=PLACEHOLDER_DB_USER
db.pass=PLACEHOLDER_DB_PASS
```

and the script to generate the config might look like this:

```bash
export DB_USER=test
export DB_PASS=mySuperSecret

process-template -f config.properties.tpl -t config.properties
```

then resulting `config.properties` file would contain:

```
db.user=test
db.pass=mySuperSecret
```

## Tests

The script is tested using suite based on:

* https://github.com/sstephenson/bats/
* https://github.com/ztombol/bats-support
* https://github.com/ztombol/bats-assert

All these tools are ready in the `docker.lnd.bz/bats:latest` docker image.

Test suite can be easily run via the `process-template.test.sh` script.
