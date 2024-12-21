#!/bin/bash
#
# Dive into each directory of the source dir and create the a dir of the same name on the destination,
# then hardlink each file from source to the destination
#

version=1.1.0

_usage() {
  cat <<USAGE
Try '$(basename "${BASH_SOURCE[0]}") --help' for more information.
USAGE
}

_version() {
cat <<VERSION
$(basename "${BASH_SOURCE[0]}") $version
VERSION
}

_help() {
cat <<HELP
Usage: $(basename "${BASH_SOURCE[0]}") [Options]... SOURCE DEST

Hardlink multiple SOURCE(s) to DEST(s)

Required parameters:
        SOURCE          The source directory containing subdirectories and files to be hardlinked.
                        Must be an existing directory.

        DEST            The destination directory where the subdirectories and files will be hardlinked.
                        If it does not exist, it will be created.

Optional parameters:
        -h, --help      Show this help and exit
        -v, --version   Print script version and exit

Example usage:
        $(basename "${BASH_SOURCE[0]}") /mnt/nfs1/downloads/manga /mnt/nfs1/media/manga
HELP
}

check_for_update() {
return
}

parse_args() {
        args=()

while :;
do
        case ${1:-} in
        -h | --help) _help; exit 0;;
        -v | --version) _version; exit 0;;
        -*) printf >&2 "Error: Unknown option: %s.\n%s\n" "$1" "$(_usage)"; exit 1;;
        *)
                if [ -n "$1" ]
                then
                        args+=("$1")
                else
                        break
                fi
                ;;
        esac
        shift
done
}

parse_args "${@}"

if [ ${#args[@]} -lt 2 ]; then
        printf >&2 "Error: 2 positional parameters required.\n%\n" "$(_usage)"
        exit 1
fi

set -u

source_dir="${args[0]}"
destination_dir="${args[1]}"
ln_args="-f"

if [ ! -d "$source_dir" ]
then
        printf >&2 "Error: SOURCE directory '%s' does not exist or is not a directory.\n" "$source_dir"
        exit 1
fi

for dir in $source_dir/*
do
  mkdir -p "$destination_dir/$(basename "$dir")" || {
        printf >&2 "Error: Could not create directory '%s'.\n" "$destination_dir/$(basename "$dir")"
        exit 1
  }
  for file in "$dir"/*
  do
        if [ -f "$file" ]
        then
                ln ${ln_args} "${file}" "$destination_dir/$(basename "$dir")/$(basename "$file")"
        else
                printf "Skipping non-regular file: %s\n" "$file"
        fi
  done
done

echo "Done"
