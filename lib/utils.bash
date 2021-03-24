#!/usr/bin/env bash

set -xeuo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for ansible.
GH_REPO="https://github.com/ansible/ansible"
GH_API_REPO="https://api.github.com/repos/ansible/ansible"

fail() {
  echo -e "asdf-ansible: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if ansible is not hosted on GitHub releases.
# if [ -n "${GITHUB_API_TOKEN:-}" ]; then
#   curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
# fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
#   git ls-remote --tags --refs "$GH_REPO" |
#     grep -o 'refs/tags/.*' | cut -d/ -f3- |
#     sed 's/^v//' | grep -E '^[0-9a-z\.\-]+' # NOTE: You might want to adapt this sed to remove non-version strings from tags
  curl -L -s 'https://pypi.org/pypi/ansible/json' | jq  -r '.releases | keys | .[]' | sort -V
}

list_all_versions() {
  # TODO: Adapt this. By default we simply list the tag names from GitHub releases.
  # Change this function if ansible has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  # TODO: Adapt the release URL convention for ansible
  url="$GH_REPO/archive/v${version}.tar.gz"

  echo "* Downloading ansible release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-ansible supports release installs only"
  fi

  if [ "$version" == 'latest' ]; then
    version=$(list_github_tags | tail -n1)
    # version=$(curl -s "$GH_API_REPO/releases/latest" | jq '.tag_name' -r | sed 's/^v//')
  fi

  # TODO: Adapt this to proper extension and adapt extracting strategy.
  local release_file="$install_path/ansible-$version.tar.gz"
  (
    # mkdir -p "$install_path"
    # download_release "$version" "$release_file"
    # tar -xzf "$release_file" -C "$install_path" --strip-components=1 || fail "Could not extract $release_file"
    # rm "$release_file"
    pip install ansible=="$version"

    # TODO: Asert ansible executable exists.
    local tool_cmd
    tool_cmd="$(echo "ansible --version" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    test $("$install_path/bin/$tool_cmd" --version | grep -E '^ansible [0-9a-z\.\-]+' | cut -d ' ' -f 2) == "$version"

    echo "ansible $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing ansible $version."
  )
}
