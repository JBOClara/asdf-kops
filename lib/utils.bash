#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for kops.
GH_REPO="https://github.com/kubernetes/kops"
TOOL_NAME="kops"
TOOL_TEST="kops version"

fail() {
  echo -e "asdf-${TOOL_NAME}: $*"
  exit 1
}

detect_arch() {
  machine=$(arch)
  case "${machine}" in
  x86_64)
    echo "amd64"
    ;;
  aarch64)
    echo "arm64"
    ;;
  i386)
    echo "amd64"
    ;;
  *)
    echo "${machine}"
    ;;
  esac
}

detect_os() {
  case "$(uname)" in
  Linux)
    echo "linux"
    ;;
  Darwin)
    echo "darwin"
    ;;
  esac
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if kops is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token ${GITHUB_API_TOKEN}")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "${GH_REPO}" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # TODO: Adapt this. By default we simply list the tag names from GitHub releases.
  # Change this function if kops has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  # TODO: Adapt the release URL convention for kops
  # https://github.com/kubernetes/kops/releases/download/v1.26.0-alpha.1/kops-darwin-amd64
  # trunk-ignore(shellcheck/SC2311)
  # trunk-ignore(shellcheck/SC2312)
  url="${GH_REPO}/releases/download/v${version}/kops-$(detect_os)-$(detect_arch)"

  echo "* Downloading ${TOOL_NAME} release ${version}..."
  curl "${curl_opts[@]}" -o "${filename}" -C - "${url}" || fail "Could not download ${url}"
  chmod +x "${filename}"
  ls -lah "${filename}"
  file "${filename}"
  test -x "${filename}" || fail "Expected ${filename} to be executable."
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [[ "${install_type}" != "version" ]]; then
    fail "asdf-${TOOL_NAME} supports release installs only"
  fi

  (
    mkdir -p "${install_path}"

    # TODO: Assert kops executable exists.
    local tool_cmd
    tool_cmd="$(echo "${TOOL_TEST}" | cut -d' ' -f1)"
    cp -pr "${ASDF_DOWNLOAD_PATH}/${tool_cmd}-${version}" "${install_path}/${tool_cmd}"
    ls -lah "${install_path}/"
    test -x "${install_path}/${tool_cmd}" || fail "Expected ${install_path}/${tool_cmd} to be executable."

    echo "${TOOL_NAME} ${version} installation was successful!"
  ) || (
    rm -rf "${install_path}"
    fail "An error occurred while installing ${TOOL_NAME} ${version}."
  )
}
