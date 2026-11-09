# 2026-10-23T06:41:22.042033577
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

vitis.dispose()

