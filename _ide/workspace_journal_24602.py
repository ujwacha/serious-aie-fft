# 2026-10-22T10:48:21.197313396
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

comp = client.create_hls_component(name = "central-controller-element",part = "xa7z020clg484-1Q",cfg_file = ["hls_config.cfg"],template = "empty_hls_component")

vitis.dispose()

