#!/bin/sh
# SPDX-License-Identifier: MIT
# Opt-in environment helper for testing the experimental Mesa PowerVR Volcanic
# (DXT-48-1536, BVNC 71.2.2448.1212) Vulkan ICD on Tensor G5 (laguna).
#
# Never sourced automatically by the session: stock llvmpipe / kms_swrast
# remains the safe default unless the owner explicitly opts in for a command:
#   source /usr/share/omamobile/pvr-volcanic/env.sh && vulkaninfo --summary
export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/powervr_mesa_icd.aarch64.json
export PVR_I_WANT_A_BROKEN_VULKAN_DRIVER=1
