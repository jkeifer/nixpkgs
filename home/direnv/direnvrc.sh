layout_python_uv() {
  local python python_version

  python="${1:-python}"
  [ $# -gt 0 ] && shift

  unset PYTHONHOME

  python_version="$("$python" -c "import platform; print(platform.python_version())")"
  if [ -z "$python_version" ]; then
      log_error "Could not find python version"
      return 1
  fi

  VIRTUAL_ENV="$(direnv_layout_dir)/python-$python_version"
  if [ ! -d "$VIRTUAL_ENV" ]; then
      uv venv -p $python "$@" "$VIRTUAL_ENV"
  fi

  export VIRTUAL_ENV
  export UV_PYTHON="${VIRTUAL_ENV}/bin/python"
  PATH_add "${VIRTUAL_ENV}/bin"
}
