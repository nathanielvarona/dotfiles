#!/bin/bash
# gpu-switch

# Check if the system is Darwin-based (macOS)
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is only for Apple macOS."
  exit 1
fi

case "$1" in
  integrated)
    gpu_mode=0
    ;;
  discrete)
    gpu_mode=1
    ;;
  dynamic)
    gpu_mode=2
    ;;
  *)
    echo "Usage: gpu-switch {integrated|discrete|dynamic}"
    exit 1
    ;;
esac

sudo pmset -a gpuswitch "$gpu_mode"
if [ $? -eq 0 ]; then
  echo "GPU switched to $1 successfully."
else
  echo "Failed to switch GPU. Please check pmset output and permissions."
fi
